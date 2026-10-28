///|
test "upstream randomized compose transform 0" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a \\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\\n\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"aa\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"insert\":\"a \\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"aa\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":null},\"insert\":\"aa\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 1" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"retain\":2},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 2" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n猫\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\\n猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\\n猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"b\\n猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 3" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(left.compose(right), Delta::parse_json_compatible("{\"ops\":[]}"))
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 4" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"delete\":4}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"retain\":1},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 5" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":5},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 6" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":1},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"😀a😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":3},{\"retain\":1},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"😀a😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 7" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"delete\":4}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"delete\":5},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":{\"image\":\"i0\"}}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 8" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[{\"retain\":1}]}")
  assert_eq(left.compose(right), Delta::parse_json_compatible("{\"ops\":[]}"))
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 9" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":\"😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 10" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\n猫\"}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"delete\":2},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"delete\":2},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 11" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b😀😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b😀😀\",\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 12" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\nb\",\"attributes\":{\"italic\":false}},{\"insert\":\"猫b \"},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"italic\":false}},{\"insert\":\"猫b \"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":7},{\"delete\":2}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":7},{\"delete\":2}]}"),
  )
}

///|
test "upstream randomized compose transform 13" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"\\n\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":\" \",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":2},{\"attributes\":{\"color\":null},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":null},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":null},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 14" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\" \"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"},{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"},{\"delete\":1},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"},{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"},{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 15" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫\"},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫猫\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫猫\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫猫\"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 16" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\",\"attributes\":{\"color\":null}},{\"delete\":2},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a a\",\"attributes\":{\"italic\":false}},{\"insert\":\" 猫😀\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":\" b\",\"attributes\":{\"italic\":false}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"italic\":false},\"insert\":\"a a\"},{\"attributes\":{\"bold\":true},\"insert\":\" 猫😀\"},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\" b\"},{\"delete\":2},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"italic\":false},\"insert\":\"a a\"},{\"attributes\":{\"bold\":true},\"insert\":\" 猫😀\"},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\" b\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":\"a a\"},{\"attributes\":{\"bold\":true},\"insert\":\" 猫😀\"},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\" b\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 17" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bbb\"}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"retain\":3},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 18" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" 😀😀\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":4}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"insert\":\"\\n猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"},\"color\":\"red\"}},{\"insert\":\" \",\"attributes\":{\"font\":{\"name\":\"Mono\"},\"italic\":false}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"retain\":8},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"},{\"delete\":4}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 19" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(left.compose(right), Delta::parse_json_compatible("{\"ops\":[]}"))
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 20" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n😀😀\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"\\n😀😀\"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"\\n😀😀\"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":null},\"insert\":\"\\n😀😀\"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 21" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"retain\":2},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i2\"}},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 22" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\\n\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":5}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"😀\\n😀\",\"attributes\":{\"italic\":false}},{\"insert\":\"ba\"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"\\n\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"italic\":false},\"insert\":\"😀\\n😀\"},{\"insert\":\"ba\"},{\"insert\":\"\\n\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"italic\":false},\"insert\":\"😀\\n😀\"},{\"insert\":\"ba\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"italic\":false},\"insert\":\"😀\\n😀\"},{\"insert\":\"ba\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 23" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":\"a\",\"attributes\":{\"color\":null}},{\"retain\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":null},\"insert\":\"a\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":null},\"insert\":\"a\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":null},\"insert\":\"a\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 24" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"retain\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 25" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":4},{\"retain\":2},{\"retain\":2,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":4},{\"retain\":2},{\"retain\":2,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 26" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
}

