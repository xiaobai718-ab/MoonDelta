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
  ignore(
    Delta::parse_json("{\"ops\":[{\"delete\":2147483647},{\"delete\":1}]}"),
  ) catch {
    _ => failed = true
  }
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
test "operation visitors report operation indexes" {
  let delta = Delta::new().insert_plain("ab").retain_plain(3).delete(1)
  let indexes = delta.map((_, index) => index)
  assert_eq(indexes, [0, 1, 2])
  let deletions = delta.filter((op, _) => op.kind() == "delete")
  assert_eq(deletions.length(), 1)
  let (accepted, rejected) = delta.partition(op => op.kind() != "delete")
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

///|
fn counter_number(value : Json) -> Double raise DeltaError {
  match value {
    Number(number, ..) => number
    _ => raise Invalid("counter embed must be a number")
  }
}

///|
fn counter_handlers() -> EmbedHandlers raise DeltaError {
  let handlers = EmbedHandlers::new()
  handlers.register(
    "counter",
    EmbedHandler::new(
      (base, update, _) => {
        Json::number(counter_number(base) + counter_number(update))
      },
      (update, _) => Json::number(-counter_number(update)),
      (_, other, _) => other,
    ),
  )
  handlers
}

///|
test "registered embed handler composes and inverts updates" {
  let handlers = counter_handlers()
  let base = Delta::new().insert_embed(
    Json::object({ "counter": Json::number(5) }),
    empty_attributes(),
  )
  let update = Delta::new().retain_embed(
    Json::object({ "counter": Json::number(2) }),
    empty_attributes(),
  )
  let changed = base.apply_with_handlers(update, handlers)
  let expected = Delta::new().insert_embed(
    Json::object({ "counter": Json::number(7) }),
    empty_attributes(),
  )
  assert_eq(changed, expected)
  let inverse = update.invert_with_handlers(base, handlers)
  assert_eq(changed.apply_with_handlers(inverse, handlers), base)
}

///|
test "registered embed handler transforms concurrent updates" {
  let handlers = counter_handlers()
  let base = Delta::new().insert_embed(
    Json::object({ "counter": Json::number(5) }),
    empty_attributes(),
  )
  let first = Delta::new().retain_embed(
    Json::object({ "counter": Json::number(2) }),
    empty_attributes(),
  )
  let second = Delta::new().retain_embed(
    Json::object({ "counter": Json::number(3) }),
    empty_attributes(),
  )
  let left = base
    .apply_with_handlers(first, handlers)
    .apply_with_handlers(
      first.transform_with_handlers(second, true, handlers),
      handlers,
    )
  let right = base
    .apply_with_handlers(second, handlers)
    .apply_with_handlers(
      second.transform_with_handlers(first, false, handlers),
      handlers,
    )
  assert_eq(left, right)
  assert_eq(left.operations()[0].attributes(), empty_attributes())
}

///|
test "each_line keeps delimiter attributes and can stop early" {
  let heading = Json::object({ "header": Json::number(2) })
  let doc = Delta::new()
    .insert_plain("Title")
    .insert_text("\n", heading)
    .insert_plain("body\nend")
  let seen : Array[String] = []
  let seen_attrs : Array[Json] = []
  doc.each_line((line, attrs, index) => {
    seen.push(index.to_string() + ":" + line_text_for_test(line))
    seen_attrs.push(attrs)
    true
  })
  assert_eq(seen, ["0:Title", "1:body", "2:end"])
  assert_eq(seen_attrs[0], heading)
  let stopped : Array[String] = []
  doc.each_line((line, _, _) => {
    stopped.push(line_text_for_test(line))
    false
  })
  assert_eq(stopped, ["Title"])
}

///|
test "each_line accepts custom delimiter and embedded objects" {
  let embed = Json::object({ "image": Json::string("picture") })
  let doc = Delta::new()
    .insert_plain("a")
    .insert_embed(embed, empty_attributes())
    .insert_plain("|b|")
  let seen : Array[Delta] = []
  doc.each_line(
    (line, _, _) => {
      seen.push(line)
      true
    },
    newline="|",
  )
  assert_eq(seen.length(), 2)
  assert_eq(
    seen[0],
    Delta::new().insert_plain("a").insert_embed(embed, empty_attributes()),
  )
  assert_eq(seen[1].plain_text(), Some("b"))
}

///|
test "large separated diff keeps unchanged interior" {
  let middle = "m".repeat(1500)
  let before = Delta::new().insert_plain("A" + middle + "B")
  let after = Delta::new().insert_plain("X" + middle + "Y")
  let patch = before.diff(after)
  assert_eq(before.apply(patch), after)
  let mut max_delete = 0
  for op in patch.operations() {
    if op.kind() == "delete" && op.length() > max_delete {
      max_delete = op.length()
    }
  }
  assert_eq(max_delete, 1)
}

///|
fn line_text_for_test(line : Delta) -> String {
  match line.plain_text() {
    Some(text) => text
    None => ""
  }
}

///|
test "cursor-aware diff locates repeated-text insertion and deletion" {
  let old = Delta::new().insert_plain("aaa")
  let longer = Delta::new().insert_plain("aaaa")
  let insertion = old.diff_at(longer, 1)
  assert_eq(insertion, Delta::new().retain_plain(1).insert_plain("a"))
  assert_eq(old.apply(insertion), longer)
  let deletion = longer.diff_at(old, 1)
  assert_eq(deletion, Delta::new().retain_plain(1).delete(1))
  assert_eq(longer.apply(deletion), old)
}

///|
test "operation iterator splits text and reports exhausted state" {
  let delta = Delta::new()
    .insert_plain("abc")
    .insert_embed(
      Json::object({ "image": Json::string("x") }),
      empty_attributes(),
    )
  let iterator = delta.iterator()
  assert_true(iterator.has_next())
  assert_eq(iterator.peek_kind(), "insert")
  assert_eq(iterator.peek_length(), 3)
  assert_eq(iterator.next(1), InsertText("a", empty_attributes()))
  assert_eq(iterator.peek_length(), 2)
  assert_eq(iterator.next(2), InsertText("bc", empty_attributes()))
  assert_eq(iterator.peek_length(), 1)
  assert_eq(iterator.rest().length(), 1)
  assert_true(!iterator.has_next())
}

///|
test "upstream diff fixtures preserve attributes across operation boundaries" {
  let bold = Json::object({ "bold": Json::boolean(true) })
  let italic = Json::object({ "italic": Json::boolean(true) })
  let red = Json::object({ "color": Json::string("red") })
  let old = Delta::new().insert_text("12", bold).insert_text("34", italic)
  let target = Delta::new().insert_text("123", red)
  let expected = Delta::new()
    .retain(
      2,
      Json::object({ "bold": Json::null(), "color": Json::string("red") }),
    )
    .retain(
      1,
      Json::object({ "italic": Json::null(), "color": Json::string("red") }),
    )
    .delete(1)
  assert_eq(old.diff(target), expected)
}

///|
test "upstream diff fixtures distinguish embed and NUL text" {
  let embed = Json::object({ "embed": Json::number(1) })
  let old = Delta::new().insert_embed(embed, empty_attributes())
  let target = Delta::new().insert_plain("\u{0000}")
  let expected = Delta::new().insert_plain("\u{0000}").delete(1)
  assert_eq(old.diff(target), expected)
}

///|
test "upstream diff fixtures replace changed embeds" {
  let old = Delta::new().insert_embed(
    Json::object({ "embed": Json::number(1) }),
    empty_attributes(),
  )
  let target = Delta::new().insert_embed(
    Json::object({ "embed": Json::number(2) }),
    empty_attributes(),
  )
  let expected = Delta::new()
    .insert_embed(
      Json::object({ "embed": Json::number(2) }),
      empty_attributes(),
    )
    .delete(1)
  assert_eq(old.diff(target), expected)
}

///|
test "cursor ranges locate a repeated-text insertion" {
  let before = Delta::new().insert_plain("aaa")
  let after = Delta::new().insert_plain("aaaa")
  let cursor = CursorInfo::new(CursorRange::new(1, 0), CursorRange::new(1, 1))
  let patch = before.diff_with_cursor_info(after, cursor)
  assert_eq(patch, Delta::new().retain_plain(1).insert_plain("a"))
  assert_eq(before.apply(patch), after)
}

///|
test "cursor ranges locate a replacement" {
  let before = Delta::new().insert_plain("abc")
  let after = Delta::new().insert_plain("aXc")
  let cursor = CursorInfo::new(CursorRange::new(1, 1), CursorRange::new(1, 1))
  let patch = before.diff_with_cursor_info(after, cursor)
  assert_eq(patch, Delta::new().retain_plain(1).insert_plain("X").delete(1))
  assert_eq(before.apply(patch), after)
}

///|
test "invalid cursor ranges fall back to a correct diff" {
  let before = Delta::new().insert_plain("abc")
  let after = Delta::new().insert_plain("aXc")
  let cursor = CursorInfo::new(CursorRange::new(99, 1), CursorRange::new(99, 1))
  let patch = before.diff_with_cursor_info(after, cursor)
  assert_eq(before.apply(patch), after)
}

///|
test "raw constructor and concat preserve noncanonical interior operations" {
  let raw = Delta::from_ops_raw([
    InsertText("a", empty_attributes()),
    InsertText("b", empty_attributes()),
  ])
  assert_eq(raw.count(), 2)
  let combined = raw.concat(Delta::new().insert_plain("c"))
  assert_eq(combined.count(), 2)
  assert_eq(combined.operations()[0], InsertText("a", empty_attributes()))
  assert_eq(combined.operations()[1], InsertText("bc", empty_attributes()))
  assert_eq(raw.count(), 2)
}

///|
test "slice and iterator default-argument equivalents" {
  let delta = Delta::new().insert_plain("abcd")
  assert_eq(delta.slice_all(), delta)
  assert_eq(delta.slice_from(2), Delta::new().insert_plain("cd"))
  let iterator = delta.iterator()
  assert_eq(iterator.next_full(), InsertText("abcd", empty_attributes()))
  assert_true(!iterator.has_next())
}

///|
test "formatting and text operations converge under transformation" {
  let base = Delta::new().insert_plain("abc")
  let bold = Json::object({ "bold": Json::boolean(true) })
  let italic = Json::object({ "italic": Json::boolean(true) })
  let clear_bold = Json::object({ "bold": Json::null() })
  let changes : Array[Delta] = []
  for position in 0..<=3 {
    changes.push(Delta::new().retain_plain(position).insert_plain("X"))
    changes.push(Delta::new().retain_plain(position).insert_text("Y", bold))
    if position < 3 {
      changes.push(Delta::new().retain_plain(position).delete(1))
      changes.push(Delta::new().retain_plain(position).retain(1, bold))
      changes.push(Delta::new().retain_plain(position).retain(1, italic))
      changes.push(Delta::new().retain_plain(position).retain(1, clear_bold))
    }
  }
  for first in changes {
    assert_eq(base.apply(first).apply(first.invert(base)), base)
    for second in changes {
      let left = base.apply(first).apply(first.transform(second, true))
      let right = base.apply(second).apply(second.transform(first, false))
      assert_eq(left, right)
    }
  }
}

///|
test "upstream compose primitive cases" {
  let bold = Json::object({ "bold": Json::boolean(true) })
  let red = Json::object({ "color": Json::string("red") })
  assert_eq(
    Delta::new().insert_plain("A").compose(Delta::new().insert_plain("B")),
    Delta::new().insert_plain("BA"),
  )
  assert_eq(
    Delta::new().insert_plain("A").compose(Delta::new().delete(1)),
    Delta::new(),
  )
  assert_eq(
    Delta::new().delete(1).compose(Delta::new().insert_plain("B")),
    Delta::new().insert_plain("B").delete(1),
  )
  assert_eq(
    Delta::new().delete(1).compose(Delta::new().delete(1)),
    Delta::new().delete(2),
  )
  assert_eq(
    Delta::new().retain(1, red).compose(Delta::new().delete(1)),
    Delta::new().delete(1),
  )
  assert_eq(
    Delta::new()
    .insert_text("A", bold)
    .compose(Delta::new().retain(1, Json::object({ "bold": Json::null() }))),
    Delta::new().insert_plain("A"),
  )
  assert_eq(
    Delta::new()
    .insert_plain("Hello")
    .compose(Delta::new().retain_plain(3).insert_plain("X")),
    Delta::new().insert_plain("HelXlo"),
  )
}

///|
test "upstream compose retains beyond inserted text and embed attributes" {
  let embed = Json::object({ "embed": Json::number(1) })
  let source = Delta::new().insert_embed(
    embed,
    Json::object({ "src": Json::string("image.png") }),
  )
  let change = Delta::new().retain(
    1,
    Json::object({ "alt": Json::string("logo") }),
  )
  let expected = Delta::new().insert_embed(
    embed,
    Json::object({
      "src": Json::string("image.png"),
      "alt": Json::string("logo"),
    }),
  )
  assert_eq(source.compose(change), expected)
  assert_eq(
    Delta::new().insert_plain("Hello").compose(Delta::new().retain_plain(10)),
    Delta::new().insert_plain("Hello"),
  )
  assert_eq(
    Delta::new()
    .retain_plain(4)
    .insert_plain("Hello")
    .compose(Delta::new().delete(9)),
    Delta::new().delete(4),
  )
}

///|
test "upstream transform alternating edits" {
  let first = Delta::new().retain_plain(2).insert_plain("si").delete(5)
  let second = Delta::new()
    .retain_plain(1)
    .insert_plain("e")
    .delete(5)
    .retain_plain(1)
    .insert_plain("ow")
  let expected_first = Delta::new()
    .retain_plain(1)
    .insert_plain("e")
    .delete(1)
    .retain_plain(2)
    .insert_plain("ow")
  let expected_second = Delta::new()
    .retain_plain(2)
    .insert_plain("si")
    .delete(1)
  assert_eq(first.transform(second, false), expected_first)
  assert_eq(second.transform(first, false), expected_second)
}

///|
test "upstream combined inversion restores formatted document" {
  let bold = Json::object({ "bold": Json::boolean(true) })
  let italic = Json::object({ "italic": Json::boolean(true) })
  let red = Json::object({ "color": Json::string("red") })
  let red_bold = Json::object({
    "color": Json::string("red"),
    "bold": Json::boolean(true),
  })
  let change = Delta::new()
    .retain_plain(2)
    .delete(2)
    .insert_text("AB", italic)
    .retain(
      2,
      Json::object({ "italic": Json::null(), "bold": Json::boolean(true) }),
    )
    .retain(2, red)
    .delete(1)
  let base = Delta::new()
    .insert_text("123", bold)
    .insert_text("456", italic)
    .insert_text("789", red_bold)
  let expected = Delta::new()
    .retain_plain(2)
    .insert_text("3", bold)
    .insert_text("4", italic)
    .delete(2)
    .retain(
      2,
      Json::object({ "italic": Json::boolean(true), "bold": Json::null() }),
    )
    .retain_plain(2)
    .insert_text("9", red_bold)
  let inverse = change.invert(base)
  assert_eq(inverse, expected)
  assert_eq(base.apply(change).apply(inverse), base)
}
