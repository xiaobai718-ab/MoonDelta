///|
test "fast-diff oracle 0" {
  let old = "ab"
  let target = "ba"
  let expected_json = "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"a\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 1" {
  let old = "Badcat"
  let target = "Gooddog"
  let expected_json = "{\"ops\":[{\"insert\":\"Gooddog\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 2" {
  let old = "abc"
  let target = "axc"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"x\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 3" {
  let old = "aaaa"
  let target = "aaa"
  let expected_json = "{\"ops\":[{\"retain\":3},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 4" {
  let old = "aaa"
  let target = "aaaa"
  let expected_json = "{\"ops\":[{\"retain\":3},{\"insert\":\"a\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 5" {
  let old = "cat"
  let target = "cut"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"u\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 6" {
  let old = "The cat came."
  let target = "The black cat came."
  let expected_json = "{\"ops\":[{\"retain\":4},{\"insert\":\"black \"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 7" {
  let old = "The c came."
  let target = "The cat came."
  let expected_json = "{\"ops\":[{\"retain\":5},{\"insert\":\"at\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 8" {
  let old = "a b"
  let target = "ab "
  let expected_json = "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"insert\":\" \"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 9" {
  let old = "abcabc"
  let target = "abXabc"
  let expected_json = "{\"ops\":[{\"retain\":2},{\"insert\":\"X\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 10" {
  let old = "a😀b"
  let target = "x😀y"
  let expected_json = "{\"ops\":[{\"insert\":\"x\"},{\"delete\":1},{\"retain\":2},{\"insert\":\"y\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 11" {
  let old = "hello world"
  let target = "hello MoonBit"
  let expected_json = "{\"ops\":[{\"retain\":6},{\"insert\":\"MoonBit\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 12" {
  let old = "\n.c.\n"
  let target = " \n ca"
  let expected_json = "{\"ops\":[{\"insert\":\" \\n ca\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 13" {
  let old = ""
  let target = ".babb"
  let expected_json = "{\"ops\":[{\"insert\":\".babb\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 14" {
  let old = " cab"
  let target = "bcbc c"
  let expected_json = "{\"ops\":[{\"insert\":\"bcbc\"},{\"retain\":2},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 15" {
  let old = "\n\n.b"
  let target = ".caa"
  let expected_json = "{\"ops\":[{\"insert\":\".caa\"},{\"delete\":4}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 16" {
  let old = "b\n"
  let target = "a. ba"
  let expected_json = "{\"ops\":[{\"insert\":\"a. ba\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 17" {
  let old = ".\n aa"
  let target = "a\nac ."
  let expected_json = "{\"ops\":[{\"insert\":\"a\\nac .\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 18" {
  let old = "bba\n \n "
  let target = "a.a"
  let expected_json = "{\"ops\":[{\"insert\":\"a.a\"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 19" {
  let old = "cb.b"
  let target = "bcb "
  let expected_json = "{\"ops\":[{\"insert\":\"b\"},{\"retain\":2},{\"insert\":\" \"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 20" {
  let old = "a"
  let target = ". "
  let expected_json = "{\"ops\":[{\"insert\":\". \"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 21" {
  let old = "ac\n.."
  let target = "a.. b"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":2},{\"insert\":\" b\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 22" {
  let old = "b."
  let target = "b.. \n  "
  let expected_json = "{\"ops\":[{\"retain\":2},{\"insert\":\". \\n  \"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 23" {
  let old = "c .b b."
  let target = "c"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 24" {
  let old = "b b"
  let target = "\n a\n.."
  let expected_json = "{\"ops\":[{\"insert\":\"\\n a\\n..\"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 25" {
  let old = "aa\n"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 26" {
  let old = "cc\nbab"
  let target = " .a  ac"
  let expected_json = "{\"ops\":[{\"insert\":\" .a  ac\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 27" {
  let old = "\na ba"
  let target = "ba"
  let expected_json = "{\"ops\":[{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 28" {
  let old = "c\n"
  let target = "\n"
  let expected_json = "{\"ops\":[{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 29" {
  let old = "c"
  let target = ".cbc"
  let expected_json = "{\"ops\":[{\"insert\":\".cb\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 30" {
  let old = ""
  let target = "bacc"
  let expected_json = "{\"ops\":[{\"insert\":\"bacc\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 31" {
  let old = "cb\n"
  let target = "\n\nb\n.cb"
  let expected_json = "{\"ops\":[{\"insert\":\"\\n\\nb\\n.\"},{\"retain\":2},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 32" {
  let old = "aa\n \n"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 33" {
  let old = "c .c"
  let target = "bcc"
  let expected_json = "{\"ops\":[{\"insert\":\"b\"},{\"retain\":1},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 34" {
  let old = " "
  let target = ".bcc a"
  let expected_json = "{\"ops\":[{\"insert\":\".bcc a\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 35" {
  let old = ""
  let target = "c\n.\nc."
  let expected_json = "{\"ops\":[{\"insert\":\"c\\n.\\nc.\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 36" {
  let old = "ac"
  let target = "b b\n."
  let expected_json = "{\"ops\":[{\"insert\":\"b b\\n.\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 37" {
  let old = "ac \n.ab"
  let target = "a "
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\" \"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 38" {
  let old = ""
  let target = ""
  let expected_json = "{\"ops\":[]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 39" {
  let old = "\nb\n"
  let target = "a \na"
  let expected_json = "{\"ops\":[{\"insert\":\"a \\na\"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 40" {
  let old = ""
  let target = "cca"
  let expected_json = "{\"ops\":[{\"insert\":\"cca\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 41" {
  let old = "abb"
  let target = "\nacb c."
  let expected_json = "{\"ops\":[{\"insert\":\"\\nacb c.\"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 42" {
  let old = "cb  "
  let target = "cbc\n\n"
  let expected_json = "{\"ops\":[{\"retain\":2},{\"insert\":\"c\\n\\n\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 43" {
  let old = "... "
  let target = " "
  let expected_json = "{\"ops\":[{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 44" {
  let old = ".bb"
  let target = "bcc"
  let expected_json = "{\"ops\":[{\"insert\":\"bcc\"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 45" {
  let old = " "
  let target = "ca ac"
  let expected_json = "{\"ops\":[{\"insert\":\"ca ac\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 46" {
  let old = "a"
  let target = "\n.\na\n "
  let expected_json = "{\"ops\":[{\"insert\":\"\\n.\\na\\n \"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 47" {
  let old = "\n"
  let target = "b \n.a"
  let expected_json = "{\"ops\":[{\"insert\":\"b \\n.a\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 48" {
  let old = ""
  let target = "b."
  let expected_json = "{\"ops\":[{\"insert\":\"b.\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 49" {
  let old = ".aba"
  let target = "   "
  let expected_json = "{\"ops\":[{\"insert\":\"   \"},{\"delete\":4}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 50" {
  let old = "\n.\nb.c"
  let target = "caca\n "
  let expected_json = "{\"ops\":[{\"insert\":\"caca\\n \"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 51" {
  let old = " .a  b"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 52" {
  let old = "ac\nb\n\n "
  let target = "b.c\n .b"
  let expected_json = "{\"ops\":[{\"insert\":\"b.c\\n .b\"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 53" {
  let old = ".cb bb"
  let target = "c\n"
  let expected_json = "{\"ops\":[{\"insert\":\"c\\n\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 54" {
  let old = " "
  let target = "   b"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"  b\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 55" {
  let old = ""
  let target = "aca"
  let expected_json = "{\"ops\":[{\"insert\":\"aca\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 56" {
  let old = "\nc"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 57" {
  let old = "\nca c\n"
  let target = "b.bc"
  let expected_json = "{\"ops\":[{\"insert\":\"b.bc\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 58" {
  let old = "b acb."
  let target = "c\nc"
  let expected_json = "{\"ops\":[{\"insert\":\"c\\nc\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 59" {
  let old = "bcbb"
  let target = "a."
  let expected_json = "{\"ops\":[{\"insert\":\"a.\"},{\"delete\":4}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 60" {
  let old = " aa\nc"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 61" {
  let old = " b  a"
  let target = "\nac.."
  let expected_json = "{\"ops\":[{\"insert\":\"\\nac..\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 62" {
  let old = ""
  let target = "acbc"
  let expected_json = "{\"ops\":[{\"insert\":\"acbc\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 63" {
  let old = "c"
  let target = " abb "
  let expected_json = "{\"ops\":[{\"insert\":\" abb \"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 64" {
  let old = "b. c  ."
  let target = ".ab"
  let expected_json = "{\"ops\":[{\"insert\":\".ab\"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 65" {
  let old = "\n "
  let target = "aa"
  let expected_json = "{\"ops\":[{\"insert\":\"aa\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 66" {
  let old = "ca \n.cb"
  let target = "c"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 67" {
  let old = ""
  let target = " abcca"
  let expected_json = "{\"ops\":[{\"insert\":\" abcca\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 68" {
  let old = "c. \n\n"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 69" {
  let old = " a."
  let target = "cb"
  let expected_json = "{\"ops\":[{\"insert\":\"cb\"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 70" {
  let old = "c.cc"
  let target = "b\na"
  let expected_json = "{\"ops\":[{\"insert\":\"b\\na\"},{\"delete\":4}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 71" {
  let old = ".\n\n"
  let target = " bc "
  let expected_json = "{\"ops\":[{\"insert\":\" bc \"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 72" {
  let old = "cbcc"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":4}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 73" {
  let old = "c"
  let target = "cb.."
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"b..\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 74" {
  let old = "ab\n"
  let target = "bbb\nb"
  let expected_json = "{\"ops\":[{\"insert\":\"bb\"},{\"delete\":1},{\"retain\":2},{\"insert\":\"b\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 75" {
  let old = " \n . a"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 76" {
  let old = " "
  let target = "bca. a"
  let expected_json = "{\"ops\":[{\"insert\":\"bca. a\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 77" {
  let old = "\n\n  \nb\n"
  let target = "a...\n"
  let expected_json = "{\"ops\":[{\"insert\":\"a...\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 78" {
  let old = "\n \nb c."
  let target = "\na b.b"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"a b.b\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 79" {
  let old = "b.\n"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 80" {
  let old = "ca.bc."
  let target = ".  "
  let expected_json = "{\"ops\":[{\"insert\":\".  \"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 81" {
  let old = "\na "
  let target = " ac"
  let expected_json = "{\"ops\":[{\"insert\":\" ac\"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 82" {
  let old = " "
  let target = "abb"
  let expected_json = "{\"ops\":[{\"insert\":\"abb\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 83" {
  let old = "a"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 84" {
  let old = " \n"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 85" {
  let old = "bcc   "
  let target = "c. b "
  let expected_json = "{\"ops\":[{\"insert\":\"c. b\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 86" {
  let old = "  cc."
  let target = "\n"
  let expected_json = "{\"ops\":[{\"insert\":\"\\n\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 87" {
  let old = "\nb"
  let target = "b\n "
  let expected_json = "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"\\n \"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 88" {
  let old = "a\n\n\n\nb"
  let target = ".c\nba.b"
  let expected_json = "{\"ops\":[{\"insert\":\".c\\nba.\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 89" {
  let old = "\n"
  let target = ".b b "
  let expected_json = "{\"ops\":[{\"insert\":\".b b \"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 90" {
  let old = ""
  let target = ".\n"
  let expected_json = "{\"ops\":[{\"insert\":\".\\n\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 91" {
  let old = "\na \n"
  let target = "c"
  let expected_json = "{\"ops\":[{\"insert\":\"c\"},{\"delete\":4}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 92" {
  let old = "b   "
  let target = "baa.\na"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"aa.\\na\"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 93" {
  let old = ""
  let target = "\n."
  let expected_json = "{\"ops\":[{\"insert\":\"\\n.\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 94" {
  let old = "c.c.b"
  let target = "  \n"
  let expected_json = "{\"ops\":[{\"insert\":\"  \\n\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 95" {
  let old = "bb \n. b"
  let target = "\n .\ncc "
  let expected_json = "{\"ops\":[{\"insert\":\"\\n .\\ncc \"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 96" {
  let old = "a \nabc"
  let target = "b.a a"
  let expected_json = "{\"ops\":[{\"insert\":\"b.a a\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 97" {
  let old = "b. \n"
  let target = "bbb"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"bb\"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 98" {
  let old = "c  "
  let target = "c\nc"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"\\nc\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 99" {
  let old = " .\n\nb"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 100" {
  let old = "\na b ca"
  let target = " "
  let expected_json = "{\"ops\":[{\"insert\":\" \"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 101" {
  let old = "  a."
  let target = "\nb"
  let expected_json = "{\"ops\":[{\"insert\":\"\\nb\"},{\"delete\":4}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 102" {
  let old = " \n."
  let target = "a . "
  let expected_json = "{\"ops\":[{\"insert\":\"a . \"},{\"delete\":3}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 103" {
  let old = "\nb\n\nc"
  let target = "c\n."
  let expected_json = "{\"ops\":[{\"insert\":\"c\\n.\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 104" {
  let old = " \n"
  let target = ".."
  let expected_json = "{\"ops\":[{\"insert\":\"..\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 105" {
  let old = ".a"
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 106" {
  let old = "b\n b."
  let target = " .\nc\ncc"
  let expected_json = "{\"ops\":[{\"insert\":\" .\\nc\\ncc\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 107" {
  let old = " \n.ab"
  let target = "b."
  let expected_json = "{\"ops\":[{\"delete\":4},{\"retain\":1},{\"insert\":\".\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 108" {
  let old = "c.ac a\n"
  let target = "ba.cc"
  let expected_json = "{\"ops\":[{\"insert\":\"ba.cc\"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 109" {
  let old = "ac"
  let target = " bbc\n"
  let expected_json = "{\"ops\":[{\"insert\":\" bbc\\n\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 110" {
  let old = "c"
  let target = "b b. c."
  let expected_json = "{\"ops\":[{\"insert\":\"b b. c.\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 111" {
  let old = "."
  let target = ""
  let expected_json = "{\"ops\":[{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 112" {
  let old = " bca\n c"
  let target = "a"
  let expected_json = "{\"ops\":[{\"insert\":\"a\"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 113" {
  let old = "bccc\n\n"
  let target = "aa.bcb"
  let expected_json = "{\"ops\":[{\"insert\":\"aa.bcb\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 114" {
  let old = " \nb \nc"
  let target = "."
  let expected_json = "{\"ops\":[{\"insert\":\".\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 115" {
  let old = "..bb"
  let target = ". cac\nb"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\" cac\\n\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 116" {
  let old = "a\n"
  let target = "ca\nb"
  let expected_json = "{\"ops\":[{\"insert\":\"c\"},{\"retain\":2},{\"insert\":\"b\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 117" {
  let old = "a"
  let target = "b"
  let expected_json = "{\"ops\":[{\"insert\":\"b\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 118" {
  let old = "b."
  let target = "ac\nc"
  let expected_json = "{\"ops\":[{\"insert\":\"ac\\nc\"},{\"delete\":2}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 119" {
  let old = "\nc\nb ca"
  let target = " a c"
  let expected_json = "{\"ops\":[{\"insert\":\" a\"},{\"delete\":4},{\"retain\":2},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 120" {
  let old = "c\nb\nc"
  let target = "cc\nbb\na"
  let expected_json = "{\"ops\":[{\"insert\":\"c\"},{\"retain\":3},{\"insert\":\"b\"},{\"retain\":1},{\"insert\":\"a\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 121" {
  let old = "ab\n\nb\n"
  let target = "a "
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\" \"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 122" {
  let old = "c\nbabb\n"
  let target = " b."
  let expected_json = "{\"ops\":[{\"insert\":\" b.\"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 123" {
  let old = "c .\nac"
  let target = "b\n"
  let expected_json = "{\"ops\":[{\"insert\":\"b\\n\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 124" {
  let old = "."
  let target = " . aa"
  let expected_json = "{\"ops\":[{\"insert\":\" . aa\"},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 125" {
  let old = "...a. "
  let target = ".b\n bc"
  let expected_json = "{\"ops\":[{\"retain\":1},{\"insert\":\"b\\n bc\"},{\"delete\":5}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 126" {
  let old = "a.\n.\n."
  let target = ". c\ncc"
  let expected_json = "{\"ops\":[{\"insert\":\". c\\ncc\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 127" {
  let old = "b\n.a.cc"
  let target = "cc. \nc"
  let expected_json = "{\"ops\":[{\"insert\":\"cc. \\n\"},{\"delete\":6}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 128" {
  let old = ""
  let target = "b\na.a"
  let expected_json = "{\"ops\":[{\"insert\":\"b\\na.a\"}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 129" {
  let old = "ab"
  let target = "\nba"
  let expected_json = "{\"ops\":[{\"insert\":\"\\nb\"},{\"retain\":1},{\"delete\":1}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}

///|
test "fast-diff oracle 130" {
  let old = "\n. \n\nc."
  let target = " .bc..c"
  let expected_json = "{\"ops\":[{\"insert\":\" .bc..c\"},{\"delete\":7}]}"
  let actual = Delta::new()
    .insert_plain(old)
    .diff(Delta::new().insert_plain(target))
  assert_eq(actual, Delta::parse_json_compatible(expected_json))
}