///|
test "upstream randomized compose transform 27" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 28" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n猫\",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫aa\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":\"  a\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫ab\",\"attributes\":{\"color\":null}},{\"insert\":\"\\na\"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫aa\"},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"  a\"},{\"attributes\":{\"color\":null},\"insert\":\"猫ab\"},{\"insert\":\"\\na\"},{\"insert\":\"b\\n猫\",\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫aa\"},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"  a\"},{\"attributes\":{\"color\":null},\"insert\":\"猫ab\"},{\"insert\":\"\\na\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫aa\"},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"  a\"},{\"attributes\":{\"color\":null},\"insert\":\"猫ab\"},{\"insert\":\"\\na\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 29" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"delete\":9}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"delete\":8}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"retain\":1},{\"delete\":9}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i0\"}},{\"delete\":9}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 30" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"\\n😀\",\"attributes\":{\"color\":null}},{\"insert\":\"b\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":\"b\"},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":5},{\"retain\":3},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"insert\":\"b\"},{\"delete\":2},{\"retain\":1},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":7},{\"delete\":3},{\"retain\":3},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":7},{\"delete\":3},{\"retain\":3},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 31" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 32" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n \",\"attributes\":{\"italic\":false}},{\"delete\":4},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" 😀\"}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" 😀\"},{\"insert\":\"b\\n \",\"attributes\":{\"italic\":false}},{\"delete\":4},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" 😀\"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"insert\":\" 😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 33" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 34" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"bab猫\",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\"},{\"insert\":{\"image\":\"i1\"}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\\n\"},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"ab猫\",\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\\n\"},{\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\\n\"},{\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 35" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\" \",\"attributes\":{\"color\":null}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"b 😀\",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\" \",\"attributes\":{\"color\":null}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"b 😀\",\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 36" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b猫 \"},{\"insert\":\"a\\n\",\"attributes\":{\"italic\":false}},{\"insert\":\"猫a\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"bbb\",\"attributes\":{\"color\":null}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"bbb\"},{\"insert\":\"猫 \"},{\"insert\":\"a\\n\",\"attributes\":{\"italic\":false}},{\"insert\":\"猫a\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"bbb\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"bbb\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 37" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":false,\"bold\":true}},{\"attributes\":{\"bold\":true},\"retain\":1},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 38" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫\\n b\",\"attributes\":{\"color\":null}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"😀猫\\n b\"},{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"😀猫\\n b\"},{\"retain\":4},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":null},\"insert\":\"😀猫\\n b\"},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 39" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bba\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"  \"}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"  \"},{\"insert\":\"bba\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"  \"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"insert\":\"  \"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 40" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n猫\"},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"insert\":\"a\\nb\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"},\"bold\":true}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"},\"color\":\"red\"}},{\"insert\":\"\\n猫\"},{\"retain\":1,\"attributes\":{\"bold\":true,\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"bold\":true,\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"a\\nb\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n猫\"},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"a\\nb\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n猫\"},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"a\\nb\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 41" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"retain\":3},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":3},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 42" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"retain\":3}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"delete\":6},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"delete\":6},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"delete\":6},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"delete\":6},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 43" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aa\\n\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":\" \",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\" a\",\"attributes\":{\"italic\":false}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 猫\\n\",\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\" 猫\\n\"},{\"insert\":\"\\n\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":\" \",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\" a\",\"attributes\":{\"italic\":false}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\" 猫\\n\"},{\"retain\":3},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"bold\":true},\"insert\":\" 猫\\n\"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 44" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":\"😀b\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":4},{\"retain\":3},{\"delete\":4}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2},{\"retain\":2},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":4},{\"delete\":2},{\"retain\":3},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":4},{\"delete\":2},{\"retain\":3},{\"delete\":4}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 45" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 46" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" \"}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" \"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":\" \"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 47" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":\"a \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀a \"},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ab\"},{\"insert\":\" \\n\",\"attributes\":{\"italic\":false}},{\"delete\":5}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"ab\"},{\"attributes\":{\"italic\":false},\"insert\":\" \\n\"},{\"insert\":\" \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀a \"},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"ab\"},{\"attributes\":{\"italic\":false},\"insert\":\" \\n\"},{\"retain\":1},{\"delete\":2},{\"retain\":7},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":\"ab\"},{\"attributes\":{\"italic\":false},\"insert\":\" \\n\"},{\"delete\":2},{\"retain\":7},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 48" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":5}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n \"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\" \"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"},\"color\":\"red\"}},{\"delete\":5},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\" \"},{\"retain\":1},{\"insert\":\"\\n \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\" \"},{\"insert\":\"\\n \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 49" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"  😀\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":\" 😀\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\" 😀\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":\" 😀\"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"insert\":\" 😀\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":\" 😀\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":\" 😀\"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"retain\":4},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":\" 😀\"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 50" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":\"b猫 \"}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n b\",\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n \"},{\"attributes\":{\"bold\":true},\"insert\":\"\\n b\"},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":\"b猫 \"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n \"},{\"attributes\":{\"bold\":true},\"insert\":\"\\n b\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n \"},{\"attributes\":{\"bold\":true},\"insert\":\"\\n b\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 51" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"delete\":4},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":\" a猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"delete\":6},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\" a猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"delete\":2},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\" a猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"delete\":2},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\" a猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 52" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a😀\"},{\"delete\":4},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"  \"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"  \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a😀\"},{\"delete\":4},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"  \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"insert\":\"  \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 53" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n \"},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":null}},{\"insert\":\"b\",\"attributes\":{\"italic\":false}},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"猫\"},{\"attributes\":{\"italic\":false},\"insert\":\"b\"},{\"insert\":\"a\\n \"},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"猫\"},{\"attributes\":{\"italic\":false},\"insert\":\"b\"},{\"retain\":3},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":null},\"insert\":\"猫\"},{\"attributes\":{\"italic\":false},\"insert\":\"b\"},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 54" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a猫 \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n \",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀a\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"italic\":false}},{\"insert\":\" \"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}},{\"retain\":1},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"猫😀a\"},{\"attributes\":{\"italic\":false},\"insert\":\"a\"},{\"insert\":\" \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"insert\":\"猫 \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n \",\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"猫😀a\"},{\"attributes\":{\"italic\":false},\"insert\":\"a\"},{\"insert\":\" \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}},{\"retain\":6},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":5},{\"attributes\":{\"bold\":true},\"insert\":\"猫😀a\"},{\"attributes\":{\"italic\":false},\"insert\":\"a\"},{\"insert\":\" \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 55" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}"),
  )
}

