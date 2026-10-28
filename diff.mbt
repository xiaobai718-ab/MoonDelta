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
  if physical_equal(self.ops, target.ops) {
    return Delta::new()
  }
  if !self.is_document() || !target.is_document() {
    raise Invalid("diff requires two insert-only documents")
  }
  self.diff_fast(target)
}

///|
fn diff_keys(units : Array[DiffUnit]) -> Array[Int32] {
  let keys : Array[Int32] = []
  for unit in units {
    match unit.token {
      Number(value, ..) => keys.push(value.to_int())
      _ => keys.push(0)
    }
  }
  keys
}

///|
fn append_matched_unit(
  result : Delta,
  old : DiffUnit,
  new : DiffUnit,
  target : Delta,
) -> Unit {
  if old.token != new.token {
    for op in target.slice(new.offset, new.offset + new.width).ops {
      ignore(result.push(op))
    }
    ignore(result.delete(old.width))
  } else {
    ignore(
      result.retain(old.width, attributes_diff(old.attributes, new.attributes)),
    )
  }
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
/// Diff with the cursor convention used by fast-diff: first try an edit
/// immediately before the old caret, then an edit immediately after it.
/// The hint is ignored when neither splice produces the target text.
pub fn Delta::diff_at(
  self : Delta,
  target : Delta,
  cursor : Int32,
) -> Delta raise DeltaError {
  self.diff_at_carets(target, cursor, None)
}

///|
fn Delta::diff_at_carets(
  self : Delta,
  target : Delta,
  cursor : Int32,
  desired_new_caret : Int32?,
) -> Delta raise DeltaError {
  if physical_equal(self.ops, target.ops) {
    return Delta::new()
  }
  if !self.is_document() || !target.is_document() {
    raise Invalid("diff requires two insert-only documents")
  }
  if cursor < 0 || cursor > self.length() {
    return self.diff(target)
  }
  let old_units = self.diff_units()
  let new_units = target.diff_units()
  let old_keys = diff_keys(old_units)
  let new_keys = diff_keys(new_units)
  let old_caret = unit_index_at(old_units, cursor, self.length())
  if old_caret < 0 {
    return self.diff(target)
  }
  let after_caret64 = cursor.to_int64() +
    target.length().to_int64() -
    self.length().to_int64()
  if after_caret64 >= 0L && after_caret64 <= target.length().to_int64() {
    let new_caret_position = after_caret64.to_int()
    let new_caret = unit_index_at(
      new_units,
      new_caret_position,
      target.length(),
    )
    let caret_matches = match desired_new_caret {
      None => true
      Some(value) => value == new_caret_position
    }
    if new_caret >= 0 && caret_matches {
      let start = if cursor < new_caret_position {
        cursor
      } else {
        new_caret_position
      }
      let old_start = unit_index_at(old_units, start, self.length())
      let new_start = unit_index_at(new_units, start, target.length())
      if old_start >= 0 &&
        new_start >= 0 &&
        placeholder_range_equal(old_keys, 0, old_start, new_keys, 0, new_start) &&
        placeholder_range_equal(
          old_keys,
          old_caret,
          old_keys.length(),
          new_keys,
          new_caret,
          new_keys.length(),
        ) {
        return self.diff_splice(
          target,
          CursorRange::new(start, cursor - start),
          CursorRange::new(start, new_caret_position - start),
        )
      }
    }
  }
  let new_caret = unit_index_at(new_units, cursor, target.length())
  let after_caret_matches = match desired_new_caret {
    None => true
    Some(value) => value == cursor
  }
  if new_caret >= 0 &&
    after_caret_matches &&
    placeholder_range_equal(old_keys, 0, old_caret, new_keys, 0, new_caret) {
    let old_after = self.length() - cursor
    let new_after = target.length() - cursor
    let suffix_length = if old_after < new_after {
      old_after
    } else {
      new_after
    }
    let old_suffix_start = self.length() - suffix_length
    let new_suffix_start = target.length() - suffix_length
    let old_suffix = unit_index_at(old_units, old_suffix_start, self.length())
    let new_suffix = unit_index_at(new_units, new_suffix_start, target.length())
    if old_suffix >= 0 &&
      new_suffix >= 0 &&
      placeholder_range_equal(
        old_keys,
        old_suffix,
        old_keys.length(),
        new_keys,
        new_suffix,
        new_keys.length(),
      ) {
      return self.diff_splice(
        target,
        CursorRange::new(cursor, old_suffix_start - cursor),
        CursorRange::new(cursor, new_suffix_start - cursor),
      )
    }
  }
  self.diff(target)
}

///|
fn placeholder_range_equal(
  old : Array[Int32],
  old_start : Int32,
  old_end : Int32,
  new : Array[Int32],
  new_start : Int32,
  new_end : Int32,
) -> Bool {
  if old_end - old_start != new_end - new_start {
    return false
  }
  for index in 0..<(old_end - old_start) {
    if old[old_start + index] != new[new_start + index] {
      return false
    }
  }
  true
}
