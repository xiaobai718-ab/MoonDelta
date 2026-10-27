///|
priv struct DiffUnit {
  token : Json
  attributes : Json
  offset : Int32
  width : Int32
}

///|
/// Produce the edits that turn one complete document into another. Myers diff
/// compares Unicode scalar values and indivisible embeds; offsets and lengths
/// in the resulting Delta are measured in UTF-16 code units.
pub fn Delta::diff(self : Delta, target : Delta) -> Delta raise DeltaError {
  if !self.is_document() || !target.is_document() {
    raise Invalid("diff requires two insert-only documents")
  }
  let old_units = self.diff_units()
  let new_units = target.diff_units()
  let embeds : Array[Json] = []
  let old_keys = diff_keys(old_units, embeds)
  let new_keys = diff_keys(new_units, embeds)
  let edits = @diff.Diff(old=old_keys[:], new=new_keys[:]).edits()
  let result = Delta::new()
  for edit in edits {
    match edit {
      @diff.Equal(old_index~, new_index~, len~) =>
        for index in 0..<len {
          append_matched_unit(
            result, old_units[old_index + index], new_units[new_index + index],
          )
        }
      @diff.Delete(old_index~, old_len~, ..) =>
        for index in old_index..<(old_index + old_len) {
          ignore(result.delete(old_units[index].width))
        }
      @diff.Insert(new_index~, new_len~, ..) =>
        for index in new_index..<(new_index + new_len) {
          let unit = new_units[index]
          for op in target.slice(unit.offset, unit.offset + unit.width).ops {
            ignore(result.push(op))
          }
        }
    }
  }
  result.chop()
}

///|
fn diff_keys(units : Array[DiffUnit], embeds : Array[Json]) -> Array[Int32] {
  let keys : Array[Int32] = []
  for unit in units {
    match unit.token {
      Number(value, ..) => keys.push(value.to_int())
      _ => {
        let mut found = -1
        for index in 0..<embeds.length() {
          if embeds[index] == unit.token {
            found = index
            break
          }
        }
        if found < 0 {
          embeds.push(unit.token)
          found = embeds.length() - 1
        }
        keys.push(-found - 1)
      }
    }
  }
  keys
}

///|
fn append_matched_unit(result : Delta, old : DiffUnit, new : DiffUnit) -> Unit {
  ignore(
    result.retain(old.width, attributes_diff(old.attributes, new.attributes)),
  )
}

///|
fn Delta::diff_units(self : Delta) -> Array[DiffUnit] {
  let result : Array[DiffUnit] = []
  let mut offset = 0
  for op in self.ops {
    match op {
      InsertText(text, attrs) =>
        for char in text.iter() {
          let code = char.to_int()
          let width = if code > 65535 { 2 } else { 1 }
          result.push({
            token: Json::number(code.to_double()),
            attributes: attrs,
            offset,
            width,
          })
          offset += width
        }
      InsertEmbed(embed, attrs) => {
        result.push({ token: embed, attributes: attrs, offset, width: 1, })
        offset += 1
      }
      _ => ()
    }
  }
  result
}


///|
/// Diff with a UTF-16 cursor hint. For a single pure insertion or deletion,
/// choose the valid edit location nearest the cursor in the original document.
/// This resolves ambiguous repeated text in favor of the user's edit position.
/// Other changes use the regular Myers diff.
pub fn Delta::diff_at(
  self : Delta,
  target : Delta,
  cursor : Int32,
) -> Delta raise DeltaError {
  if !self.is_document() || !target.is_document() {
    raise Invalid("diff requires two insert-only documents")
  }
  if cursor < 0 || cursor > self.length() {
    return self.diff(target)
  }
  let old_units = self.diff_units()
  let new_units = target.diff_units()
  let old_length = old_units.length()
  let new_length = new_units.length()
  if old_length == new_length {
    return self.diff(target)
  }
  let embeds : Array[Json] = []
  let old_keys = diff_keys(old_units, embeds)
  let new_keys = diff_keys(new_units, embeds)
  let mut best = -1
  let mut best_distance = 2147483647
  if new_length > old_length {
    let added = new_length - old_length
    let prefix_ok = Array::make(old_length + 1, false)
    let suffix_ok = Array::make(old_length + 1, false)
    prefix_ok[0] = true
    suffix_ok[old_length] = true
    for index in 0..<old_length {
      prefix_ok[index + 1] = prefix_ok[index] && old_keys[index] == new_keys[index]
    }
    for step in 0..<old_length {
      let index = old_length - step - 1
      suffix_ok[index] = suffix_ok[index + 1] &&
        old_keys[index] == new_keys[index + added]
    }
    for candidate in 0..=old_length {
      if prefix_ok[candidate] && suffix_ok[candidate] {
        let position = if candidate < old_length {
          old_units[candidate].offset
        } else {
          self.length()
        }
        let distance = if position >= cursor {
          position - cursor
        } else {
          cursor - position
        }
        if distance < best_distance {
          best = candidate
          best_distance = distance
        }
      }
    }
    if best >= 0 {
      let result = Delta::new()
      for index in 0..<best {
        append_matched_unit(result, old_units[index], new_units[index])
      }
      for index in best..<(best + added) {
        let unit = new_units[index]
        for op in target.slice(unit.offset, unit.offset + unit.width).ops {
          ignore(result.push(op))
        }
      }
      for index in best..<old_length {
        append_matched_unit(result, old_units[index], new_units[index + added])
      }
      return result.chop()
    }
  } else {
    let removed = old_length - new_length
    let prefix_ok = Array::make(new_length + 1, false)
    let suffix_ok = Array::make(new_length + 1, false)
    prefix_ok[0] = true
    suffix_ok[new_length] = true
    for index in 0..<new_length {
      prefix_ok[index + 1] = prefix_ok[index] && old_keys[index] == new_keys[index]
    }
    for step in 0..<new_length {
      let index = new_length - step - 1
      suffix_ok[index] = suffix_ok[index + 1] &&
        old_keys[index + removed] == new_keys[index]
    }
    for candidate in 0..=new_length {
      if prefix_ok[candidate] && suffix_ok[candidate] {
        let position = old_units[candidate].offset
        let distance = if position >= cursor {
          position - cursor
        } else {
          cursor - position
        }
        if distance < best_distance {
          best = candidate
          best_distance = distance
        }
      }
    }
    if best >= 0 {
      let result = Delta::new()
      for index in 0..<best {
        append_matched_unit(result, old_units[index], new_units[index])
      }
      for index in best..<(best + removed) {
        ignore(result.delete(old_units[index].width))
      }
      for index in best..<new_length {
        append_matched_unit(result, old_units[index + removed], new_units[index])
      }
      return result.chop()
    }
  }
  self.diff(target)
}