///|
test "upstream randomized compose transform 56" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫b\",\"attributes\":{\"italic\":false}},{\"delete\":5},{\"retain\":2,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"猫b\"},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"猫b\"},{\"delete\":5},{\"retain\":3},{\"retain\":2,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"猫b\"},{\"delete\":5},{\"retain\":3},{\"retain\":2,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 57" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":6},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"delete\":6},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 58" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":4}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\"},{\"delete\":3},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\"},{\"retain\":1},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\"},{\"delete\":4}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 59" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"b\\nb\"},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"insert\":\"b\\nb\"},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 60" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"retain\":1},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 61" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 \",\"attributes\":{\"color\":\"red\"}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":5}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"}},{\"retain\":2},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 62" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 63" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"retain\":1},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"b \"}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\",\"attributes\":{\"bold\":true}},{\"delete\":2},{\"retain\":1},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"  \",\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a\\n\"},{\"delete\":3},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"  \"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"b \"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a\\n\"},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"  \"},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a\\n\"},{\"delete\":1},{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"  \"},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 64" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\\n\"},{\"insert\":\"\\n\",\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"insert\":\"\\n\\n\"},{\"insert\":\"\\n\",\"attributes\":{\"italic\":false}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":{\"image\":\"i3\"}}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 65" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb\"},{\"insert\":\"\\nb\",\"attributes\":{\"italic\":false}},{\"insert\":\"😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n😀b\",\"attributes\":{\"color\":null}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"insert\":\"猫\\nb\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\nb\",\"attributes\":{\"italic\":false}},{\"insert\":\"😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n😀b\",\"attributes\":{\"color\":null}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":10},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 66" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"abb \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"abb \"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"abb \"},{\"retain\":2},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"abb \"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 67" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":\"😀ba\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"color\":null}},{\"delete\":6}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\" \"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\" \"},{\"retain\":8},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"attributes\":{\"color\":null},\"insert\":\" \"},{\"delete\":4}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 68" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n 😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀😀\",\"attributes\":{\"italic\":false}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\" \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\" \"},{\"insert\":\" 😀\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀😀\",\"attributes\":{\"italic\":false}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\" \"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\" \"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 69" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"retain\":5},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":5},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 70" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":{\"image\":\"i3\"}}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 71" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" b猫\"},{\"insert\":\"猫\",\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" b猫\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" b猫\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" b猫\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 72" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":4},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b\"},{\"retain\":3},{\"delete\":4},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b\"},{\"delete\":4},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 73" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 74" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"delete\":6}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":7},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 75" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"b猫\"},{\"delete\":2},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"b猫\"},{\"delete\":2},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 76" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 77" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":9},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"delete\":9},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"delete\":9},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"delete\":9},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 78" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":\"\\n猫a\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n猫a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n猫a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n猫a\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"retain\":2},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 79" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫b\",\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"delete\":4},{\"retain\":3,\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n😀a \"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n😀a \"},{\"insert\":\"😀猫b\",\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"delete\":4},{\"retain\":3,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"\\n😀a \"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"insert\":\"\\n😀a \"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 80" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b b\",\"attributes\":{\"italic\":false}},{\"delete\":4},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b b\",\"attributes\":{\"italic\":false}},{\"delete\":4},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 81" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\n\"},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\\n\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true,\"italic\":false}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"}},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\\n\"},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":\"a\\n\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 82" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(left.compose(right), Delta::parse_json_compatible("{\"ops\":[]}"))
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 83" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\\nb\",\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":\"   \",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a\\nb\",\"attributes\":{\"italic\":false,\"color\":null}},{\"attributes\":{\"bold\":true},\"insert\":\"   \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"retain\":3},{\"attributes\":{\"bold\":true},\"insert\":\"   \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\"   \"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 84" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n😀\"},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n😀\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 85" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":4}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":1},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 86" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" a\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"italic\":false,\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"a\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 87" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"retain\":3},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a猫猫\",\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a猫猫\"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"retain\":3},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"a猫猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\"a猫猫\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 88" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀\",\"attributes\":{\"italic\":false}},{\"retain\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"a😀\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"a😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":\"a😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 89" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\",\"attributes\":{\"bold\":true}},{\"insert\":\" a\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":4,\"attributes\":{\"color\":\"red\"}},{\"delete\":7}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"😀😀\",\"attributes\":{\"color\":\"red\",\"bold\":true}},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":7},{\"retain\":4,\"attributes\":{\"color\":\"red\"}},{\"delete\":7}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":7},{\"retain\":4,\"attributes\":{\"color\":\"red\"}},{\"delete\":7}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 90" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"\\na \"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\na \"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\na \"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\na \"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 91" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\" 😀\",\"attributes\":{\"italic\":false}},{\"delete\":6}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\" 😀\"},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\" 😀\"},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\" 😀\"},{\"delete\":6}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 92" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":5,\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"😀\"}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"😀\"},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":5,\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"😀\"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"😀\"}]}"),
  )
}

///|
test "upstream randomized compose transform 93" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 94" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\\n \",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"b\\n  \",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\\n \"},{\"retain\":2},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\\n \"},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 95" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫😀😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b猫\",\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"retain\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"insert\":\"猫😀😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b猫\",\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\"},{\"retain\":8},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"insert\":\"a\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 96" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"retain\":1},{\"insert\":\"a猫\"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"insert\":\"a猫\"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"retain\":3},{\"insert\":\"a猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"retain\":1},{\"insert\":\"a猫\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 97" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 98" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":false}},{\"retain\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"font\":{\"name\":\"Mono\"},\"italic\":false}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":2},{\"retain\":1},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":2},{\"retain\":1},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 99" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"retain\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\"猫b\",\"attributes\":{\"bold\":true}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫\"},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"bold\":true},\"insert\":\"猫b\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫\"},{\"retain\":1},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"bold\":true},\"insert\":\"猫b\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"bold\":true},\"insert\":\"猫b\"},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 100" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a \"},{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a \"},{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a \"},{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a \"},{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 101" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 a\",\"attributes\":{\"color\":null}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\"\\n猫\",\"attributes\":{\"italic\":false}},{\"insert\":\"\\n\\n\"},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"delete\":4},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫\"},{\"insert\":\"猫\\n\\n\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":4},{\"delete\":2},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":4},{\"delete\":2},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 102" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 103" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":\"red\",\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 104" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" aa\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":\"猫😀a\"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫😀a\"},{\"insert\":\" aa\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫😀a\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫😀a\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 105" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"retain\":1}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 106" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"italic\":false}},{\"delete\":6}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"italic\":false}},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 107" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"retain\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀\\n\",\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"},\"italic\":false}},{\"attributes\":{\"color\":null},\"insert\":\"😀\\n\"},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":null},\"insert\":\"😀\\n\"},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":null},\"insert\":\"😀\\n\"},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 108" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(left.compose(right), Delta::parse_json_compatible("{\"ops\":[]}"))
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 109" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"retain\":1},{\"insert\":\"😀😀b\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"retain\":1},{\"insert\":\"😀😀b\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 110" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 111" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫\",\"attributes\":{\"color\":null}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫猫\",\"attributes\":{\"color\":null}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 112" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"  a\\n\\n\",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a\\n\\n\",\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"}},{\"retain\":6},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 113" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\naa\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\naa\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"retain\":3,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"retain\":3,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 114" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"😀😀 \",\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀😀 \"},{\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀😀 \"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀😀 \"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 115" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀 b\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":4},{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":4},{\"delete\":3}]}"),
  )
}

