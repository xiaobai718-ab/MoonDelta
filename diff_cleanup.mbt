///|
fn overlap_is_substantial(
  overlap : Int32,
  deleted : Int32,
  inserted : Int32,
) -> Bool {
  overlap > 0 && (overlap * 2 >= deleted || overlap * 2 >= inserted)
}

///|
/// Length of the longest suffix of `left` that is a prefix of `right`.
fn common_overlap(left : String, right : String) -> Int32 {
  let limit = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  let mut candidate = limit
  while candidate > 0 {
    if left[left.length() - candidate:] == right[:candidate] &&
      valid_utf16_cut(left, left.length() - candidate) &&
      valid_utf16_cut(right, candidate) {
      return candidate
    }
    candidate -= 1
  }
  0
}

///|
fn valid_utf16_cut(text : String, offset : Int32) -> Bool {
  if offset <= 0 || offset >= text.length() {
    return true
  }
  let before = text.at(offset - 1).to_int()
  let after = text.at(offset).to_int()
  !(before >= 0xD800 && before <= 0xDBFF && after >= 0xDC00 && after <= 0xDFFF)
}
