///|
fn assert_upstream_diff(
  before : String,
  after : String,
  expected : String,
) -> Unit raise Error {
  let left = Delta::parse_json_compatible(before)
  let right = Delta::parse_json_compatible(after)
  let wanted = Delta::parse_json_compatible(expected)
  assert_eq(left.diff(right), wanted)
  assert_eq(left.apply(wanted), right)
}

///|
test "upstream diff formats one character" {
  assert_upstream_diff(
    "{\"ops\":[{\"insert\":\"A\"}]}", "{\"ops\":[{\"insert\":\"A\",\"attributes\":{\"bold\":true}}]}",
    "{\"ops\":[{\"retain\":1,\"attributes\":{\"bold\":true}}]}",
  )
}

///|
test "upstream diff replaces embed payload" {
  assert_upstream_diff(
    "{\"ops\":[{\"insert\":{\"embed\":1}}]}", "{\"ops\":[{\"insert\":{\"embed\":2}}]}",
    "{\"ops\":[{\"insert\":{\"embed\":2}},{\"delete\":1}]}",
  )
}

///|
test "upstream diff distinguishes embed from NUL text" {
  assert_upstream_diff(
    "{\"ops\":[{\"insert\":{\"embed\":1}}]}", "{\"ops\":[{\"insert\":\"\\u0000\"}]}",
    "{\"ops\":[{\"insert\":\"\\u0000\"},{\"delete\":1}]}",
  )
}

///|
test "upstream diff aligns attribute boundaries" {
  assert_upstream_diff(
    "{\"ops\":[{\"insert\":\"12\",\"attributes\":{\"bold\":true}},{\"insert\":\"34\",\"attributes\":{\"italic\":true}}]}",
    "{\"ops\":[{\"insert\":\"123\",\"attributes\":{\"color\":\"red\"}}]}", "{\"ops\":[{\"retain\":2,\"attributes\":{\"bold\":null,\"color\":\"red\"}},{\"retain\":1,\"attributes\":{\"italic\":null,\"color\":\"red\"}},{\"delete\":1}]}",
  )
}

///|
test "upstream diff replaces unrelated styled words" {
  assert_upstream_diff(
    "{\"ops\":[{\"insert\":\"Bad\",\"attributes\":{\"color\":\"red\"}},{\"insert\":\"cat\",\"attributes\":{\"color\":\"blue\"}}]}",
    "{\"ops\":[{\"insert\":\"Good\",\"attributes\":{\"bold\":true}},{\"insert\":\"dog\",\"attributes\":{\"italic\":true}}]}",
    "{\"ops\":[{\"insert\":\"Good\",\"attributes\":{\"bold\":true}},{\"insert\":\"dog\",\"attributes\":{\"italic\":true}},{\"delete\":6}]}",
  )
}