///|
test "upstream randomized compose transform 116" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":\"a\\n\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":\"a\\n\",\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"a\"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"insert\":\"a\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 117" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫\",\"attributes\":{\"italic\":false}},{\"delete\":4},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"猫猫\"},{\"delete\":5},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"猫猫\"},{\"retain\":1},{\"delete\":2},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":\"猫猫\"},{\"delete\":2},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 118" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":4}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"delete\":4},{\"retain\":2},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 119" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"\\na ab\",\"attributes\":{\"color\":null}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"retain\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"\\na ab\"},{\"retain\":2,\"attributes\":{\"italic\":false,\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"\\na ab\"},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"\\na ab\"},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 120" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"insert\":\"\\n \",\"attributes\":{\"italic\":false}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"attributes\":{\"italic\":false},\"insert\":\"\\n \"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"attributes\":{\"italic\":false},\"insert\":\"\\n \"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"attributes\":{\"italic\":false},\"insert\":\"\\n \"},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 121" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"color\":null}},{\"insert\":\"aa\",\"attributes\":{\"italic\":false}},{\"insert\":\" \\na\"},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\nb\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"color\":null}},{\"insert\":\"aa\",\"attributes\":{\"italic\":false}},{\"insert\":\" \\na\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 122" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 123" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"aa\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫\",\"attributes\":{\"italic\":false}},{\"retain\":3},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀😀😀\"},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"aa\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫\",\"attributes\":{\"italic\":false}},{\"retain\":3},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀😀😀\"},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"retain\":4},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀😀😀\"},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 124" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"猫 \",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"猫 \",\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 125" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"a\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"a\"},{\"retain\":1},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"a\"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 126" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"delete\":5}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"delete\":2},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"delete\":7},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 127" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":2},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 128" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a猫 \",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":\"😀\",\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"a猫 \"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":3},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"attributes\":{\"italic\":false},\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"a猫 \"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"italic\":false},\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"a猫 \"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"italic\":false},\"insert\":\"😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 129" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":4}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 130" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":3},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 131" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\na\"},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\na\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 132" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀a猫😀猫\"},{\"delete\":4}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"😀a猫😀猫\"},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 133" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫aa\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫aa\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫aa\"},{\"retain\":2},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫aa\"},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 134" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\",\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"😀😀\"},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"😀😀\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"😀😀\"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 135" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"insert\":\"b \\n\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"insert\":\"b \\n\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 136" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":\"a \",\"attributes\":{\"italic\":false}},{\"retain\":2},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":\"a \"},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":\"a \"},{\"retain\":3},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":\"a \"},{\"retain\":2},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 137" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"\\n猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"},\"italic\":false}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"insert\":{\"image\":\"i1\"}},{\"retain\":3},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"insert\":{\"image\":\"i1\"}},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 138" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a猫\\n\"},{\"delete\":5}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a猫\\n\"},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a猫\\n\"},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"a猫\\n\"},{\"delete\":5}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 139" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":false}},{\"retain\":1},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":false}},{\"retain\":1},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 140" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"delete\":8}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"delete\":8}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 141" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\nb\"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀猫\\nbb\",\"attributes\":{\"color\":\"red\"}},{\"delete\":6}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"a😀猫\\nbb\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"a😀猫\\nbb\"},{\"retain\":6},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a😀猫\\nbb\"},{\"delete\":6}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 142" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"color\":\"red\",\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 143" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"\\na \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}")
  assert_eq(left.compose(right), Delta::parse_json_compatible("{\"ops\":[]}"))
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":5},{\"delete\":5}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":5},{\"delete\":5}]}"),
  )
}

///|
test "upstream randomized compose transform 144" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"retain\":2,\"attributes\":{\"color\":null}},{\"insert\":\"aa\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\n\",\"attributes\":{\"bold\":true}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀\\n\"},{\"insert\":\"a\",\"attributes\":{\"italic\":false,\"bold\":true}},{\"insert\":\"a\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀\\n\"},{\"delete\":3},{\"retain\":3},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀\\n\"},{\"delete\":3},{\"retain\":3},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 145" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"insert\":\" b\",\"attributes\":{\"italic\":false}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"}},{\"retain\":3},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"italic\":false},\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"}},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 146" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"retain\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 147" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"b\",\"attributes\":{\"color\":null}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"b\"},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"b\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"b\"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 148" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n \",\"attributes\":{\"italic\":false}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}},{\"insert\":\"\\n \",\"attributes\":{\"italic\":false}},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 149" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
}

///|
test "upstream randomized compose transform 150" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫猫猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫猫猫\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"b\"},{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫猫猫\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"b\"},{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫猫猫\"},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"b\"},{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 151" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":\" 😀a\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":null},\"insert\":\" 😀a\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"delete\":1},{\"retain\":3},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":null},\"insert\":\" 😀a\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"retain\":2},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":null},\"insert\":\" 😀a\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"retain\":2},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 152" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"😀猫\"},{\"delete\":4}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"a\\n😀\",\"attributes\":{\"italic\":false}},{\"insert\":\"😀\"},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":\"a\\n😀\"},{\"insert\":\"😀\"},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":\"a\\n😀\"},{\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":\"a\\n😀\"},{\"insert\":\"😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 153" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 154" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 155" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀 \"},{\"insert\":\" a\",\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"😀 \"},{\"insert\":\" a\",\"attributes\":{\"bold\":true}},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
}

///|
test "upstream randomized compose transform 156" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 157" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":7}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":5}]}"),
  )
}

///|
test "upstream randomized compose transform 158" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"insert\":\"猫 \",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"delete\":8}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫 \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":8}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫 \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":8}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫 \"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":8}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 159" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"bold\":true}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"insert\":\" 猫 \",\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" 😀\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"attributes\":{\"italic\":false},\"insert\":\" 猫 \"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"retain\":4},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":\" 猫 \"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":\" 猫 \"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 160" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀😀猫\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n😀  😀\",\"attributes\":{\"italic\":false}},{\"insert\":\"\\n\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n😀  😀\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀😀猫\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n😀  😀\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"retain\":1},{\"delete\":2},{\"retain\":7},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":\"\\n😀  😀\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":2},{\"retain\":7},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 161" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\"\\n😀\",\"attributes\":{\"bold\":true}},{\"delete\":2},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n😀\"},{\"delete\":2},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n😀\"},{\"delete\":2},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n😀\"},{\"delete\":2},{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 162" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b \\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"color\":null}},{\"insert\":\"猫 \",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"color\":null}},{\"insert\":\"猫 \",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 163" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 164" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\",\"attributes\":{\"color\":null}},{\"retain\":2},{\"insert\":\"b😀😀\",\"attributes\":{\"italic\":false}},{\"insert\":\"猫猫\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\" 猫\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":4}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":\" 猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"b😀😀\",\"attributes\":{\"italic\":false}},{\"insert\":\"猫猫\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":\" 猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"retain\":2},{\"delete\":2},{\"retain\":7},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":null},\"insert\":\" 猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"delete\":2},{\"retain\":7},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 165" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b \",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":false}},{\"delete\":6}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" \",\"attributes\":{\"italic\":false,\"color\":\"red\"}},{\"insert\":\"猫\",\"attributes\":{\"italic\":false}},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 166" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"delete\":4}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\" \\n\",\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"b😀\"},{\"attributes\":{\"bold\":true},\"insert\":\" \\n\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"b😀\"},{\"attributes\":{\"bold\":true},\"insert\":\" \\n\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b😀\"},{\"attributes\":{\"bold\":true},\"insert\":\" \\n\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 167" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
}

