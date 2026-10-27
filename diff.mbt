///|
priv struct DiffUnit {
  token : Json
  attributes : Json
  offset : Int32
  width : Int32
}

///|
/// Produce a change from this full document to `target`. Text is compared in
/// UTF-16 code units, while embeds are single indivisible units. Formatting
/// differences become retain operations with attribute changes.
pub fn Delta::diff(self : Delta, target : Delta) -> Delta raise DeltaError {
  if !self.is_document() || !target.is_document() {
    raise Invalid("diff requires two insert-only documents")
  }
  let old_units = self.diff_units()
  let new_units = target.diff_units()
  let n = old_units.length()
  let m = new_units.length()
  let result = Delta::new()
  let mut prefix = 0
  while prefix < n &&
        prefix < m &&
        old_units[prefix].token == new_units[prefix].token {
    append_matched_unit(result, old_units[prefix], new_units[prefix])
    prefix += 1
  }
  let mut suffix = 0
  while suffix < n - prefix &&
        suffix < m - prefix &&
        old_units[n - suffix - 1].token == new_units[m - suffix - 1].token {
    suffix += 1
  }
  let old_middle = n - prefix - suffix
  let new_middle = m - prefix - suffix
  let old_start = if prefix < n {
    old_units[prefix].offset
  } else {
    self.length()
  }
  let new_start = if prefix < m {
    new_units[prefix].offset
  } else {
    target.length()
  }
  let old_end = if suffix > 0 {
    old_units[n - suffix].offset
  } else {
    self.length()
  }
  let new_end = if suffix > 0 {
    new_units[m - suffix].offset
  } else {
    target.length()
  }
  if old_middle == 0 {
    for op in target.slice(new_start, new_end).ops {
      ignore(result.push(op))
    }
  } else if new_middle == 0 {
    ignore(result.delete(old_end - old_start))
  } else if old_middle.to_int64() * new_middle.to_int64() > 1000000L {
    ignore(result.delete(old_end - old_start))
    for op in target.slice(new_start, new_end).ops {
      ignore(result.push(op))
    }
  } else {
    append_middle_diff(
      result, target, old_units, new_units, prefix, old_middle, new_middle,
    )
  }
  for index in 0..<suffix {
    append_matched_unit(
      result,
      old_units[n - suffix + index],
      new_units[m - suffix + index],
    )
  }
  result.chop()
}

///|
fn append_matched_unit(result : Delta, old : DiffUnit, new : DiffUnit) -> Unit {
  ignore(
    result.retain(old.width, attributes_diff(old.attributes, new.attributes)),
  )
}

///|
fn append_middle_diff(
  result : Delta,
  target : Delta,
  old_units : Array[DiffUnit],
  new_units : Array[DiffUnit],
  start : Int32,
  n : Int32,
  m : Int32,
) -> Unit {
  let rows : Array[Array[Int32]] = []
  for _ in 0..<=n {
    rows.push(Array::make(m + 1, 0))
  }
  let mut i = n - 1
  while i >= 0 {
    let mut j = m - 1
    while j >= 0 {
      rows[i][j] = if old_units[start + i].token == new_units[start + j].token {
        rows[i + 1][j + 1] + 1
      } else if rows[i + 1][j] > rows[i][j + 1] {
        rows[i + 1][j]
      } else {
        rows[i][j + 1]
      }
      j -= 1
    }
    i -= 1
  }
  i = 0
  let mut j = 0
  while i < n || j < m {
    if i < n &&
      j < m &&
      old_units[start + i].token == new_units[start + j].token {
      append_matched_unit(result, old_units[start + i], new_units[start + j])
      i += 1
      j += 1
    } else if j < m && (i == n || rows[i][j + 1] >= rows[i + 1][j]) {
      let unit = new_units[start + j]
      for op in target.slice(unit.offset, unit.offset + unit.width).ops {
        ignore(result.push(op))
      }
      j += 1
    } else {
      ignore(result.delete(old_units[start + i].width))
      i += 1
    }
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
