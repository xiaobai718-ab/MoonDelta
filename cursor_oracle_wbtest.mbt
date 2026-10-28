///|
test "cursor oracle 0" {
  let before = Delta::new().insert_plain("xxx")
  let after = Delta::new().insert_plain("xx")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 1" {
  let before = Delta::new().insert_plain("abc")
  let after = Delta::new().insert_plain("axbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"x\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 2" {
  let before = Delta::new().insert_plain("abc")
  let after = Delta::new().insert_plain("ac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 3" {
  let before = Delta::new().insert_plain("aaaa")
  let after = Delta::new().insert_plain("aaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 4" {
  let before = Delta::new().insert_plain("ab😀c")
  let after = Delta::new().insert_plain("ab🚀c")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"🚀\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 5" {
  let before = Delta::new().insert_plain("babcbc")
  let after = Delta::new().insert_plain("bacab")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"cab\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 6" {
  let before = Delta::new().insert_plain("bca")
  let after = Delta::new().insert_plain("cbcca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cbc\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 7" {
  let before = Delta::new().insert_plain("ccccb")
  let after = Delta::new().insert_plain("ac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"retain\":1},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 5), expected)
}

///|
test "cursor oracle 8" {
  let before = Delta::new().insert_plain("bba")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 9" {
  let before = Delta::new().insert_plain("acacb")
  let after = Delta::new().insert_plain("ac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 10" {
  let before = Delta::new().insert_plain("abc")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 11" {
  let before = Delta::new().insert_plain("cab")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 12" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 13" {
  let before = Delta::new().insert_plain("aacba")
  let after = Delta::new().insert_plain("aacca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 14" {
  let before = Delta::new().insert_plain("caa")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 15" {
  let before = Delta::new().insert_plain("cbc")
  let after = Delta::new().insert_plain("cabab")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"aba\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 16" {
  let before = Delta::new().insert_plain("bcccca")
  let after = Delta::new().insert_plain("ba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 17" {
  let before = Delta::new().insert_plain("babbba")
  let after = Delta::new().insert_plain("bac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"c\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 18" {
  let before = Delta::new().insert_plain("bcbaa")
  let after = Delta::new().insert_plain("bbccc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"bccc\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 19" {
  let before = Delta::new().insert_plain("bbabc")
  let after = Delta::new().insert_plain("cb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":4},{\"retain\":1},{\"insert\":\"b\"}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 20" {
  let before = Delta::new().insert_plain("bbcc")
  let after = Delta::new().insert_plain("ccb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2},{\"insert\":\"b\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 21" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("b")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 22" {
  let before = Delta::new().insert_plain("ba")
  let after = Delta::new().insert_plain("cbaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"insert\":\"a\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 23" {
  let before = Delta::new().insert_plain("cccca")
  let after = Delta::new().insert_plain("cc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 24" {
  let before = Delta::new().insert_plain("bab")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 25" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("cbaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cbaa\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 26" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("bac")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"ba\"}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 27" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("bca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bca\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 28" {
  let before = Delta::new().insert_plain("cbca")
  let after = Delta::new().insert_plain("cba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 29" {
  let before = Delta::new().insert_plain("bcbb")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":4}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 30" {
  let before = Delta::new().insert_plain("cacbcc")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 31" {
  let before = Delta::new().insert_plain("cacb")
  let after = Delta::new().insert_plain("cbaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"baa\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 32" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 33" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("bb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bb\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 34" {
  let before = Delta::new().insert_plain("cbb")
  let after = Delta::new().insert_plain("cba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 35" {
  let before = Delta::new().insert_plain("bacaac")
  let after = Delta::new().insert_plain("bca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":2},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 36" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 37" {
  let before = Delta::new().insert_plain("bc")
  let after = Delta::new().insert_plain("ba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 38" {
  let before = Delta::new().insert_plain("cbccc")
  let after = Delta::new().insert_plain("cbbbca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"bbca\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 39" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("cacb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cacb\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 40" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("ac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 41" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 42" {
  let before = Delta::new().insert_plain("babacb")
  let after = Delta::new().insert_plain("caacac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"caacac\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 43" {
  let before = Delta::new().insert_plain("babbac")
  let after = Delta::new().insert_plain("ab")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 44" {
  let before = Delta::new().insert_plain("aabbca")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 45" {
  let before = Delta::new().insert_plain("acbca")
  let after = Delta::new().insert_plain("b")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 46" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("caacc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"caacc\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 47" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("aaaac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aaaac\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 48" {
  let before = Delta::new().insert_plain("bacba")
  let after = Delta::new().insert_plain("aabaac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aabaac\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 49" {
  let before = Delta::new().insert_plain("bbcab")
  let after = Delta::new().insert_plain("babacc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":2},{\"insert\":\"acc\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 50" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("aa")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"aa\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 51" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("acacb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"cac\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 52" {
  let before = Delta::new().insert_plain("ba")
  let after = Delta::new().insert_plain("bcab")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"cab\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 53" {
  let before = Delta::new().insert_plain("aaac")
  let after = Delta::new().insert_plain("cbbba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cbbba\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 54" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("bc")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bc\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 55" {
  let before = Delta::new().insert_plain("acbb")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":4}]}")
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 56" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("cb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 57" {
  let before = Delta::new().insert_plain("bcaacb")
  let after = Delta::new().insert_plain("ccbac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccb\"},{\"delete\":3},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 58" {
  let before = Delta::new().insert_plain("cbccab")
  let after = Delta::new().insert_plain("b")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 59" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("c")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 60" {
  let before = Delta::new().insert_plain("acbc")
  let after = Delta::new().insert_plain("c")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 61" {
  let before = Delta::new().insert_plain("cbaaa")
  let after = Delta::new().insert_plain("ccbbbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"insert\":\"bbc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 62" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("baab")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"baab\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 63" {
  let before = Delta::new().insert_plain("aacaca")
  let after = Delta::new().insert_plain("caaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 64" {
  let before = Delta::new().insert_plain("cb")
  let after = Delta::new().insert_plain("abbacc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"abbac\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 65" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 66" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 67" {
  let before = Delta::new().insert_plain("acbabb")
  let after = Delta::new().insert_plain("bbbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":4},{\"retain\":2},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 68" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("ac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 69" {
  let before = Delta::new().insert_plain("abccb")
  let after = Delta::new().insert_plain("cbacb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cba\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 70" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 71" {
  let before = Delta::new().insert_plain("bba")
  let after = Delta::new().insert_plain("cbbcc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"insert\":\"cc\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 72" {
  let before = Delta::new().insert_plain("bca")
  let after = Delta::new().insert_plain("ababb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ababb\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 73" {
  let before = Delta::new().insert_plain("accbac")
  let after = Delta::new().insert_plain("ccac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 5), expected)
}

///|
test "cursor oracle 74" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("bbbba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbbb\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 75" {
  let before = Delta::new().insert_plain("bacacc")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 76" {
  let before = Delta::new().insert_plain("bccbbb")
  let after = Delta::new().insert_plain("bbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":4},{\"retain\":1},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 77" {
  let before = Delta::new().insert_plain("abacbb")
  let after = Delta::new().insert_plain("bcba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":3},{\"retain\":2},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 78" {
  let before = Delta::new().insert_plain("ccc")
  let after = Delta::new().insert_plain("cbca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"bca\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 79" {
  let before = Delta::new().insert_plain("aab")
  let after = Delta::new().insert_plain("accb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"cc\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 80" {
  let before = Delta::new().insert_plain("bc")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 81" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("baa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"baa\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 82" {
  let before = Delta::new().insert_plain("abbbb")
  let after = Delta::new().insert_plain("bb")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_at(after, 5), expected)
}

///|
test "cursor oracle 83" {
  let before = Delta::new().insert_plain("bbba")
  let after = Delta::new().insert_plain("accacc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"accacc\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 84" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("ca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ca\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 85" {
  let before = Delta::new().insert_plain("abbc")
  let after = Delta::new().insert_plain("cbbcac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":1},{\"retain\":3},{\"insert\":\"ac\"}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 86" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("bcbab")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"cbab\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 87" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("bbbcb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbbcb\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 88" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("cabcbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cabcb\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 89" {
  let before = Delta::new().insert_plain("acc")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 90" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("ba")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"ba\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 91" {
  let before = Delta::new().insert_plain("aaa")
  let after = Delta::new().insert_plain("ccabcb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ccabcb\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 92" {
  let before = Delta::new().insert_plain("acabb")
  let after = Delta::new().insert_plain("babacc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"babacc\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 93" {
  let before = Delta::new().insert_plain("cac")
  let after = Delta::new().insert_plain("b")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 94" {
  let before = Delta::new().insert_plain("abb")
  let after = Delta::new().insert_plain("cbcbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cbcbc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 95" {
  let before = Delta::new().insert_plain("abbb")
  let after = Delta::new().insert_plain("bca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bca\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 96" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("ba")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 97" {
  let before = Delta::new().insert_plain("bbacc")
  let after = Delta::new().insert_plain("ba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 5), expected)
}

///|
test "cursor oracle 98" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("b")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 99" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("bcaabb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcaabb\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 100" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("aaba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"aba\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 101" {
  let before = Delta::new().insert_plain("ac")
  let after = Delta::new().insert_plain("bcbb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcbb\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 102" {
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("aa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 103" {
  let before = Delta::new().insert_plain("bccaca")
  let after = Delta::new().insert_plain("ba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 6), expected)
}

///|
test "cursor oracle 104" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("aa")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"aa\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 105" {
  let before = Delta::new().insert_plain("cc")
  let after = Delta::new().insert_plain("abb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"abb\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 106" {
  let before = Delta::new().insert_plain("acba")
  let after = Delta::new().insert_plain("cb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 107" {
  let before = Delta::new().insert_plain("bacbbc")
  let after = Delta::new().insert_plain("c")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 108" {
  let before = Delta::new().insert_plain("abbaa")
  let after = Delta::new().insert_plain("caba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 109" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("cccbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cccbc\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 110" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("cabc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 111" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("caac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"aac\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 112" {
  let before = Delta::new().insert_plain("baac")
  let after = Delta::new().insert_plain("cc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 113" {
  let before = Delta::new().insert_plain("caa")
  let after = Delta::new().insert_plain("bac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bac\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 114" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("aa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 115" {
  let before = Delta::new().insert_plain("ccbb")
  let after = Delta::new().insert_plain("acbaac")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":1},{\"retain\":2},{\"insert\":\"aac\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 116" {
  let before = Delta::new().insert_plain("c")
  let after = Delta::new().insert_plain("accccc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"acccc\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 117" {
  let before = Delta::new().insert_plain("acc")
  let after = Delta::new().insert_plain("bbcbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bbcb\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 118" {
  let before = Delta::new().insert_plain("bcc")
  let after = Delta::new().insert_plain("c")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 119" {
  let before = Delta::new().insert_plain("aab")
  let after = Delta::new().insert_plain("bcabc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bc\"},{\"delete\":1},{\"retain\":2},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 120" {
  let before = Delta::new().insert_plain("cb")
  let after = Delta::new().insert_plain("cbaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"aa\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 121" {
  let before = Delta::new().insert_plain("cacb")
  let after = Delta::new().insert_plain("b")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 122" {
  let before = Delta::new().insert_plain("abccca")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":5}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 123" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("cc")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"cc\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 124" {
  let before = Delta::new().insert_plain("ccbaaa")
  let after = Delta::new().insert_plain("c")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":5}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 125" {
  let before = Delta::new().insert_plain("abc")
  let after = Delta::new().insert_plain("bacbb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bacbb\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 126" {
  let before = Delta::new().insert_plain("acb")
  let after = Delta::new().insert_plain("bcb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 127" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 128" {
  let before = Delta::new().insert_plain("cba")
  let after = Delta::new().insert_plain("cc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 129" {
  let before = Delta::new().insert_plain("bbc")
  let after = Delta::new().insert_plain("aa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 130" {
  let before = Delta::new().insert_plain("aacab")
  let after = Delta::new().insert_plain("acbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":1},{\"retain\":1},{\"insert\":\"c\"}]}",
  )
  assert_eq(before.diff_at(after, 5), expected)
}

///|
test "cursor oracle 131" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("ab")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"ab\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 132" {
  let before = Delta::new().insert_plain("bab")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 133" {
  let before = Delta::new().insert_plain("bcbccc")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 134" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("aa")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"aa\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 135" {
  let before = Delta::new().insert_plain("abbcbc")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 136" {
  let before = Delta::new().insert_plain("ba")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 137" {
  let before = Delta::new().insert_plain("ababa")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 138" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("caaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"caaa\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 139" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("bcbb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bcbb\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 140" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("aabca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aabca\"}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 141" {
  let before = Delta::new().insert_plain("cabba")
  let after = Delta::new().insert_plain("bbc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2},{\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 142" {
  let before = Delta::new().insert_plain("baca")
  let after = Delta::new().insert_plain("abbbba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"abbbb\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 4), expected)
}

///|
test "cursor oracle 143" {
  let before = Delta::new().insert_plain("bc")
  let after = Delta::new().insert_plain("aaaca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aaaca\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 144" {
  let before = Delta::new().insert_plain("ccab")
  let after = Delta::new().insert_plain("bacaab")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"baca\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 145" {
  let before = Delta::new().insert_plain("abcac")
  let after = Delta::new().insert_plain("aaaaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"aaaa\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 146" {
  let before = Delta::new().insert_plain("bcc")
  let after = Delta::new().insert_plain("a")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 2), expected)
}

///|
test "cursor oracle 147" {
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("acbcba")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"cbcba\"}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 148" {
  let before = Delta::new().insert_plain("caaca")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 149" {
  let before = Delta::new().insert_plain("acbbcb")
  let after = Delta::new().insert_plain("abcc")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":2},{\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 150" {
  let before = Delta::new().insert_plain("aaacac")
  let after = Delta::new().insert_plain("bbaaa")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bb\"},{\"retain\":3},{\"delete\":3}]}",
  )
  assert_eq(before.diff_at(after, 6), expected)
}

///|
test "cursor oracle 151" {
  let before = Delta::new().insert_plain("baaabb")
  let after = Delta::new().insert_plain("bcb")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"c\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff_at(after, 3), expected)
}

///|
test "cursor oracle 152" {
  let before = Delta::new().insert_plain("aa")
  let after = Delta::new().insert_plain("ca")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff_at(after, 1), expected)
}

///|
test "cursor oracle 153" {
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("ac")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"ac\"}]}")
  assert_eq(before.diff_at(after, 0), expected)
}

///|
test "cursor oracle 154" {
  let before = Delta::new().insert_plain("acabc")
  let after = Delta::new().insert_plain("")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff_at(after, 4), expected)
}
