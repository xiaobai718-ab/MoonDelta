///|
test "upstream randomized Delta diff 0" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"b\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"ca \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"c\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-0\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"ca \"},{\"attributes\":{\"bold\":true},\"insert\":\"c\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 1" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cb a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀 c\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b猫 \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"b猫 \"},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 2" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"\\nc\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀cc\\nb\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀cc\\nb\"},{\"insert\":\"b\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 3" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 4" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a a猫\\na\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-2\"}},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 5" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\nb😀\"},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nca\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"\\nca\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 6" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\",\"attributes\":{\"bold\":true}},{\"insert\":\" b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\" b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫cc\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" b\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫cc\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 7" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c猫😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"c猫😀\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 8" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫😀b\"},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫😀b\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":{\"image\":\"img-2\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 9" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ab😀😀bb\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":9}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 10" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫猫cc\"},{\"insert\":\"猫 \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫ac猫b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\"},{\"delete\":6},{\"retain\":1},{\"retain\":1,\"attributes\":{\"font\":null}},{\"insert\":\"b\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 11" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫c\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀 猫\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"bc猫a\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\naa猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"bc猫a\"},{\"insert\":\"\\naa猫\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 12" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\n猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"  b\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀猫 b\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a😀猫\"},{\"delete\":4},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 13" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 猫ab\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":\"\\n猫\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n猫\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-2\"}},{\"delete\":6}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 14" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 15" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\\nccba \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nc\\n猫\"},{\"insert\":\"bb\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\n 😀\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"font\":null}},{\"insert\":\"\\n猫\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"bb\"},{\"attributes\":{\"bold\":true},\"insert\":\"\\n 😀\\n\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 16" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"cba\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 17" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 18" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀aa\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀aa\"},{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 19" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 20" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" b\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" cbc\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":null}},{\"insert\":\"cbc\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":null}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 21" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫b\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"猫猫b\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 22" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀cb\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀c😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\"},{\"insert\":\"abc\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫a\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀c😀\"},{\"insert\":\"猫\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"abc\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫a\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 23" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀\",\"attributes\":{\"bold\":true}},{\"insert\":\" a  cc\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":11}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 24" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"bbc😀\"},{\"insert\":\"ca猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"bbc😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"ca猫\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀😀\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 25" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\"},{\"insert\":\"  a c😀c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"猫ab\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀 😀😀\"},{\"insert\":\"b😀猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"😀猫\\nb\",\"attributes\":{\"bold\":true}},{\"insert\":\" \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀 😀😀\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"b😀猫\"},{\"attributes\":{\"bold\":true},\"insert\":\"😀猫\\nb\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" \"},{\"delete\":13}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 26" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 27" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\\n猫\"},{\"insert\":\"猫 \\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"c\"},{\"insert\":\"c\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫猫a\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"猫\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫猫a\"},{\"insert\":\"b\"},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 28" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀猫猫c\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" aac\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"bcba\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\" aac\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"c\"},{\"insert\":\"bcba\"},{\"delete\":10}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 29" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 30" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ac😀猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" \"},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"ac😀猫\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":{\"image\":\"img-2\"}},{\"insert\":\" \"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-2\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 31" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \\n  \",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\" \\n  \"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 32" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫aa 😀cb\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫 😀😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫aa 😀cb\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"insert\":\"猫 😀😀\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 33" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-0\"}},{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cc\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"cc\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 34" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c猫猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"cacab\\na猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c猫猫\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"cacab\\na猫\"},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 35" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ba\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\\n\"}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\"\\n\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 36" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"  \"},{\"insert\":\"😀c猫😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"b猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"  \"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀c猫😀\"},{\"insert\":\"b猫\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 37" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"  \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"a bc\"},{\"insert\":\" c😀😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" a \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":null,\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"retain\":1,\"attributes\":{\"font\":null,\"color\":\"red\"}},{\"delete\":11}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 38" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"}},{\"insert\":\" c😀\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"insert\":\"猫\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\" b\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\\n\"},{\"insert\":\" b\"},{\"delete\":5},{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":null}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 39" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"c\"}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"c\"}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 40" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nc\"},{\"insert\":\"\\nbcc\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"b\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫\"},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 41" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cb😀\"},{\"insert\":\"猫b\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"a\\nbaa\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"😀a \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-0\"}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀a \"},{\"insert\":{\"image\":\"img-0\"}},{\"delete\":12}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 42" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"bb\"},{\"insert\":{\"image\":\"img-0\"}},{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 43" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-0\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\n\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 44" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c \",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a \\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cb\\n\\nc\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"blue\",\"italic\":true}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"b\\n\\nc\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-0\"}},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 45" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀aa\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"acc\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"}},{\"insert\":\"😀a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"acc\\n\"},{\"insert\":{\"image\":\"img-0\"}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"bold\":null,\"color\":\"red\"}},{\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 46" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\\n\\n \"},{\"insert\":\"b猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\" \\na😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 猫猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" 猫猫\"},{\"insert\":{\"image\":\"img-0\"}},{\"delete\":11}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 47" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cbc\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"cbc\"},{\"insert\":\"b\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 48" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a  a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"a  a\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 49" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nab😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nab😀\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 50" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"c😀\\n\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\naa\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀 \"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"attributes\":{\"bold\":true},\"insert\":\"\\naa\"},{\"delete\":2},{\"retain\":2},{\"insert\":\" \"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 51" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c😀\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-0\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 52" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫 \\n猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\n\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 53" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 54" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 55" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n 😀\"},{\"insert\":\"b😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n 😀\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"b😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-2\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 56" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀c\"},{\"insert\":\"b猫 😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"😀 c\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀c\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"b猫 😀\"},{\"insert\":\"😀 c\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 57" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"\\nc 😀\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a\\n\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 58" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":\"😀a\\nc\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"bold\":true},\"insert\":\"😀a\\nc\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 59" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 60" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"  猫a😀  猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\n😀猫c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c😀b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"c😀b\"},{\"delete\":15}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 61" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nc\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\nc\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 62" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"insert\":\"😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"insert\":\"\\nb猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\nb猫\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 63" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 64" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫猫\"},{\"insert\":\"a😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 猫\"},{\"insert\":\"b猫猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":1},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"b猫猫\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 65" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"insert\":\"b猫b猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a \"},{\"insert\":\"c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cc\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" ac猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"cc\"},{\"attributes\":{\"bold\":true},\"insert\":\" ac猫\"},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 66" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀😀\"},{\"insert\":\"\\nab\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\nc\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b\"},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" \"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"b\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-2\"}},{\"delete\":12}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 67" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}},{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫 \"},{\"delete\":2}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 68" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b猫  \"},{\"insert\":\"aac\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"ba\\n\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀b\"},{\"insert\":\" \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\" b猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀b\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" \"},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" b猫\"},{\"delete\":12}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 69" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"bc\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀😀\\n\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 70" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"\\n猫😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"猫\\n\\n\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"😀a\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-0\"}},{\"insert\":\"😀a\"},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 71" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀 \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"cc\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nc\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"delete\":6},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 72" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\\na猫猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a\\n\"},{\"insert\":\"\\n\\na猫猫\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 73" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫b😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"bc猫c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"a\\naa\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀猫b😀\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"bc猫c\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"a\\naa\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 74" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" b😀\"}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":4}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 75" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n猫猫b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\" \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\\nb\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"aa😀\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\\nb\"},{\"insert\":\"aa😀\\n\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 76" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀c😀aa猫\"},{\"insert\":\"b猫😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"a\"},{\"delete\":14}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 77" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a猫a😀猫😀猫c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"bc\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"b\"},{\"delete\":9},{\"retain\":1,\"attributes\":{\"font\":null}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 78" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b猫\\na \"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bb\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀bb\"},{\"insert\":\"😀a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\\n\"},{\"insert\":\"😀bb\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀a\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 79" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\\n😀c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"aac\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀a\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀a\\n\"},{\"delete\":9}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 80" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b ba b \"}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":9}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 81" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫 \"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"a\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-1\"}},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 82" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"c😀猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" c\\n\"}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":10}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 83" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aca\",\"attributes\":{\"bold\":true}},{\"insert\":\" \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\na猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\\n \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"\\na猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\\n \"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 84" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" ccb\"}]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"猫\\na\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"a\\nc\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"猫\\na\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"a\\nc\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 85" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ab😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":4}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 86" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\nb\"},{\"insert\":\"c\\n猫b猫😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\"},{\"insert\":\"c\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"c\\n\"},{\"delete\":12}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 87" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫😀\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 88" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a猫 c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\" c \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀\\n\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" \"},{\"delete\":2},{\"retain\":2,\"attributes\":{\"font\":null,\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\" \"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 89" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\n\"}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 90" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"😀cc猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-0\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"a\\n\"},{\"insert\":\"😀cc猫\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 91" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\nb😀ccc 猫\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"  \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"  a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":{\"image\":\"img-0\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"  \"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"  a\"},{\"delete\":10}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 92" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n \",\"attributes\":{\"bold\":true}},{\"insert\":\"c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\\nb \"},{\"insert\":\"a\\n\\na 猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\\nb \"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"a\\n\\na 猫\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 93" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c猫ab\"},{\"insert\":\"bb \",\"attributes\":{\"bold\":true}},{\"insert\":\"😀acc\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b猫\"},{\"insert\":\"a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"delete\":9}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 94" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bac\"}]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"insert\":\"猫\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"\\n\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 95" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a 😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"猫b bab\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ba\\nc\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\nbcc\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"ba\\nc\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\nbcc\"},{\"delete\":11}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 96" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\\n\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 97" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ac😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"abb\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫b\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\n\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":null,\"bold\":true}},{\"attributes\":{\"bold\":true},\"insert\":\"bb\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫b\\n\"},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\\n\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 98" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀cc\",\"attributes\":{\"bold\":true}},{\"insert\":\" \\nb\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\" ac\"}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":11}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 99" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b cc\"}]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-0\"}},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 100" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"bb猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"b😀a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bbba\"}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":null,\"color\":null}},{\"insert\":\"b\"},{\"delete\":4},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 101" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\na \"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"b\"},{\"insert\":\"\\na \"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 102" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"猫 \"}]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 103" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b猫a猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b猫a猫\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 104" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" ca\\nab\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\\n猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a\\n\\n猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"insert\":{\"image\":\"img-1\"}},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 105" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫\\n猫😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"b\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 106" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫c猫\"},{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"  caa\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" c\"},{\"insert\":\"  caa\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 107" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":\"c猫 b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"aba \"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c猫 b\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"aba \"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 108" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n\"},{\"insert\":\"猫b\\na\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"a猫 \\n\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\\n猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"aac\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"c\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"retain\":1,\"attributes\":{\"font\":null,\"italic\":true,\"color\":\"blue\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"font\":null,\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"font\":null,\"bold\":true}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"attributes\":{\"bold\":true},\"insert\":\"c\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 109" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c😀猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\\nb \",\"attributes\":{\"bold\":true}},{\"insert\":\"a\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫c\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫😀aa\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"c猫猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\\nc\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀猫c\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫😀aa\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"c猫猫\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫\\nc\"},{\"delete\":9}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 110" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\"},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":\"😀\\na\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"😀b c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" c😀a\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀\\na\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀b c\"},{\"insert\":\" c😀a\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 111" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀 cb\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" \"},{\"delete\":6}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 112" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 113" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" abca😀猫\\n\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n\\nc\\nbb\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n\\nc\\nbb\"},{\"delete\":9}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 114" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"😀c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"c\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\\n 猫\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\\n 猫\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 115" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\" \",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n猫a\"},{\"insert\":\"aa\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n猫a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"aa\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 116" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"c\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-2\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 117" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cac😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ba\\n\"},{\"insert\":\"猫a \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\" \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"c\\n猫c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ba\\n\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"猫a \"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" \"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"c\\n猫c\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 118" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" c\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \\n😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null,\"italic\":true,\"color\":\"blue\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":2},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 119" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" b😀a\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 120" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"}},{\"insert\":\" \\n猫a\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫cca\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫cc\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 121" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ac猫\"},{\"insert\":\"😀 b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"b \"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ac猫\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀 b\"},{\"insert\":\"b \"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 122" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a a\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"b\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"c\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"a a\\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\\n\"},{\"attributes\":{\"bold\":true},\"insert\":\"c\\n\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 123" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n c\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 124" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀 \"},{\"insert\":\"😀 \",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"italic\":null,\"color\":null}},{\"insert\":\" \"},{\"attributes\":{\"bold\":true},\"insert\":\"😀 \"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-1\"}},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 125" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"b猫\\n😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"c😀😀b 😀bb\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\" \"},{\"insert\":\"c😀😀b 😀bb\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 126" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 127" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"猫c😀猫\"}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":7}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 128" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 129" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"  猫\"}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"  猫\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 130" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" 猫\"}]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a \\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\n\"},{\"insert\":\"\\n😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"😀a😀😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"a \\n\"},{\"insert\":\"\\n\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"\\n😀\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀a😀😀\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 131" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c😀\",\"attributes\":{\"bold\":true}},{\"insert\":\" \"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c😀😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":null,\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" c\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-1\"}},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 132" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n\\n \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀cbb\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" b猫😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"b\\n\\n \"},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀cbb\"},{\"insert\":\" b猫😀\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 133" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-2\"}},{\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"bold\":true},\"insert\":\"😀\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 134" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"😀c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb\"},{\"insert\":\"a😀 \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"a\"},{\"delete\":2},{\"retain\":2},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" \"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 135" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫😀a猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b 😀\\n\"},{\"insert\":\"cb 😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"},{\"insert\":\"😀😀😀 \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\nb\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"insert\":\"\\n\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀😀\"},{\"delete\":14},{\"retain\":2},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" \"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 136" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 猫b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"bac\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀猫b \"},{\"insert\":\"   b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀猫b \"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"   b\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 137" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cab\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\n猫猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"cab\"},{\"insert\":\"\\n猫猫\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 138" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ca\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"c😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"acb \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-0\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"acb \"},{\"delete\":9}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 139" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\\nb\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bc\"},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bc\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":{\"image\":\"img-2\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 140" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n\"},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bab\"}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"ab\"},{\"delete\":2}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 141" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" baa\"}]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n猫\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 142" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"insert\":\"\\nc\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\nc\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 143" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}},{\"insert\":\" \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 144" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"insert\":\"\\ncac\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"c猫\\na\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"\\ncac\"},{\"insert\":\"c猫\\na\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 145" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"b\\nc\\n\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n \\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\n \"},{\"delete\":4},{\"retain\":1,\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 146" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ab😀 \"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"  \\n b😀\\nc\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c\"},{\"insert\":\"  \\n \"},{\"delete\":1},{\"retain\":3},{\"insert\":\"\\nc\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 147" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 148" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"bac\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"ab\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" ab\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" \"},{\"delete\":7},{\"retain\":2,\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 149" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\\n\"},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b猫ca 猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-2\"}},{\"attributes\":{\"bold\":true},\"insert\":\"b猫ca 猫\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 150" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\nab\"},{\"insert\":\"c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\\n\\n\"},{\"insert\":\"😀\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀😀\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\\n\\n\"},{\"attributes\":{\"bold\":true},\"insert\":\"😀\\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀😀\\n\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 151" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"cc\\n😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" c\"},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" c\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-2\"}},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 152" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a cc\"},{\"insert\":\"aaa\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c猫\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c猫\\n\"},{\"insert\":{\"image\":\"img-2\"}},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 153" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀c😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫 c\"},{\"insert\":\"b猫a\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"😀c😀\"},{\"insert\":\"猫 c\"},{\"attributes\":{\"bold\":true},\"insert\":\"b猫a\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 154" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"b \"},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 155" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\nb猫b\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"ab\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 156" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 157" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀a\"},{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b 😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" \\na猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"b 😀\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" \\na猫\"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 158" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\naa猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-0\"}},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 159" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 160" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ba😀\"},{\"insert\":\"😀\\n猫c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" 猫猫\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":{\"image\":\"img-0\"}},{\"delete\":13}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 161" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" cc😀\\n\\n😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\n\"},{\"delete\":10}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 162" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bacb\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"}},{\"delete\":6}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 163" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\n 😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"}},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 164" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\nb 😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\nca\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\nb 😀\"},{\"insert\":\"\\nca\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 165" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"ba\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\\n \"},{\"insert\":\" \",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\\n \"},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 166" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\\n😀\"},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"ccc \"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫b\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"c😀猫b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"猫b\\n\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c😀猫b\"},{\"delete\":12}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 167" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"a\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" \"}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"delete\":2}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 168" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\nc\",\"attributes\":{\"bold\":true}},{\"insert\":\" 猫b\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\n\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a猫a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null,\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫a\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"b\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 169" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 170" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀b猫a\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 171" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫ca \",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"baa\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":9}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 172" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" bac\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\n😀猫\"}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":8}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 173" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n猫 \",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":\"猫ac猫\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"ca\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫ac猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"c\"},{\"retain\":1,\"attributes\":{\"bold\":null,\"color\":\"red\"}},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 174" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"\\nc\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"ac\"},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫 bc\\n😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null,\"color\":\"red\"}},{\"insert\":\"猫 bc\\n😀\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 175" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\nb\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":null,\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-0\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 176" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b😀b\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\" bc\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"猫\\nb\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\na😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"c \\n\"},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":null,\"color\":null,\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"\\na😀\"},{\"insert\":\"c \\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-0\"}},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 177" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"\\na\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\nab\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n猫😀猫b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\\nab\"},{\"insert\":\"\\n猫😀猫b\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 178" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"猫\"}]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"  \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"  \"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 179" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"cc \"}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"cc \"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 180" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 181" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 😀b\"},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 182" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"b\\nb\\n\"},{\"insert\":\"猫c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"insert\":{\"image\":\"img-2\"}},{\"insert\":\"b\\nb\\n\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"猫c\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 183" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b猫c猫😀\\n\"},{\"insert\":{\"image\":\"img-2\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"猫 a\"},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 184" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" cc猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\"},{\"insert\":\"  c\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" b \"},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\"b \"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-1\"}},{\"delete\":8}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 185" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a \",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a \"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 186" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 187" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫ab\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"\\n\"},{\"insert\":\"猫\"},{\"delete\":6}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 188" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"\\nb\\n\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 189" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"c\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\na猫\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\" bab\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" \"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"\\na猫\\n\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" bab\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"insert\":\" \"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 190" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫c猫猫c猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"a 😀\"},{\"insert\":\" 😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":{\"image\":\"img-1\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀😀猫\"},{\"insert\":\"a 😀\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" 😀\"},{\"delete\":6},{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":null}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 191" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bb\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 192" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"c\"},{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"a b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":7}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 193" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\na\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀😀\"},{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"blue\",\"italic\":true}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 194" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":\"c猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"c猫\"},{\"insert\":{\"image\":\"img-0\"}},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 195" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 196" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n b\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"ca猫b\"},{\"insert\":\"猫 a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" \"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\n b\"},{\"insert\":\"ca猫b\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫 a\"},{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":null}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 197" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀c\\na\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"\\n😀c\\n\"},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":13}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 198" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"b猫ab\"},{\"insert\":\"\\nb\",\"attributes\":{\"bold\":true}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" cc\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\" cc\"},{\"insert\":\"猫\"},{\"delete\":7}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 199" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"c b😀\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":7}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 200" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\" \\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀ab\"},{\"insert\":\" \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀ab\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\" \"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 201" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":{\"image\":\"img-2\"}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 202" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b 猫a\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n猫😀\\na\\n a\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b 猫a\"},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\n猫😀\\na\\n a\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 203" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ab猫c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"c\"}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"aa猫c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"\\n\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-0\"}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"a\"},{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":null,\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":null,\"color\":null,\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 204" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb\\na\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":4}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 205" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"caa\"}]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bc猫c\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"bc猫c\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 206" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b \"},{\"insert\":\"c\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b \"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c\"},{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":null,\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 207" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀\\na\"},{\"insert\":\"c \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" a\\n \"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"insert\":\" a\\n\"},{\"delete\":6},{\"retain\":1,\"attributes\":{\"font\":null}}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 208" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"bac\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"img-0\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"bac\"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 209" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 210" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}},{\"insert\":\"b\\nb猫\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-2\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"a c\"},{\"attributes\":{\"bold\":true},\"insert\":\"b\\nb猫\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"img-0\"}},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 211" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 \",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"猫 \"}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 212" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"insert\":\"c\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"}},{\"attributes\":{\"italic\":true,\"color\":\"blue\"},\"insert\":\"c\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 213" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫猫\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"ca\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"c\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"a猫b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null,\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"ca\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c\"},{\"insert\":\"a猫b\"},{\"delete\":5}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 214" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫猫 \"},{\"insert\":\"猫\",\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nc猫\\n\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"c a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀  \",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"c猫\\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"c a\"},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀  \"},{\"delete\":4}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 215" {
  let before = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"猫\"}]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"img-2\"},\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\" ca\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":{\"image\":\"img-2\"}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\" ca\"},{\"delete\":1}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 216" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 猫😀b\"},{\"insert\":{\"image\":\"img-0\"},\"attributes\":{\"italic\":true,\"color\":\"blue\"}}]}",
  )
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 217" {
  let before = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a  \"},{\"insert\":{\"image\":\"img-1\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀\",\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"insert\":\"aac\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}}},{\"attributes\":{\"font\":{\"family\":\"Mono\",\"size\":\"12px\"}},\"insert\":\"😀\"},{\"insert\":\"aac\"},{\"delete\":3}]}",
  )
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 218" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(before.diff(after), expected)
}

///|
test "upstream randomized Delta diff 219" {
  let before = Delta::parse_json_compatible("{\"ops\":[]}")
  let after = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀ca\"},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"c \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀ca\"},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"c \"}]}",
  )
  assert_eq(before.diff(after), expected)
}
