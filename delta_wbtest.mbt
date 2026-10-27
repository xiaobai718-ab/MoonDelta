///|
test "JSON text round trip" {
  let delta = Delta::parse_json("{\"ops\":[{\"insert\":\"Hello\\n\"}]}")
  assert_eq(delta.plain_text(), Some("Hello\n"))
  assert_eq(delta.stringify(), "{\"ops\":[{\"insert\":\"Hello\\n\"}]}")
  assert_eq(Delta::from_json(delta.to_json()), delta)
}

///|
test "bare operation array is accepted" {
  let delta = Delta::parse_json("[{\"insert\":\"a\"},{\"insert\":\"b\"}]")
  assert_eq(delta.plain_text(), Some("ab"))
  assert_eq(delta.count(), 1)
}

///|
test "embed round trip" {
  let delta = Delta::parse_json(
    "{\"ops\":[{\"insert\":{\"image\":\"x.png\"}},{\"insert\":\"\\n\"}]}",
  )
  assert_eq(delta.length(), 2)
  assert_eq(Delta::from_json(delta.to_json()), delta)
}

///|
test "invalid multiple actions fail" {
  let mut failed = false
  ignore(Delta::parse_json("{\"ops\":[{\"insert\":\"x\",\"delete\":1}]}")) catch {
    _ => failed = true
  }
  assert_true(failed)
}

///|
test "invalid fractional length fails" {
  let mut failed = false
  ignore(Delta::parse_json("{\"ops\":[{\"delete\":1.5}]}")) catch {
    _ => failed = true
  }
  assert_true(failed)
}

///|
test "oversized Delta length fails before integer overflow" {
  let mut failed = false
  ignore(Delta::parse_json("{\"ops\":[{\"delete\":2147483647},{\"delete\":1}]}"))
  catch { _ => failed = true }
  assert_true(failed)
}

///|
test "canonical operation order and merging" {
  let delta = Delta::new().delete(2).insert_plain("X").delete(3)
  assert_eq(delta, Delta::new().insert_plain("X").delete(5))
  assert_eq(Delta::new().insert_plain("a").insert_plain("b").count(), 1)
}

///|
test "slice text and embeds" {
  let embed = Json::object({ "image": Json::string("x") })
  let delta = Delta::new()
    .insert_plain("abc")
    .insert_embed(embed, empty_attributes())
    .insert_plain("de")
  assert_eq(delta.slice(1, 3).plain_text(), Some("bc"))
  assert_eq(delta.slice(3, 4).count(), 1)
  assert_eq(delta.slice(1, 5).length(), 4)
}

///|
test "compose inserts and deletes" {
  let base = Delta::new().insert_plain("abcd")
  assert_eq(
    base.apply(Delta::new().retain_plain(2).insert_plain("X")).plain_text(),
    Some("abXcd"),
  )
  assert_eq(
    base.apply(Delta::new().retain_plain(1).delete(2)).plain_text(),
    Some("ad"),
  )
  assert_eq(
    Delta::new().insert_plain("x").compose(Delta::new().delete(1)),
    Delta::new(),
  )
}

///|
test "compose two changes" {
  let base = Delta::new().insert_plain("abcd")
  let first = Delta::new().retain_plain(2).insert_plain("x")
  let second = Delta::new().retain_plain(3).insert_plain("y")
  assert_eq(base.apply(first).apply(second), base.apply(first.compose(second)))
}

///|
test "attribute compose diff invert" {
  let old = Json::object({
    "bold": Json::boolean(true),
    "color": Json::string("red"),
  })
  let new = Json::object({
    "italic": Json::boolean(true),
    "color": Json::string("blue"),
  })
  let change = attributes_diff(old, new)
  assert_eq(attributes_compose(old, change, false), new)
  assert_eq(attributes_compose(new, attributes_invert(change, old), false), old)
}

///|
test "attribute transform priority" {
  let a = Json::object({ "bold": Json::boolean(true) })
  let b = Json::object({
    "bold": Json::boolean(false),
    "italic": Json::boolean(true),
  })
  assert_eq(
    attributes_transform(a, b, true),
    Json::object({ "italic": Json::boolean(true) }),
  )
  assert_eq(attributes_transform(a, b, false), b)
}

///|
test "operational transform simultaneous inserts converge" {
  let base = Delta::new().insert_plain("abc")
  let a = Delta::new().retain_plain(1).insert_plain("X")
  let b = Delta::new().retain_plain(1).insert_plain("Y")
  let left = base.apply(a).apply(a.transform(b, true))
  let right = base.apply(b).apply(b.transform(a, false))
  assert_eq(left, right)
  assert_eq(left.plain_text(), Some("aXYbc"))
}

///|
test "transform overlapping deletion" {
  let a = Delta::new().delete(2)
  let b = Delta::new().delete(2)
  assert_eq(a.transform(b, false), Delta::new())
}

///|
test "position transform handles inserts" {
  let change = Delta::new().retain_plain(2).insert_plain("XY")
  assert_eq(change.transform_position(2, false), 4)
  assert_eq(change.transform_position(2, true), 2)
  assert_eq(change.transform_position(3, false), 5)
}

///|
test "position transform handles deletes" {
  let change = Delta::new().retain_plain(2).delete(3)
  assert_eq(change.transform_position(3, false), 2)
  assert_eq(change.transform_position(7, false), 4)
}