///|
test "upstream randomized compose transform 168" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":6}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 169" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"retain\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 170" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"retain\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"delete\":2},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"delete\":2},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 171" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀\"},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"😀\"},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i3\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"😀\"},{\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"😀\"},{\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 172" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":\" b\"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"insert\":\" b\"},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"insert\":\" b\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"insert\":\" b\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 173" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(left.compose(right), Delta::parse_json_compatible("{\"ops\":[]}"))
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 174" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"delete\":4},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"delete\":4},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"color\":\"red\"},\"retain\":1},{\"insert\":{\"image\":\"i2\"}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 175" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\" a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\" a\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\" a\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":\" a\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 176" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" b\",\"attributes\":{\"color\":null}},{\"delete\":5}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":2},{\"insert\":\" \",\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":6},{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 177" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"insert\":\"\\nb\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀\"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀😀\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\nb\"},{\"insert\":\"😀\"},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀😀\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\nb\"},{\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀😀\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\nb\"},{\"insert\":\"😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 178" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"insert\":\" 😀\\n\",\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1},{\"insert\":\" 😀\\n\",\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 179" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\" 猫\"},{\"retain\":1},{\"insert\":\"ba\"},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\" 猫\"},{\"retain\":1},{\"insert\":\"ba\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 180" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 181" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"insert\":\"猫 😀\"},{\"retain\":3},{\"insert\":\" \"}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"insert\":\"猫 😀\"},{\"retain\":3},{\"insert\":\" \"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 182" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀😀\",\"attributes\":{\"bold\":true}},{\"delete\":3},{\"retain\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\"😀😀\"},{\"delete\":2},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":2},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\"😀😀\"},{\"retain\":1},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\"😀😀\"},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 183" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"insert\":\"ba\",\"attributes\":{\"italic\":false}},{\"retain\":2},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"insert\":\"猫猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"猫猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀😀\"},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫猫\"},{\"insert\":\"😀😀\"},{\"insert\":\"ba\",\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":2},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"insert\":\"猫猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫猫\"},{\"insert\":\"😀😀\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫猫\"},{\"insert\":\"😀😀\"},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 184" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫 \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫猫 \",\"attributes\":{\"font\":{\"name\":\"Mono\"},\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 185" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":1},{\"delete\":2},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"delete\":3},{\"retain\":1},{\"delete\":2},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"delete\":3},{\"retain\":1},{\"delete\":2},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 186" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\nb\",\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫猫\\n\"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫猫\\n\"},{\"insert\":\"\\nb\",\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"猫猫\\n\"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"insert\":\"猫猫\\n\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 187" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫ab\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"bb\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫a\",\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"bold\":true},\"insert\":\"bb\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"insert\":\"b\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"retain\":6},{\"delete\":1},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"bold\":true},\"insert\":\"bb\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"bold\":true},\"insert\":\"bb\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 188" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\"},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"insert\":\"😀\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"ab\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"😀\\n\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"ab\"},{\"insert\":\"a\",\"attributes\":{\"italic\":false}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"😀\\n\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"ab\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"😀\\n\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"ab\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 189" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
}

///|
test "upstream randomized compose transform 190" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"},{\"insert\":\"😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"insert\":\"猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"insert\":\"猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"insert\":\"猫\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 191" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":\"😀 b\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"color\":null}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":4},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"insert\":\" b\",\"attributes\":{\"font\":{\"name\":\"Mono\"},\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"},\"bold\":true}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":6},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":6},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 192" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i2\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i0\"}},{\"delete\":1},{\"retain\":2,\"attributes\":{\"bold\":true,\"italic\":false}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i0\"}},{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":\"\\n\"},{\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 193" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
}

///|
test "upstream randomized compose transform 194" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"ab\",\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫😀\"},{\"attributes\":{\"color\":null},\"insert\":\"ab\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫😀\"},{\"attributes\":{\"color\":null},\"insert\":\"ab\"},{\"retain\":1},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫😀\"},{\"attributes\":{\"color\":null},\"insert\":\"ab\"},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 195" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"aa\",\"attributes\":{\"italic\":false}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\\n\"},{\"insert\":\"a\\n \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫\\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\\n \"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":\"aa\",\"attributes\":{\"italic\":false}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"猫\\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\\n \"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"insert\":\"猫\\n\"},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\\n \"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 196" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"delete\":1},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 197" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀猫\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"insert\":\"b😀\",\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":\"b😀\"},{\"insert\":\"a😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀猫\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":\"b😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":\"b😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 198" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}"),
  )
}

