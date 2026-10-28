///|
test "fast-diff core returns a replacement for unrelated characters" {
  let edits = fast_diff_text("a", "b")
  assert_eq(edits.length(), 2)
  assert_eq(edits[0].kind, -1)
  assert_eq(edits[0].text, "a")
  assert_eq(edits[1].kind, 1)
  assert_eq(edits[1].text, "b")
}

///|
test "fast-diff emoji replacement" {
  let edits = fast_diff_text("a😀b", "a🚀b")
  assert_eq(edits[0].text, "a")
  assert_eq(edits[1].kind, -1)
  assert_eq(edits[1].text, "😀")
  assert_eq(edits[2].kind, 1)
  assert_eq(edits[2].text, "🚀")
  assert_eq(edits.length(), 4)
  assert_eq(edits[3].text, "b")
}

///|
test "MoonBit strings can represent isolated surrogate halves" {
  let high_code : Int32 = 0xD83D
  let low_code : Int32 = 0xDE00
  let high = String::from_array([high_code.unsafe_to_char()])
  let low = String::from_array([low_code.unsafe_to_char()])
  assert_eq(high.length(), 1)
  assert_eq(low.length(), 1)
  assert_eq(high + low, "😀")
}