///|
test "invert replacement" {
  let base = Delta::new().insert_plain("abc")
  let change = Delta::new().retain_plain(1).delete(1).insert_plain("X")
  assert_eq(base.apply(change).apply(change.invert(base)), base)
}

///|
test "invert formatting" {
  let bold = Json::object({ "bold": Json::boolean(true) })
  let italic = Json::object({ "italic": Json::boolean(true) })
  let base = Delta::new().insert_text("ab", bold)
  let change = Delta::new().retain(2, italic)
  assert_eq(base.apply(change).apply(change.invert(base)), base)
}

///|
test "diff text replacement" {
  let before = Delta::new().insert_plain("cat")
  let after = Delta::new().insert_plain("cut")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "diff formatting only" {
  let before = Delta::new().insert_plain("x")
  let after = Delta::new().insert_text(
    "x",
    Json::object({ "bold": Json::boolean(true) }),
  )
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "diff embed insertion and deletion" {
  let embed = Json::object({ "image": Json::string("picture") })
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new()
    .insert_plain("a")
    .insert_embed(embed, empty_attributes())
    .insert_plain("b")
  assert_eq(before.apply(before.diff(after)), after)
  assert_eq(after.apply(after.diff(before)), before)
}

///|
test "diff text matrix" {
  let texts = [
    "", "a", "b", "ab", "ba", "abc", "ac", "cab", "cat", "cut", "hello",
  ]
  for old in texts {
    for next in texts {
      let before = Delta::new().insert_plain(old)
      let after = Delta::new().insert_plain(next)
      assert_eq(before.apply(before.diff(after)), after)
    }
  }
}

///|
test "diff emoji keeps surrogate pairs intact" {
  let before = Delta::new().insert_plain("a😀b")
  let after = Delta::new().insert_plain("a🚀b")
  assert_eq(before.length(), 4)
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "diff long common prefix" {
  let prefix = "A".repeat(2000)
  let before = Delta::new().insert_plain(prefix + "old")
  let after = Delta::new().insert_plain(prefix + "new")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "line splitting preserves block attributes" {
  let heading = Json::object({ "header": Json::number(2) })
  let doc = Delta::new()
    .insert_plain("Title")
    .insert_text("\n", heading)
    .insert_plain("body\n")
  let lines = doc.lines()
  assert_eq(lines.length(), 2)
  assert_eq(lines[0].content.plain_text(), Some("Title"))
  assert_eq(lines[0].attributes, heading)
  assert_eq(lines[0].start, 0)
  assert_eq(lines[1].content.plain_text(), Some("body"))
  assert_eq(lines[1].start, 6)
}

///|
test "unterminated last line is included" {
  let doc = Delta::new().insert_plain("a\nb")
  let lines = doc.lines()
  assert_eq(lines.length(), 2)
  assert_true(lines[0].terminated)
  assert_true(!lines[1].terminated)
  assert_eq(lines[1].content.plain_text(), Some("b"))
}

///|
test "history undo and redo" {
  let original = Delta::new().insert_plain("abc")
  let history = History::new(original, 3)
  let edit = Delta::new().retain_plain(1).delete(1).insert_plain("X")
  history.apply(edit)
  assert_eq(history.document().plain_text(), Some("aXc"))
  assert_true(history.undo())
  assert_eq(history.document(), original)
  assert_true(history.redo())
  assert_eq(history.document().plain_text(), Some("aXc"))
}

///|
test "new history edit clears redo" {
  let history = History::new(Delta::new().insert_plain("abc"), 3)
  history.apply(Delta::new().insert_plain("x"))
  assert_true(history.undo())
  history.apply(Delta::new().insert_plain("y"))
  assert_true(!history.can_redo())
  assert_true(!history.redo())
}

///|
test "history bounds the undo stack" {
  let history = History::new(Delta::new().insert_plain("a"), 2)
  history.apply(Delta::new().insert_plain("b"))
  history.apply(Delta::new().insert_plain("c"))
  history.apply(Delta::new().insert_plain("d"))
  assert_eq(history.undo_depth(), 2)
  assert_true(history.undo())
  assert_true(history.undo())
  assert_true(!history.undo())
  assert_eq(history.document().plain_text(), Some("ba"))
}

///|
test "operation visitors report cumulative offsets" {
  let delta = Delta::new().insert_plain("ab").retain_plain(3).delete(1)
  let offsets = delta.map((_, offset) => offset)
  assert_eq(offsets, [0, 2, 5])
  let deletions = delta.filter((op, _) => op.kind() == "delete")
  assert_eq(deletions.length(), 1)
  let (accepted, rejected) = delta.partition((_, offset) => offset < 3)
  assert_eq(accepted.length(), 2)
  assert_eq(rejected.length(), 1)
  assert_eq(delta.reduce(0, (sum, op, _) => sum + op.length()), 6)
}

///|
test "embed retain update is rejected until a handler exists" {
  let embed = Json::object({ "image": Json::string("x") })
  let base = Delta::new().insert_embed(embed, empty_attributes())
  let change = Delta::new().retain_embed(embed, empty_attributes())
  let mut failed = false
  ignore(base.apply(change)) catch {
    _ => failed = true
  }
  assert_true(failed)
}