///|
test "upstream randomized compose transform 199" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"b\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"}},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"aab\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"delete\":4}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"aab\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"aab\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"delete\":3},{\"retain\":2},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"aab\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"delete\":3},{\"retain\":2},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 200" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  let right = Delta::parse_json_compatible("{\"ops\":[{\"retain\":1}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 201" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(left.compose(right), Delta::parse_json_compatible("{\"ops\":[]}"))
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 202" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\" 😀 \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":\"😀\",\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n😀😀\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n😀😀\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":\" 😀 \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":\"😀\",\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n😀😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"attributes\":{\"color\":\"red\"},\"insert\":\"\\n😀😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 203" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":\"aa \"},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n猫\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n猫\"},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"insert\":\"aa \"},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n猫\"},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"italic\":false},\"insert\":\"\\n猫\"},{\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 204" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":\"猫猫\",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\na\",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b\"},{\"attributes\":{\"bold\":true},\"insert\":\"\\na\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":\"猫猫\",\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b\"},{\"attributes\":{\"bold\":true},\"insert\":\"\\na\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b\"},{\"attributes\":{\"bold\":true},\"insert\":\"\\na\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 205" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫😀\",\"attributes\":{\"italic\":false}},{\"delete\":9}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"delete\":9}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":{\"image\":\"i0\"}}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 206" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"delete\":6}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 207" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3},{\"insert\":\" \"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3},{\"insert\":\" \"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 208" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":2}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":2},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\" b猫\"},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":4},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\" b猫\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\" b猫\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\" b猫\"},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 209" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n😀b\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n😀b\",\"attributes\":{\"bold\":true}},{\"insert\":\"猫猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 210" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\",\"italic\":false}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 211" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"insert\":\"b  \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"italic\":false}},{\"retain\":3},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"猫\"},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":1},{\"retain\":2},{\"insert\":\"b  \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"猫\"},{\"retain\":3},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"猫\"},{\"retain\":3},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 212" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"retain\":1},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"},\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 213" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 \",\"attributes\":{\"bold\":true}},{\"insert\":\"a\\n \",\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":4}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"猫 \",\"attributes\":{\"bold\":true}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"retain\":5},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":5},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i1\"}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"delete\":4}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 214" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":null}},{\"delete\":3},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bb\"}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"bb\"},{\"retain\":2,\"attributes\":{\"color\":null}},{\"delete\":3},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bb\"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"bb\"}]}"),
  )
}

///|
test "upstream randomized compose transform 215" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫 b\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫 b\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫 b\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫 b\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 216" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b😀\\n\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"insert\":\"😀\\na\",\"attributes\":{\"italic\":false}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\\n\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\"😀\\na\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\\n\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\"😀\\na\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\\n\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"italic\":false},\"insert\":\"😀\\na\"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 217" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3},{\"retain\":2,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀 b\",\"attributes\":{\"italic\":false}},{\"delete\":2},{\"retain\":5,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"😀\",\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"😀 b\"},{\"delete\":4},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\",\"italic\":false}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"😀 b\"},{\"retain\":1},{\"retain\":4,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"😀\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":\"😀 b\"},{\"retain\":2},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"😀\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 218" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 219" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b\"}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 220" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":2}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
}

///|
test "upstream randomized compose transform 221" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"retain\":3},{\"insert\":\"\\n\"},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \",\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"retain\":3},{\"insert\":\"\\n\"},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 222" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":\"b\",\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"insert\":\" \"},{\"insert\":\" 猫\",\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"retain\":1},{\"insert\":\" \"},{\"attributes\":{\"bold\":true},\"insert\":\" 猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"retain\":1},{\"insert\":\" \"},{\"attributes\":{\"bold\":true},\"insert\":\" 猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"b\"},{\"retain\":1},{\"insert\":\" \"},{\"attributes\":{\"bold\":true},\"insert\":\" 猫\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 223" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":\"\\n😀\"},{\"insert\":\"😀aa\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"insert\":\"\\n😀\"},{\"insert\":\"😀aa\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":8},{\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 224" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"retain\":1}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"delete\":1},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 225" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":3,\"attributes\":{\"color\":null}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"italic\":false,\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 226" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"retain\":2},{\"insert\":\"\\n 😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n 😀\"},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"},\"italic\":false}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"retain\":2},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n 😀\"},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"retain\":2},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"\\n 😀\"},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 227" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\",\"italic\":false}},{\"insert\":\"猫\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"retain\":1},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i0\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"猫\"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 228" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"insert\":\"\\n猫😀😀a\\n\",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n b\",\"attributes\":{\"color\":null}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n猫😀😀a\\n\"},{\"attributes\":{\"color\":null},\"insert\":\"\\n b\"},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n猫😀😀a\\n\"},{\"attributes\":{\"color\":null},\"insert\":\"\\n b\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"attributes\":{\"bold\":true},\"insert\":\"\\n猫😀😀a\\n\"},{\"attributes\":{\"color\":null},\"insert\":\"\\n b\"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 229" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":5},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b \"},{\"delete\":4},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b \"},{\"retain\":2},{\"delete\":4},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b \"},{\"delete\":4},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 230" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}},{\"insert\":\" 猫a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"a\",\"attributes\":{\"color\":null}},{\"insert\":\"😀\",\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"a\"},{\"attributes\":{\"italic\":false},\"insert\":\"😀\"},{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}},{\"insert\":\" 猫a\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"a\"},{\"attributes\":{\"italic\":false},\"insert\":\"😀\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"a\"},{\"attributes\":{\"italic\":false},\"insert\":\"😀\"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 231" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":\"a\\n猫\"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":\"ba \"},{\"insert\":\"\\na \",\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"retain\":2}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"insert\":\"a\\n猫\"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":\"ba \"},{\"insert\":\"\\na \",\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 232" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b😀\"}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b😀\"}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b😀\"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\"b😀\"}]}"),
  )
}

