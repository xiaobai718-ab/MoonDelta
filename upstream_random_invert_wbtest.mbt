///|
test "upstream randomized invert 0" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":4},{\"retain\":1},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"attributes\":{\"italic\":true},\"insert\":\"b\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"😀\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 1" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 2" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b😀\"},{\"insert\":\"b\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"retain\":1},{\"delete\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\"},{\"attributes\":{\"italic\":true},\"insert\":\"b\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 3" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\"},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 4" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"b😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"insert\":\"😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":2},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 5" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\"},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":1},{\"insert\":\"\\n\"},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 6" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀猫猫\"},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":2},{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":2},{\"insert\":\"猫\"},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 7" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 8" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫\"},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"retain\":5},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1},{\"retain\":5},{\"insert\":\"猫\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 9" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\\n\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 10" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"delete\":2},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 11" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 12" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\"},{\"insert\":\"a\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\"},{\"delete\":3},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"insert\":\"a\"},{\"delete\":3}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 13" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"\\nba\"},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":true}},{\"retain\":1},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"delete\":2},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"italic\":true},\"insert\":\"😀\"},{\"delete\":1},{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 14" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible("{\"ops\":[{\"retain\":3}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 15" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b猫\"},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"delete\":2},{\"retain\":1},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b\"},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 16" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a猫😀\"},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":1},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\"},{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1},{\"retain\":2,\"attributes\":{\"color\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"delete\":3},{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 17" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 18" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 19" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 20" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 21" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 22" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"insert\":\"😀猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 23" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 24" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"insert\":\"a\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"attributes\":{\"italic\":true},\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 25" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 26" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"猫\"},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"insert\":\"b\"},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 27" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"b\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 28" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\"},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"bb\"},{\"delete\":1},{\"retain\":4},{\"insert\":{\"image\":\"i0\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"b\"},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"italic\":true},\"insert\":\"b\"},{\"delete\":2},{\"retain\":4},{\"insert\":{\"image\":\"i1\"}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 29" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\"},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"猫\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 30" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\na\"},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i2\"}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\"},{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":3},{\"attributes\":{\"italic\":true},\"insert\":{\"image\":\"i1\"}},{\"delete\":2},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 31" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"retain\":2},{\"insert\":\"a\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 32" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"\\na\"}]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"retain\":1},{\"insert\":\"猫\"},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 33" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"😀\"},{\"retain\":1},{\"insert\":\"\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 34" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n😀\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"delete\":1},{\"retain\":2},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"delete\":3},{\"retain\":1},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":2},{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"insert\":\"b\"},{\"delete\":2},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 35" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":true}},{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"retain\":2},{\"insert\":\"猫\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 36" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 37" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫\"},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\"},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"retain\":4},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 38" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 39" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible("{\"ops\":[{\"retain\":1}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 40" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"delete\":5},{\"retain\":1,\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"insert\":\"\\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 41" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\\n\"},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"retain\":1},{\"insert\":\"\\n\"},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 42" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"😀\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":1},{\"insert\":\"😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null}},{\"insert\":\"b\"},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 43" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\na😀\"},{\"insert\":\"猫猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":4},{\"insert\":\"b\"},{\"retain\":1},{\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":4},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 44" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 45" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\na\",\"attributes\":{\"bold\":true}},{\"insert\":\"bb\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"delete\":1},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"retain\":1},{\"delete\":2},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"b\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 46" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1},{\"insert\":\"a\"},{\"retain\":1},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\\n\"},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"b\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 47" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"a\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"bold\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 48" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫ba\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":2},{\"insert\":\"b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 49" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 50" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"insert\":\"b\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 51" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 52" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 53" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫b\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"猫\"},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\"},{\"delete\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":\"猫b\"},{\"insert\":\"b\"},{\"delete\":4}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 54" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 55" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\"},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"delete\":2},{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"insert\":\"b\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 56" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 57" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 58" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"😀\"},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"猫\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":7},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":7},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 59" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"retain\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 60" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 61" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\"},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"retain\":4},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\"},{\"delete\":2},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":4},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"insert\":\"\\n\"},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 62" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 63" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":1},{\"delete\":1},{\"retain\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"b\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 64" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n\"},{\"delete\":2},{\"retain\":2},{\"insert\":\"b\"},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"}},{\"delete\":2},{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 65" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫😀\"},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"a\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"retain\":1},{\"delete\":2},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 66" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b😀\"},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀猫a\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"retain\":1},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"retain\":3},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":true}},{\"retain\":3},{\"insert\":\"\\n\"},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":1},{\"retain\":3},{\"delete\":1},{\"retain\":3},{\"delete\":1},{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 67" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"insert\":\"b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 68" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"insert\":\"b\"},{\"delete\":4}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 69" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"delete\":1},{\"retain\":2},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 70" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":4},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":4},{\"insert\":{\"image\":\"i2\"}},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 71" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀\"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":1},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 72" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\\n\"},{\"insert\":\"a\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\"},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"\\n\"},{\"retain\":1},{\"delete\":2},{\"retain\":2},{\"delete\":1},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"a\\n\"},{\"retain\":2},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 73" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"italic\":true},\"insert\":{\"image\":\"i1\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"italic\":true},\"insert\":{\"image\":\"i0\"}},{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 74" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 75" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 76" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 77" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\"},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"insert\":\"b\"},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 78" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}},{\"insert\":\"b猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":1},{\"retain\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"猫\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 79" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 80" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":true}},{\"insert\":\"a\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"a\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 81" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\\n\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":1},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"a\"},{\"attributes\":{\"bold\":true},\"insert\":\"b\\n\"},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 82" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"\\n\"}]}")
  let change = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 83" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 84" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 85" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\"},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"delete\":4},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"insert\":\"b\"},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 86" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"a\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 87" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫猫\"},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":2},{\"delete\":1},{\"retain\":1},{\"insert\":\"b\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"delete\":1},{\"retain\":2},{\"insert\":\"猫\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 88" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀a\"},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\"},{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"italic\":true}},{\"retain\":5},{\"insert\":\"猫\"},{\"retain\":1},{\"insert\":\"😀\"},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":null}},{\"retain\":5},{\"delete\":1},{\"retain\":1},{\"delete\":2},{\"retain\":1},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 89" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 90" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"\\n猫\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 91" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\"},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"},{\"insert\":\"😀\\n\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":2},{\"insert\":\"a\\n\"},{\"delete\":4}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\"},{\"retain\":2},{\"attributes\":{\"italic\":true},\"insert\":\"😀\\n\"},{\"insert\":{\"image\":\"i0\"}},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 92" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":true}},{\"insert\":\"\\n😀\"},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"retain\":2},{\"retain\":2,\"attributes\":{\"italic\":true}},{\"retain\":3},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1},{\"retain\":2},{\"retain\":2,\"attributes\":{\"italic\":null}},{\"retain\":3},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 93" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 94" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 95" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 96" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 97" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"attributes\":{\"italic\":true},\"insert\":\"😀\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 98" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 99" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"😀\"}]}")
  let change = Delta::parse_json_compatible("{\"ops\":[{\"retain\":2}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 100" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\\n😀\"},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":3},{\"retain\":1},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"insert\":\"a\"},{\"retain\":1},{\"delete\":1},{\"retain\":2,\"attributes\":{\"bold\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 101" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ba\"},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"italic\":true},\"insert\":\"a\"},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 102" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\"},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"delete\":3}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 103" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\"},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"delete\":2},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 104" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\"},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"insert\":\"a\"},{\"delete\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1},{\"retain\":1},{\"insert\":\"\\n\"},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"b\"},{\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 105" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n😀\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":1},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3},{\"retain\":1},{\"insert\":\"b\"},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"😀\"},{\"insert\":{\"image\":\"i0\"}},{\"delete\":1},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 106" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 107" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":3},{\"insert\":\"猫\"},{\"delete\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":3},{\"attributes\":{\"italic\":true},\"insert\":\"a\"},{\"attributes\":{\"bold\":true},\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 108" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 109" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 110" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":3},{\"delete\":1},{\"retain\":2},{\"insert\":\"猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":3},{\"attributes\":{\"italic\":true},\"insert\":{\"image\":\"i1\"}},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 111" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 112" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bb\"}]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 113" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"delete\":1},{\"retain\":3},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"😀\"},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":3},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 114" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 115" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"a\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":2},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 116" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫😀\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1,\"attributes\":{\"bold\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 117" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"ab猫\"},{\"insert\":\"a😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"delete\":2},{\"retain\":2},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\"a\"},{\"retain\":1},{\"insert\":\"猫\"},{\"attributes\":{\"bold\":true},\"insert\":\"a\"},{\"delete\":1},{\"retain\":2},{\"attributes\":{\"italic\":true},\"insert\":\"猫\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 118" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"😀b\"}]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 119" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible("{\"ops\":[{\"retain\":1}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 120" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\"},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"b\"},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 121" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"猫\"},{\"attributes\":{\"italic\":true},\"insert\":\"\\n\"},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"attributes\":{\"italic\":true},\"insert\":{\"image\":\"i1\"}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 122" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 123" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\"},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"delete\":2},{\"retain\":4}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"delete\":1},{\"retain\":2},{\"insert\":\"😀\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 124" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 125" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"😀\"},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"猫\"},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\"},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":2},{\"insert\":{\"image\":\"i0\"}},{\"retain\":1},{\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"😀\"},{\"retain\":2},{\"delete\":1},{\"retain\":1},{\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 126" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"猫b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"delete\":2},{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":2},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"delete\":1},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"delete\":1},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 127" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\"},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"insert\":\"a\"},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 128" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 129" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 130" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 131" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible("{\"ops\":[{\"retain\":2}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 132" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"😀\"}]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"italic\":true}},{\"insert\":\"a\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"italic\":null}},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 133" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":true}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"retain\":2},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"attributes\":{\"italic\":true},\"insert\":\"😀\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 134" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"猫\"},{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 135" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"a\"},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 136" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":\"\\n😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":3},{\"retain\":1},{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n😀\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 137" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\"},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"ab\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":6},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":6},{\"attributes\":{\"italic\":true},\"insert\":\"ab\"},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 138" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"delete\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\\n\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 139" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀b\"},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"retain\":2},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"delete\":4},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1},{\"retain\":2},{\"insert\":\"😀b\"},{\"attributes\":{\"italic\":true},\"insert\":\"b\"},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 140" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\"},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"italic\":true}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 141" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ba\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\"},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":3},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"italic\":true},\"insert\":\"b\"},{\"delete\":1},{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 142" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"retain\":2}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 143" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\"},{\"insert\":\"ab\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":1},{\"insert\":\"b\"},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫a\"},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 144" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"a\"},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"retain\":3},{\"delete\":1},{\"retain\":1},{\"retain\":2,\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":3},{\"insert\":{\"image\":\"i1\"}},{\"retain\":1},{\"retain\":2,\"attributes\":{\"italic\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 145" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"retain\":2},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"retain\":1,\"attributes\":{\"bold\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 146" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a猫\"},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":true}},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 147" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"insert\":\"\\nb\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\nb\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"delete\":3},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"retain\":1},{\"attributes\":{\"italic\":true},\"insert\":\"\\nb\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"retain\":1,\"attributes\":{\"bold\":null}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 148" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\"},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫😀\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":true},\"insert\":\"😀\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 149" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\"},{\"insert\":\"猫😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":4},{\"insert\":\"😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"retain\":4},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 150" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n😀\"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"delete\":1},{\"retain\":1},{\"delete\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 151" {
  let base = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}")
  let change = Delta::parse_json_compatible("{\"ops\":[{\"retain\":1}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 152" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":5},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":5},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 153" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 154" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\"},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":3},{\"insert\":\"a\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\"},{\"retain\":3},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 155" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\nb\"},{\"insert\":\"b\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"delete\":2},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"delete\":1},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\"b\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 156" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"attributes\":{\"italic\":true},\"insert\":\"猫\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 157" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"delete\":1},{\"retain\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 158" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":true}},{\"insert\":\"😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":null}},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 159" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"😀\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null}},{\"delete\":2}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 160" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\"},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":true}},{\"retain\":2},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"delete\":1},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 161" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":true}},{\"retain\":1},{\"insert\":\"a\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 162" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":null}},{\"delete\":1},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 163" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\"},{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":5},{\"delete\":1},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":5},{\"insert\":\"a\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 164" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\"},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"b猫\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\"b猫\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 165" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\"},{\"insert\":\"😀猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"insert\":\"b\"},{\"delete\":2},{\"retain\":1},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":1},{\"delete\":2},{\"retain\":1},{\"insert\":\"猫\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"😀\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 166" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀ba\"},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1},{\"insert\":\"a\"},{\"retain\":1},{\"insert\":\"😀\\n\"},{\"delete\":1},{\"retain\":1},{\"insert\":\"\\n\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"retain\":1},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n\"},{\"delete\":3},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 167" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 168" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":true}},{\"retain\":1},{\"delete\":2},{\"retain\":1},{\"insert\":\"a\"}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"insert\":\"\\n\"},{\"retain\":1},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 169" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"italic\":true},\"insert\":{\"image\":\"i2\"}}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 170" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 171" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible("{\"ops\":[]}")
  let expected = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 172" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\"},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"b\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"insert\":\"a\"},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":2},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":5},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 173" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\"},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"😀猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"insert\":\"😀\"},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"retain\":1},{\"delete\":2},{\"retain\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 174" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"😀\"}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"😀\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 175" {
  let base = Delta::parse_json_compatible("{\"ops\":[]}")
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":true}}]}",
  )
  let expected = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 176" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\"},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a\"},{\"insert\":\"a\",\"attributes\":{\"bold\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2},{\"insert\":\"a\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":true}},{\"retain\":1},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"retain\":2},{\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":null}},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 177" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"b\"},{\"insert\":\"b😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"retain\":1},{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"retain\":2},{\"insert\":\"猫\"},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":2}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":1},{\"retain\":2},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 178" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\\n\"},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"retain\":2,\"attributes\":{\"italic\":true}},{\"retain\":2},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":6},{\"attributes\":{\"italic\":true},\"insert\":\"猫\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}

///|
test "upstream randomized invert 179" {
  let base = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":true}},{\"insert\":\"\\n\"},{\"insert\":\"😀\",\"attributes\":{\"italic\":true}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a\"},{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}}]}",
  )
  let change = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":true}},{\"retain\":4},{\"insert\":{\"image\":\"i2\"}},{\"delete\":2},{\"retain\":1}]}",
  )
  let expected = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":4},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  assert_eq(change.invert(base), expected)
  assert_eq(base.apply(change).apply(expected), base)
}
