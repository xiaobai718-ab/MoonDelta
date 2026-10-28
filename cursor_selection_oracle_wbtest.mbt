///|
test "cursor selection oracle 0" {
  let before = Delta::new().insert_plain("xxx")
  let after = Delta::new().insert_plain("xx")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"x\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 1" {
  let before = Delta::new().insert_plain("abc")
  let after = Delta::new().insert_plain("axc")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"x\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 2" {
  let before = Delta::new().insert_plain("bac")
  let after = Delta::new().insert_plain("c")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 3" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("ccca")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 4" {
  let before = Delta::new().insert_plain("ca")
  let after = Delta::new().insert_plain("aaacb")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"aacb\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 5" {
  let before = Delta::new().insert_plain("aaa")
  let after = Delta::new().insert_plain("cc")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 6" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("bcaab")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcaab\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 7" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 8" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("c")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 9" {
  let before = Delta::new().insert_plain("aca")
  let after = Delta::new().insert_plain("bc")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 10" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("ccbca")
  let cursor = CursorInfo::new(CursorRange::new(0, 1), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccbca\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 11" {
  let before = Delta::new().insert_plain("bbccb")
  let after = Delta::new().insert_plain("cbbcba")
  let cursor = CursorInfo::new(CursorRange::new(3, 2), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":3},{\"delete\":1},{\"retain\":1},{\"insert\":\"a\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 12" {
  let before = Delta::new().insert_plain("aac")
  let after = Delta::new().insert_plain("abac")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"b\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 13" {
  let before = Delta::new().insert_plain("aabba")
  let after = Delta::new().insert_plain("abcab")
  let cursor = CursorInfo::new(CursorRange::new(5, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"bc\"},{\"retain\":2},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 14" {
  let before = Delta::new().insert_plain("bbaa")
  let after = Delta::new().insert_plain("abbbb")
  let cursor = CursorInfo::new(CursorRange::new(2, 1), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"abb\"},{\"retain\":2},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 15" {
  let before = Delta::new().insert_plain("acc")
  let after = Delta::new().insert_plain("aaaaab")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"aaaab\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 16" {
  let before = Delta::new().insert_plain("aa")
  let after = Delta::new().insert_plain("caa")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"c\"}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 17" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("aacb")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aacb\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 18" {
  let before = Delta::new().insert_plain("acc")
  let after = Delta::new().insert_plain("b")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 19" {
  let before = Delta::new().insert_plain("cabbc")
  let after = Delta::new().insert_plain("caabb")
  let cursor = CursorInfo::new(CursorRange::new(5, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"a\"},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 20" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("ac")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"ac\"}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 21" {
  let before = Delta::new().insert_plain("bcaaba")
  let after = Delta::new().insert_plain("abbbb")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"abbbb\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 22" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("bcaba")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcaba\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 23" {
  let before = Delta::new().insert_plain("baab")
  let after = Delta::new().insert_plain("aaaaac")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"insert\":\"aaac\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 24" {
  let before = Delta::new().insert_plain("aaacbb")
  let after = Delta::new().insert_plain("b")
  let cursor = CursorInfo::new(CursorRange::new(2, 3), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 25" {
  let before = Delta::new().insert_plain("abbcaa")
  let after = Delta::new().insert_plain("bbab")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":2},{\"retain\":1},{\"insert\":\"b\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 26" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("acaa")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"aa\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 27" {
  let before = Delta::new().insert_plain("aaa")
  let after = Delta::new().insert_plain("bbbca")
  let cursor = CursorInfo::new(CursorRange::new(1, 2), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbbc\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 28" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("bca")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bca\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 29" {
  let before = Delta::new().insert_plain("aac")
  let after = Delta::new().insert_plain("bab")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bab\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 30" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("bacbb")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"retain\":2},{\"insert\":\"bb\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 31" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("baba")
  let cursor = CursorInfo::new(CursorRange::new(0, 1), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"baba\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 32" {
  let before = Delta::new().insert_plain("cbcc")
  let after = Delta::new().insert_plain("a")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 33" {
  let before = Delta::new().insert_plain("caa")
  let after = Delta::new().insert_plain("ca")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 34" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 35" {
  let before = Delta::new().insert_plain("bcaba")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(0, 3), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 36" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("cb")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"cb\"}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 37" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("acba")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"cba\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 38" {
  let before = Delta::new().insert_plain("aba")
  let after = Delta::new().insert_plain("ac")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 39" {
  let before = Delta::new().insert_plain("ababca")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(3, 1), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 40" {
  let before = Delta::new().insert_plain("bcab")
  let after = Delta::new().insert_plain("baabbc")
  let cursor = CursorInfo::new(CursorRange::new(1, 3), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"aabbc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 41" {
  let before = Delta::new().insert_plain("bb")
  let after = Delta::new().insert_plain("bbc")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbc\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 42" {
  let before = Delta::new().insert_plain("acb")
  let after = Delta::new().insert_plain("aab")
  let cursor = CursorInfo::new(CursorRange::new(2, 1), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 43" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("b")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 44" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("bcaa")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcaa\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 45" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("a")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 46" {
  let before = Delta::new().insert_plain("bba")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 47" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("ccbb")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccbb\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 48" {
  let before = Delta::new().insert_plain("abc")
  let after = Delta::new().insert_plain("cba")
  let cursor = CursorInfo::new(CursorRange::new(0, 3), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cba\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 49" {
  let before = Delta::new().insert_plain("bba")
  let after = Delta::new().insert_plain("ccccc")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccccc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 50" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("c")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"c\"}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 51" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("baa")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"aa\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 52" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("cbaaac")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cbaaac\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 53" {
  let before = Delta::new().insert_plain("abccbb")
  let after = Delta::new().insert_plain("caa")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"caa\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 54" {
  let before = Delta::new().insert_plain("ccccb")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(5, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 55" {
  let before = Delta::new().insert_plain("bbcc")
  let after = Delta::new().insert_plain("caaac")
  let cursor = CursorInfo::new(CursorRange::new(4, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"caaa\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 56" {
  let before = Delta::new().insert_plain("bccbba")
  let after = Delta::new().insert_plain("ca")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 57" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("cc")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"cc\"}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 58" {
  let before = Delta::new().insert_plain("bbacaa")
  let after = Delta::new().insert_plain("cbcbc")
  let cursor = CursorInfo::new(CursorRange::new(2, 2), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cbcbc\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 59" {
  let before = Delta::new().insert_plain("bcbc")
  let after = Delta::new().insert_plain("a")
  let cursor = CursorInfo::new(CursorRange::new(0, 1), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 60" {
  let before = Delta::new().insert_plain("cc")
  let after = Delta::new().insert_plain("aca")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aca\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 61" {
  let before = Delta::new().insert_plain("bacacc")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(0, 5), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 62" {
  let before = Delta::new().insert_plain("bbcc")
  let after = Delta::new().insert_plain("bbaca")
  let cursor = CursorInfo::new(CursorRange::new(0, 4), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbaca\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 63" {
  let before = Delta::new().insert_plain("cbaa")
  let after = Delta::new().insert_plain("aabcc")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2},{\"insert\":\"bcc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 64" {
  let before = Delta::new().insert_plain("bca")
  let after = Delta::new().insert_plain("b")
  let cursor = CursorInfo::new(CursorRange::new(0, 1), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 65" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("bacac")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"acac\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 66" {
  let before = Delta::new().insert_plain("bccbca")
  let after = Delta::new().insert_plain("cabcb")
  let cursor = CursorInfo::new(CursorRange::new(4, 1), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cabcb\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 67" {
  let before = Delta::new().insert_plain("aaccab")
  let after = Delta::new().insert_plain("caaaba")
  let cursor = CursorInfo::new(CursorRange::new(6, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"delete\":2},{\"retain\":2},{\"insert\":\"a\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 68" {
  let before = Delta::new().insert_plain("acb")
  let after = Delta::new().insert_plain("acacaa")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"acaa\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 69" {
  let before = Delta::new().insert_plain("ccccc")
  let after = Delta::new().insert_plain("aaab")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aaab\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 70" {
  let before = Delta::new().insert_plain("aacbc")
  let after = Delta::new().insert_plain("cba")
  let cursor = CursorInfo::new(CursorRange::new(5, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 71" {
  let before = Delta::new().insert_plain("bbcbcb")
  let after = Delta::new().insert_plain("a")
  let cursor = CursorInfo::new(CursorRange::new(2, 3), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 72" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("bcbabc")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcbabc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 73" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 74" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("caabca")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"caabc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 75" {
  let before = Delta::new().insert_plain("ccacc")
  let after = Delta::new().insert_plain("caa")
  let cursor = CursorInfo::new(CursorRange::new(2, 2), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"insert\":\"a\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 76" {
  let before = Delta::new().insert_plain("bacb")
  let after = Delta::new().insert_plain("cbb")
  let cursor = CursorInfo::new(CursorRange::new(1, 3), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1},{\"insert\":\"b\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 77" {
  let before = Delta::new().insert_plain("aba")
  let after = Delta::new().insert_plain("bca")
  let cursor = CursorInfo::new(CursorRange::new(1, 2), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 78" {
  let before = Delta::new().insert_plain("aa")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 79" {
  let before = Delta::new().insert_plain("acaac")
  let after = Delta::new().insert_plain("ccaaac")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"ca\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 80" {
  let before = Delta::new().insert_plain("abbaca")
  let after = Delta::new().insert_plain("acb")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"},{\"retain\":1},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 81" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("ccc")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 82" {
  let before = Delta::new().insert_plain("bacb")
  let after = Delta::new().insert_plain("baaa")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"aa\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 83" {
  let before = Delta::new().insert_plain("ca")
  let after = Delta::new().insert_plain("bbcccb")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbcccb\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 84" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 85" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("cbccca")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"bccca\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 86" {
  let before = Delta::new().insert_plain("abbc")
  let after = Delta::new().insert_plain("caa")
  let cursor = CursorInfo::new(CursorRange::new(2, 1), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"caa\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 87" {
  let before = Delta::new().insert_plain("aacab")
  let after = Delta::new().insert_plain("caaac")
  let cursor = CursorInfo::new(CursorRange::new(2, 2), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ca\"},{\"retain\":3},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 88" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("acbbb")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"acbbb\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 89" {
  let before = Delta::new().insert_plain("acb")
  let after = Delta::new().insert_plain("abcb")
  let cursor = CursorInfo::new(CursorRange::new(1, 2), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"bcb\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 90" {
  let before = Delta::new().insert_plain("cbca")
  let after = Delta::new().insert_plain("bcccba")
  let cursor = CursorInfo::new(CursorRange::new(3, 1), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"insert\":\"ccb\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 91" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("cccba")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cccb\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 92" {
  let before = Delta::new().insert_plain("aaaa")
  let after = Delta::new().insert_plain("c")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 93" {
  let before = Delta::new().insert_plain("aaba")
  let after = Delta::new().insert_plain("caccb")
  let cursor = CursorInfo::new(CursorRange::new(0, 3), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"caccb\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 94" {
  let before = Delta::new().insert_plain("abb")
  let after = Delta::new().insert_plain("bbaabc")
  let cursor = CursorInfo::new(CursorRange::new(1, 2), CursorRange::new(6, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bba\"},{\"retain\":2},{\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 95" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("bcbaab")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcba\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 96" {
  let before = Delta::new().insert_plain("bb")
  let after = Delta::new().insert_plain("bbcaa")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"caa\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 97" {
  let before = Delta::new().insert_plain("ca")
  let after = Delta::new().insert_plain("bbb")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbb\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 98" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("ccccc")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"cccc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 99" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("b")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 100" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("baa")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"baa\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 101" {
  let before = Delta::new().insert_plain("ca")
  let after = Delta::new().insert_plain("cc")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 102" {
  let before = Delta::new().insert_plain("abcbc")
  let after = Delta::new().insert_plain("bcab")
  let cursor = CursorInfo::new(CursorRange::new(3, 2), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"insert\":\"a\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 103" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("bcc")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"cc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 104" {
  let before = Delta::new().insert_plain("cb")
  let after = Delta::new().insert_plain("babbca")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"abbca\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 105" {
  let before = Delta::new().insert_plain("bacbbb")
  let after = Delta::new().insert_plain("acccc")
  let cursor = CursorInfo::new(CursorRange::new(1, 5), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"insert\":\"ccc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 106" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("acbacc")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"acbacc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 107" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("cca")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"ca\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 108" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("bc")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 109" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("cacca")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"insert\":\"ca\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 110" {
  let before = Delta::new().insert_plain("ccbaa")
  let after = Delta::new().insert_plain("ac")
  let cursor = CursorInfo::new(CursorRange::new(3, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":4},{\"retain\":1},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 111" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("ccaabc")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(6, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccaabc\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 112" {
  let before = Delta::new().insert_plain("bba")
  let after = Delta::new().insert_plain("cbb")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 113" {
  let before = Delta::new().insert_plain("aacbbb")
  let after = Delta::new().insert_plain("bcccbc")
  let cursor = CursorInfo::new(CursorRange::new(5, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcccbc\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 114" {
  let before = Delta::new().insert_plain("cabc")
  let after = Delta::new().insert_plain("abbaca")
  let cursor = CursorInfo::new(CursorRange::new(3, 1), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"insert\":\"baca\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 115" {
  let before = Delta::new().insert_plain("bba")
  let after = Delta::new().insert_plain("aa")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 116" {
  let before = Delta::new().insert_plain("bc")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 117" {
  let before = Delta::new().insert_plain("abbba")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(1, 2), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 118" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("aaac")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aaac\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 119" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("b")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 120" {
  let before = Delta::new().insert_plain("aaa")
  let after = Delta::new().insert_plain("c")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 121" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("b")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 122" {
  let before = Delta::new().insert_plain("cbb")
  let after = Delta::new().insert_plain("aabc")
  let cursor = CursorInfo::new(CursorRange::new(2, 1), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aabc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 123" {
  let before = Delta::new().insert_plain("bcbcc")
  let after = Delta::new().insert_plain("ccccba")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccccba\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 124" {
  let before = Delta::new().insert_plain("ccbbbc")
  let after = Delta::new().insert_plain("bcbcca")
  let cursor = CursorInfo::new(CursorRange::new(5, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcbcca\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 125" {
  let before = Delta::new().insert_plain("bbbac")
  let after = Delta::new().insert_plain("ccb")
  let cursor = CursorInfo::new(CursorRange::new(4, 1), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccb\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 126" {
  let before = Delta::new().insert_plain("acccca")
  let after = Delta::new().insert_plain("aaaaaa")
  let cursor = CursorInfo::new(CursorRange::new(3, 3), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"aaaa\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 127" {
  let before = Delta::new().insert_plain("cacac")
  let after = Delta::new().insert_plain("bbcbcc")
  let cursor = CursorInfo::new(CursorRange::new(4, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbcbc\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 128" {
  let before = Delta::new().insert_plain("aaaaca")
  let after = Delta::new().insert_plain("ccbcba")
  let cursor = CursorInfo::new(CursorRange::new(3, 1), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccbcb\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 129" {
  let before = Delta::new().insert_plain("bca")
  let after = Delta::new().insert_plain("c")
  let cursor = CursorInfo::new(CursorRange::new(2, 1), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 130" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("bccc")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bccc\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 131" {
  let before = Delta::new().insert_plain("abcc")
  let after = Delta::new().insert_plain("aabcac")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"retain\":3},{\"insert\":\"a\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 132" {
  let before = Delta::new().insert_plain("bc")
  let after = Delta::new().insert_plain("babba")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"abba\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 133" {
  let before = Delta::new().insert_plain("caaa")
  let after = Delta::new().insert_plain("a")
  let cursor = CursorInfo::new(CursorRange::new(2, 2), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 134" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("aacccc")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aacccc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 135" {
  let before = Delta::new().insert_plain("bbbac")
  let after = Delta::new().insert_plain("bbccb")
  let cursor = CursorInfo::new(CursorRange::new(0, 3), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"ccb\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 136" {
  let before = Delta::new().insert_plain("caaaac")
  let after = Delta::new().insert_plain("abc")
  let cursor = CursorInfo::new(CursorRange::new(5, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":4},{\"retain\":1},{\"insert\":\"b\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 137" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 138" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("baba")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"baba\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 139" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("babaac")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"babaac\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 140" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("aacaa")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(5, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aacaa\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 141" {
  let before = Delta::new().insert_plain("bbcbb")
  let after = Delta::new().insert_plain("acb")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":2},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 142" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("aac")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"ac\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 143" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("acba")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"ba\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 144" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("ccc")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccc\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 145" {
  let before = Delta::new().insert_plain("cba")
  let after = Delta::new().insert_plain("bcccac")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcccac\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 146" {
  let before = Delta::new().insert_plain("babac")
  let after = Delta::new().insert_plain("cccb")
  let cursor = CursorInfo::new(CursorRange::new(4, 1), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cccb\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 147" {
  let before = Delta::new().insert_plain("bbbccb")
  let after = Delta::new().insert_plain("cbcb")
  let cursor = CursorInfo::new(CursorRange::new(4, 0), CursorRange::new(4, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":1},{\"insert\":\"b\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 148" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 149" {
  let before = Delta::new().insert_plain("bcc")
  let after = Delta::new().insert_plain("baab")
  let cursor = CursorInfo::new(CursorRange::new(0, 3), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"baab\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 150" {
  let before = Delta::new().insert_plain("bbaaa")
  let after = Delta::new().insert_plain("bca")
  let cursor = CursorInfo::new(CursorRange::new(3, 1), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 151" {
  let before = Delta::new().insert_plain("cb")
  let after = Delta::new().insert_plain("aaa")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aaa\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 152" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 153" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("babaaa")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"babaaa\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 154" {
  let before = Delta::new().insert_plain("cba")
  let after = Delta::new().insert_plain("cccbba")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cccbb\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 155" {
  let before = Delta::new().insert_plain("bbcabb")
  let after = Delta::new().insert_plain("cacaac")
  let cursor = CursorInfo::new(CursorRange::new(2, 1), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cacaac\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 156" {
  let before = Delta::new().insert_plain("cc")
  let after = Delta::new().insert_plain("ababc")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ababc\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 157" {
  let before = Delta::new().insert_plain("aacc")
  let after = Delta::new().insert_plain("aca")
  let cursor = CursorInfo::new(CursorRange::new(4, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 158" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("c")
  let cursor = CursorInfo::new(CursorRange::new(0, 0), CursorRange::new(0, 0))
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 159" {
  let before = Delta::new().insert_plain("cabbb")
  let after = Delta::new().insert_plain("acc")
  let cursor = CursorInfo::new(CursorRange::new(4, 0), CursorRange::new(3, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"acc\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 160" {
  let before = Delta::new().insert_plain("aba")
  let after = Delta::new().insert_plain("acba")
  let cursor = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(2, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}

///|
test "cursor selection oracle 161" {
  let before = Delta::new().insert_plain("cbac")
  let after = Delta::new().insert_plain("aacbc")
  let cursor = CursorInfo::new(CursorRange::new(1, 2), CursorRange::new(1, 0))
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\"},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_with_cursor_info(after, cursor), expected)
}