///|
test "upstream randomized compose transform 233" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\\n\",\"attributes\":{\"color\":null}},{\"insert\":\"b猫\\n\",\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\\n\",\"attributes\":{\"color\":null}},{\"insert\":\"b猫\\n\",\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 234" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 235" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"\\n\",\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 236" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":3},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 237" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"retain\":3},{\"insert\":\"\\n \",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":3},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"retain\":3},{\"insert\":\"\\n \",\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 238" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"  \",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"  \",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 239" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b 😀\",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"insert\":\" \",\"attributes\":{\"bold\":true}},{\"insert\":\"😀😀\",\"attributes\":{\"italic\":false}},{\"insert\":\"猫猫😀😀 猫\"},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":\"😀😀\"},{\"insert\":\"猫猫😀😀 猫\"},{\"insert\":\"b 😀\",\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":\"😀😀\"},{\"insert\":\"猫猫😀😀 猫\"},{\"retain\":4},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":\"😀😀\"},{\"insert\":\"猫猫😀😀 猫\"},{\"retain\":1,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 240" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"b猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 241" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 猫\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\\n \",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":3},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"delete\":3},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" 猫\\n\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"b\\n\",\"attributes\":{\"bold\":true}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"delete\":2},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":3},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"delete\":3},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":3},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"delete\":3},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 242" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 243" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"a\"},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2},{\"insert\":\" a😀\"},{\"delete\":2},{\"retain\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"a a😀\"},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"retain\":3},{\"insert\":\" a😀\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"retain\":1},{\"insert\":\" a😀\"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 244" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"😀 ab\"},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"😀 ab\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"😀 ab\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"insert\":\"😀 ab\"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 245" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n \",\"attributes\":{\"bold\":true}},{\"insert\":\"a\\n\",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\n \",\"attributes\":{\"bold\":true}},{\"insert\":\"a\\n\",\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 246" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":\" 😀\\n\"},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"ba\"},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"insert\":\"ba😀\\n\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"insert\":\"ba\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i3\"}},{\"insert\":\"ba\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 247" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"😀\\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":7}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"delete\":5}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true,\"color\":\"red\"}},{\"delete\":11}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 248" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 249" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"italic\":false}},{\"retain\":2,\"attributes\":{\"color\":null}},{\"insert\":\"aba\",\"attributes\":{\"italic\":false}},{\"insert\":\"aa\",\"attributes\":{\"color\":null}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":2},{\"retain\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\",\"italic\":false}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":\"ba\",\"attributes\":{\"italic\":false}},{\"insert\":\"aa\",\"attributes\":{\"color\":null}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":1},{\"insert\":{\"image\":\"i1\"}},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 250" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":1}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":2},{\"retain\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":2},{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i3\"}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":2},{\"retain\":5},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":2},{\"retain\":5},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 251" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" a\"},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"a\"},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":3},{\"delete\":1}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":3},{\"delete\":1}]}"),
  )
}

///|
test "upstream randomized compose transform 252" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":\" \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"},\"italic\":false}},{\"insert\":\" \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"}},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 253" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀猫a\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"ab \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"ab \"},{\"insert\":\"😀猫\",\"attributes\":{\"bold\":true}},{\"insert\":\"a\"},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"ab \"},{\"retain\":4},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"ab \"},{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 254" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\" 猫😀😀猫\",\"attributes\":{\"italic\":false}},{\"delete\":1},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫\",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"delete\":6}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"insert\":\"😀猫\",\"attributes\":{\"italic\":false}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫\",\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"delete\":2},{\"retain\":7},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"delete\":2},{\"retain\":7},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 255" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":5,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"delete\":1},{\"retain\":2,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":5,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\"},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"color\":null},\"insert\":\"😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 256" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":null}},{\"delete\":5}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":5}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i3\"}},{\"delete\":5}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 257" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 258" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":6},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":6},{\"retain\":2,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 259" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":null}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":null}},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 260" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}"),
  )
}

///|
test "upstream randomized compose transform 261" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀\\n\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫b\",\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫b\"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"\\n\",\"attributes\":{\"italic\":false,\"color\":\"red\"}},{\"delete\":3},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫b\"},{\"retain\":4},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫b\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 262" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" a\"},{\"delete\":3},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}},{\"retain\":3}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" a\"}]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" a a\"},{\"delete\":3},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"insert\":\" a\"}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"insert\":\" a\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 263" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":3}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":6},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i1\"}},{\"retain\":5},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":7},{\"delete\":2}]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[{\"retain\":7},{\"delete\":2}]}"),
  )
}

///|
test "upstream randomized compose transform 264" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\n\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"delete\":6}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"delete\":6}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":\"\\n\"},{\"attributes\":{\"color\":null},\"insert\":{\"image\":\"i1\"}},{\"delete\":6}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 265" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"delete\":3},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"bb😀b\\n猫\"},{\"insert\":\"\\n\\n \",\"attributes\":{\"color\":null}},{\"delete\":2}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":6},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"bb😀b\\n猫\"},{\"attributes\":{\"color\":null},\"insert\":\"\\n\\n \"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"bb😀b\\n猫\"},{\"attributes\":{\"color\":null},\"insert\":\"\\n\\n \"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"bb😀b\\n猫\"},{\"attributes\":{\"color\":null},\"insert\":\"\\n\\n \"},{\"delete\":2}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 266" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 267" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1},{\"insert\":\"a\\n \",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"a\\n \"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"a\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":null},\"insert\":\"a\\n \"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":null},\"insert\":\"a\\n \"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 268" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 269" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\",\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":\"red\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":null},\"insert\":\"\\n\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":null},\"insert\":\"\\n\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"attributes\":{\"color\":null},\"insert\":\"\\n\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 270" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"insert\":\"猫a😀\",\"attributes\":{\"color\":null}},{\"insert\":\" \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":\"ab\",\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \\n\"},{\"insert\":\"a\",\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \\n\"},{\"attributes\":{\"color\":null},\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"insert\":\"猫a😀\",\"attributes\":{\"color\":null}},{\"insert\":\" \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":\"ab\",\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \\n\"},{\"attributes\":{\"color\":null},\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":9},{\"insert\":\" \\n\"},{\"attributes\":{\"color\":null},\"insert\":\"a\"},{\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i2\"}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 271" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" 😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":3},{\"insert\":\"a\",\"attributes\":{\"color\":\"red\"}},{\"delete\":3},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"insert\":\" 😀\",\"attributes\":{\"bold\":true}},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"delete\":3},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"retain\":6},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"delete\":3},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"猫\"},{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i3\"}},{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":\"a\"},{\"delete\":3},{\"retain\":3,\"attributes\":{\"italic\":false}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 272" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"bold\":true}},{\"retain\":3},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"italic\":false}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"retain\":2,\"attributes\":{\"color\":\"red\",\"bold\":true}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"color\":null}},{\"attributes\":{\"color\":\"red\"},\"retain\":1},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"bold\":true}},{\"retain\":1},{\"retain\":2,\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i2\"}},{\"retain\":3,\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"bold\":true}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 273" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀😀\"}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 274" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀a\",\"attributes\":{\"bold\":true}},{\"insert\":\"b😀\",\"attributes\":{\"color\":null}},{\"delete\":4}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀a\"},{\"attributes\":{\"color\":null},\"insert\":\"b😀\"},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀a\"},{\"attributes\":{\"color\":null},\"insert\":\"b😀\"},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"😀a\"},{\"attributes\":{\"color\":null},\"insert\":\"b😀\"},{\"delete\":4}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 275" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":4,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true,\"italic\":false}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"retain\":4,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":4,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":2},{\"retain\":3,\"attributes\":{\"bold\":true}},{\"retain\":4,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":3}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 276" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"insert\":\"bb猫\",\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"retain\":2,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"bb猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"retain\":2,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"bb猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":{\"image\":\"i2\"}},{\"retain\":2,\"attributes\":{\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i0\"}},{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i2\"}},{\"retain\":1,\"attributes\":{\"color\":\"red\"}},{\"attributes\":{\"color\":null},\"insert\":\"bb猫\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 277" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"b\"},{\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":null},\"insert\":\"b\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1},{\"attributes\":{\"color\":null},\"insert\":\"b\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 278" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"\\naa\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"italic\":false}},{\"insert\":\"猫 猫\",\"attributes\":{\"color\":null}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\"\\naa\",\"attributes\":{\"italic\":false}},{\"attributes\":{\"color\":null},\"insert\":\"猫 猫\"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"color\":null}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"attributes\":{\"color\":null},\"insert\":\"猫 猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"retain\":3,\"attributes\":{\"italic\":false}},{\"attributes\":{\"color\":null},\"insert\":\"猫 猫\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 279" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"delete\":2},{\"retain\":1,\"attributes\":{\"bold\":true}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"bold\":true,\"color\":null}},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}},{\"insert\":{\"image\":\"i0\"}},{\"delete\":4}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":2},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":{\"image\":\"i0\"}},{\"delete\":2},{\"retain\":2},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 280" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"color\":null}},{\"insert\":\"b\",\"attributes\":{\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"},\"color\":null}},{\"insert\":\"b\",\"attributes\":{\"font\":{\"name\":\"Mono\"},\"italic\":false}},{\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"retain\":3,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 281" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":3}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"delete\":2},{\"retain\":3,\"attributes\":{\"color\":\"red\"}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"delete\":5},{\"retain\":3,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":{\"image\":\"i1\"}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 282" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
  )
  let right = Delta::parse_json_compatible("{\"ops\":[]}")
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"color\":null}},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"italic\":false}},{\"delete\":1},{\"retain\":2,\"attributes\":{\"italic\":false}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible("{\"ops\":[]}"),
  )
}

