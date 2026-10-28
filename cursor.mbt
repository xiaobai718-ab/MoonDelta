///|
/// A UTF-16 range in a document. The index and length must be nonnegative
/// and lie within the document passed to diff_with_cursor_info.
pub(all) struct CursorRange {
  index : Int32
  length : Int32
}

///|
pub fn CursorRange::new(index : Int32, length : Int32) -> CursorRange {
  { index, length, }
}

///|
/// Before-and-after selection ranges accepted by Quill Delta's diff cursor
/// option. A selected old range followed by a zero-length new range denotes
/// replacement of the selection, with the new index at the resulting caret.
pub(all) struct CursorInfo {
  old_range : CursorRange
  new_range : CursorRange
}

///|
pub fn CursorInfo::new(
  old_range : CursorRange,
  new_range : CursorRange,
) -> CursorInfo {
  { old_range, new_range, }
}

///|
/// Use Quill's selected-range cursor convention, or explicit old/new edit
/// ranges when they align with otherwise unchanged content.
pub fn Delta::diff_with_cursor_info(
  self : Delta,
  target : Delta,
  cursor : CursorInfo,
) -> Delta raise DeltaError {
  if physical_equal(self.ops, target.ops) { return Delta::new() }
  let old_range = cursor.old_range
  let new_range = cursor.new_range
  if old_range.length == 0 && new_range.length == 0 {
    return self.diff_at_carets(target, old_range.index, Some(new_range.index))
  }
  if old_range.length > 0 && new_range.length == 0 &&
    old_range.index >= 0 && old_range.length >= 0 &&
    old_range.index.to_int64() + old_range.length.to_int64() <=
    self.length().to_int64() {
    let suffix_length = self.length() - old_range.index - old_range.length
    let new_middle_length = target.length().to_int64() -
      old_range.index.to_int64() - suffix_length.to_int64()
    if new_middle_length >= 0L && new_middle_length <= 2147483647L {
      return self.diff_splice(
        target,
        old_range,
        CursorRange::new(old_range.index, new_middle_length.to_int()),
      )
    }
  }
  self.diff_splice(target, old_range, new_range)
}

///|
fn Delta::diff_splice(
  self : Delta,
  target : Delta,
  old_range : CursorRange,
  new_range : CursorRange,
) -> Delta raise DeltaError {
  if !self.is_document() || !target.is_document() {
    raise Invalid("diff requires two insert-only documents")
  }
  if old_range.index < 0 ||
    old_range.length < 0 ||
    new_range.index < 0 ||
    new_range.length < 0 ||
    old_range.index.to_int64() + old_range.length.to_int64() >
    self.length().to_int64() ||
    new_range.index.to_int64() + new_range.length.to_int64() >
    target.length().to_int64() {
    return self.diff(target)
  }
  let old_end = old_range.index + old_range.length
  let new_end = new_range.index + new_range.length
  let old_units = self.diff_units()
  let new_units = target.diff_units()
  let old_start_unit = unit_index_at(old_units, old_range.index, self.length())
  let old_end_unit = unit_index_at(old_units, old_end, self.length())
  let new_start_unit = unit_index_at(
    new_units,
    new_range.index,
    target.length(),
  )
  let new_end_unit = unit_index_at(new_units, new_end, target.length())
  if old_start_unit < 0 ||
    old_end_unit < 0 ||
    new_start_unit < 0 ||
    new_end_unit < 0 ||
    old_start_unit != new_start_unit ||
    old_units.length() - old_end_unit != new_units.length() - new_end_unit {
    return self.diff(target)
  }
  let old_keys = diff_keys(old_units)
  let new_keys = diff_keys(new_units)
  if !placeholder_range_equal(
    old_keys, 0, old_start_unit, new_keys, 0, new_start_unit,
  ) { return self.diff(target) }
  for index in 0..<(old_units.length() - old_end_unit) {
    if old_keys[old_end_unit + index] != new_keys[new_end_unit + index] {
      return self.diff(target)
    }
  }
  let result = Delta::new()
  for index in 0..<old_start_unit {
    append_matched_unit(result, old_units[index], new_units[index], target)
  }
  let old_middle = old_end_unit - old_start_unit
  let new_middle = new_end_unit - new_start_unit
  let mut same_middle = old_middle == new_middle
  if same_middle {
    for index in 0..<old_middle {
      if old_units[old_start_unit + index].token !=
        new_units[new_start_unit + index].token {
        same_middle = false
        break
      }
    }
  }
  if same_middle {
    for index in 0..<old_middle {
      append_matched_unit(
        result,
        old_units[old_start_unit + index],
        new_units[new_start_unit + index],
        target,
      )
    }
  } else {
    if old_range.length > 0 {
      ignore(result.delete(old_range.length))
    }
    if new_range.length > 0 {
      for op in target.slice(new_range.index, new_end).ops {
        ignore(result.push(op))
      }
    }
  }
  for index in 0..<(old_units.length() - old_end_unit) {
    append_matched_unit(
      result,
      old_units[old_end_unit + index],
      new_units[new_end_unit + index],
      target,
    )
  }
  result.chop()
}

///|
fn unit_index_at(
  units : Array[DiffUnit],
  offset : Int32,
  total : Int32,
) -> Int32 {
  if offset == total {
    return units.length()
  }
  for index, unit in units {
    if unit.offset == offset {
      return index
    }
  }
  -1
}