///|
test "upstream randomized compose transform 283" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫😀\",\"attributes\":{\"bold\":true}}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"😀\\n\\n\",\"attributes\":{\"color\":\"red\"}},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":\"猫a猫\"}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\\n\\n\"},{\"insert\":{\"image\":\"i2\"},\"attributes\":{\"color\":\"red\",\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\",\"bold\":true}},{\"insert\":\"😀\",\"attributes\":{\"bold\":true}},{\"retain\":1,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":\"猫a猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\\n\\n\"},{\"retain\":4},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":\"猫a猫\"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":4},{\"attributes\":{\"color\":\"red\"},\"insert\":\"😀\\n\\n\"},{\"retain\":2,\"attributes\":{\"color\":\"red\"}},{\"retain\":3,\"attributes\":{\"color\":null}},{\"retain\":1,\"attributes\":{\"italic\":false}},{\"insert\":\"猫a猫\"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 284" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"insert\":\"猫猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀😀\"},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"b\",\"attributes\":{\"bold\":true}},{\"insert\":\"b😀\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"猫 \",\"attributes\":{\"bold\":true}},{\"retain\":1},{\"insert\":\" \",\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫 \"},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"italic\":false}},{\"attributes\":{\"italic\":false},\"insert\":\" \"},{\"insert\":\"猫猫\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀😀\"},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫 \"},{\"retain\":7},{\"attributes\":{\"italic\":false},\"insert\":\" \"}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":7},{\"attributes\":{\"bold\":true},\"insert\":\"b\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"b😀\"},{\"attributes\":{\"bold\":true},\"insert\":\"猫 \"},{\"attributes\":{\"italic\":false},\"insert\":\" \"}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 285" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"insert\":\"猫\",\"attributes\":{\"color\":\"red\"}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"delete\":1}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"color\":\"red\"},\"insert\":\"猫\"},{\"delete\":1}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 286" {
  let left = Delta::parse_json_compatible("{\"ops\":[{\"delete\":1}]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"delete\":1},{\"retain\":2,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 287" {
  let left = Delta::parse_json_compatible("{\"ops\":[]}")
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":3},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":3},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i0\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 288" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"😀 猫\",\"attributes\":{\"italic\":false}},{\"insert\":\"a\\n \"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\"bb\",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i1\"},\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"delete\":1}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"bb\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}},{\"insert\":\"😀 猫\",\"attributes\":{\"italic\":false}},{\"insert\":\"a\\n \"},{\"insert\":{\"image\":\"i0\"},\"attributes\":{\"bold\":true}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"bb\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"retain\":9},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":\"bb\"},{\"attributes\":{\"font\":{\"name\":\"Mono\"}},\"insert\":{\"image\":\"i1\"}}]}",
    ),
  )
}

///|
test "upstream randomized compose transform 289" {
  let left = Delta::parse_json_compatible(
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\",\"attributes\":{\"color\":null}},{\"insert\":\"a \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
  )
  let right = Delta::parse_json_compatible(
    "{\"ops\":[{\"insert\":\" \"},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}}]}",
  )
  assert_eq(
    left.compose(right),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}},{\"retain\":1,\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":\"\\n\",\"attributes\":{\"color\":null}},{\"insert\":\"a \",\"attributes\":{\"font\":{\"name\":\"Mono\"}}},{\"insert\":{\"image\":\"i3\"},\"attributes\":{\"italic\":false}},{\"delete\":2}]}",
    ),
  )
  assert_eq(
    left.transform(right, false),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
  assert_eq(
    left.transform(right, true),
    Delta::parse_json_compatible(
      "{\"ops\":[{\"insert\":\" \"},{\"attributes\":{\"italic\":false},\"insert\":{\"image\":\"i3\"}}]}",
    ),
  )
}
