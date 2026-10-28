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
test "upstream eachLine visits complete prefix lines before a non-insert" {
  let raw = Delta::from_ops_raw([
    InsertText("first\nsecond", empty_attributes()),
    Retain(1, empty_attributes()),
  ])
  let seen : Array[String] = []
  raw.each_line((line, _, _) => {
    match line.plain_text() {
      Some(value) => seen.push(value)
      None => ()
    }
    true
  })
  assert_eq(seen, ["first"])
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
  assert_eq(deletion, Delta::new().delete(1))
  assert_eq(longer.apply(deletion), old)
  assert_eq(longer.diff_at(old, 2), Delta::new().retain_plain(1).delete(1))
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
  assert_true(iterator.has_next())
  ignore(iterator.next_full())
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
test "upstream cursor selection replaces old range at resulting caret" {
  let before = Delta::new().insert_plain("xxx")
  let after = Delta::new().insert_plain("xx")
  let cursor = CursorInfo::new(CursorRange::new(0, 2), CursorRange::new(1, 0))
  let patch = before.diff_with_cursor_info(after, cursor)
  assert_eq(patch, Delta::new().insert_plain("x").delete(2))
  assert_eq(before.apply(patch), after)
}

///|
test "cursor info distinguishes backward deletion from forward deletion" {
  let before = Delta::new().insert_plain("aaaa")
  let after = Delta::new().insert_plain("aaa")
  let backward = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(1, 0))
  let forward = CursorInfo::new(CursorRange::new(2, 0), CursorRange::new(2, 0))
  assert_eq(
    before.diff_with_cursor_info(after, backward),
    Delta::new().retain_plain(1).delete(1),
  )
  assert_eq(
    before.diff_with_cursor_info(after, forward),
    Delta::new().retain_plain(2).delete(1),
  )
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
test "upstream compose preserves untouched raw operation boundaries" {
  let raw = Delta::from_ops_raw([
    InsertText("a", empty_attributes()),
    InsertText("b", empty_attributes()),
    InsertText("c", empty_attributes()),
  ])
  let unchanged = raw.compose(Delta::new().retain_plain(3))
  assert_eq(unchanged.count(), 3)
  assert_eq(unchanged.operations(), raw.operations())
  let bold = Json::object({ "bold": Json::boolean(true) })
  let changed = raw.compose(Delta::new().retain(1, bold))
  assert_eq(changed.operations(), [
    InsertText("a", bold),
    InsertText("b", empty_attributes()),
    InsertText("c", empty_attributes()),
  ])
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
test "upstream compose retains at start and joins around deletion" {
  let bold = Json::object({ "bold": Json::boolean(true) })
  let source = Delta::new()
    .insert_text("A", bold)
    .insert_plain("B")
    .insert_text("C", bold)
    .retain_plain(5)
    .delete(1)
  let change = Delta::new().retain_plain(4).insert_plain("D")
  let expected = Delta::new()
    .insert_text("A", bold)
    .insert_plain("B")
    .insert_text("C", bold)
    .retain_plain(1)
    .insert_plain("D")
    .retain_plain(4)
    .delete(1)
  assert_eq(source.compose(change), expected)
  let joined = Delta::new()
    .insert_text("A", bold)
    .insert_plain("B")
    .insert_text("C", bold)
    .insert_plain("D")
    .insert_text("E", bold)
    .insert_plain("F")
    .compose(Delta::new().retain_plain(1).delete(1))
  assert_eq(
    joined,
    Delta::new()
    .insert_text("AC", bold)
    .insert_plain("D")
    .insert_text("E", bold)
    .insert_plain("F"),
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
test "upstream transform conflicting appends and trailing deletes" {
  let first = Delta::new().retain_plain(3).insert_plain("aa")
  let second = Delta::new().retain_plain(3).insert_plain("bb")
  assert_eq(
    first.transform(second, true),
    Delta::new().retain_plain(5).insert_plain("bb"),
  )
  assert_eq(
    second.transform(first, false),
    Delta::new().retain_plain(3).insert_plain("aa"),
  )
  let later = Delta::new().retain_plain(2).delete(1)
  let earlier = Delta::new().delete(3)
  assert_eq(later.transform(earlier, false), Delta::new().delete(2))
  assert_eq(earlier.transform(later, false), Delta::new())
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

///|
test "raw constructor shares operations and slice preserves their boundaries" {
  let operations : Array[Op] = [
    InsertText("a", empty_attributes()),
    InsertText("b", empty_attributes()),
  ]
  let raw = Delta::from_ops_raw(operations)
  assert_eq(raw.slice_all().count(), 2)
  assert_eq(raw.slice_all().operations(), operations)
  operations.push(InsertText("c", empty_attributes()))
  assert_eq(raw.count(), 3)
}

///|
test "push deep clones embed payload and attributes" {
  let nested : Map[String, Json] = { "url": Json::string("old") }
  let embed : Map[String, Json] = { "image": Json::object(nested) }
  let attributes : Map[String, Json] = { "bold": Json::boolean(true) }
  let document = Delta::new().insert_embed(
    Json::object(embed),
    Json::object(attributes),
  )
  nested.set("url", Json::string("new"))
  embed.set("image", Json::string("replaced"))
  attributes.set("bold", Json::boolean(false))
  let expected = Delta::new().insert_embed(
    Json::object({ "image": Json::object({ "url": Json::string("old") }) }),
    Json::object({ "bold": Json::boolean(true) }),
  )
  assert_eq(document, expected)
}

///|
test "upstream diff replaces unrelated formatted words" {
  let old = Delta::new()
    .insert_text("Bad", Json::object({ "color": Json::string("red") }))
    .insert_text("cat", Json::object({ "color": Json::string("blue") }))
  let target = Delta::new()
    .insert_text("Good", Json::object({ "bold": Json::boolean(true) }))
    .insert_text("dog", Json::object({ "italic": Json::boolean(true) }))
  let expected = Delta::new()
    .insert_text("Good", Json::object({ "bold": Json::boolean(true) }))
    .insert_text("dog", Json::object({ "italic": Json::boolean(true) }))
    .delete(6)
  assert_eq(old.diff(target), expected)
}

///|
test "semantic diff absorbs a one-character island between edits" {
  let before = Delta::new().insert_plain("ab")
  let after = Delta::new().insert_plain("ba")
  let patch = before.diff(after)
  assert_eq(patch, Delta::new().insert_plain("ba").delete(2))
  assert_eq(before.apply(patch), after)
}

///|
test "semantic diff measures emoji equalities in UTF-16 code units" {
  let before = Delta::new().insert_plain("a😀b")
  let after = Delta::new().insert_plain("x😀y")
  let patch = before.diff(after)
  assert_eq(before.apply(patch), after)
  assert_eq(
    patch,
    Delta::new()
    .insert_plain("x")
    .delete(1)
    .retain_plain(2)
    .insert_plain("y")
    .delete(1),
  )
}

///|
test "upstream diff simple insert delete and formatting fixtures" {
  let a = Delta::new().insert_plain("A")
  assert_eq(
    a.diff(Delta::new().insert_plain("AB")),
    Delta::new().retain_plain(1).insert_plain("B"),
  )
  assert_eq(
    Delta::new().insert_plain("AB").diff(a),
    Delta::new().retain_plain(1).delete(1),
  )
  assert_eq(a.diff(a), Delta::new())
  let bold = Json::object({ "bold": Json::boolean(true) })
  assert_eq(
    a.diff(Delta::new().insert_text("A", bold)),
    Delta::new().retain(1, bold),
  )
}

///|
test "upstream diff deep object attributes and embed mutation" {
  let font = Json::object({
    "font": Json::object({
      "family": Json::string("Helvetica"),
      "size": Json::string("15px"),
    }),
  })
  let first = Delta::new().insert_text("A", font)
  let second = Delta::new().insert_text("A", clone_json(font))
  assert_eq(first.diff(second), Delta::new())
  let payload : Map[String, Json] = { "image": Json::string("old") }
  let before = Delta::new().insert_embed(
    Json::object(payload),
    empty_attributes(),
  )
  payload.set("image", Json::string("new"))
  let after = Delta::new().insert_embed(
    Json::object(payload),
    empty_attributes(),
  )
  let expected = Delta::new()
    .insert_embed(
      Json::object({ "image": Json::string("new") }),
      empty_attributes(),
    )
    .delete(1)
  assert_eq(before.diff(after), expected)
}

///|
test "upstream diff replaces multi-key embed with one-key embed" {
  let before = Delta::new().insert_embed(
    Json::object({
      "image": Json::string("url"),
      "alt": Json::string("overwrite"),
    }),
    empty_attributes(),
  )
  let after = Delta::new().insert_embed(
    Json::object({ "image": Json::string("url") }),
    empty_attributes(),
  )
  assert_eq(after.diff(after), Delta::new())
  assert_eq(
    before.diff(after),
    Delta::new()
    .insert_embed(
      Json::object({ "image": Json::string("url") }),
      empty_attributes(),
    )
    .delete(1),
  )
}

///|
test "upstream diff rejects non-document inputs" {
  let document = Delta::new().insert_plain("A")
  let change = Delta::new().retain_plain(1).insert_plain("B")
  let mut rejected_left = false
  let mut rejected_right = false
  ignore(document.diff(change)) catch {
    _ => rejected_left = true
  }
  ignore(change.diff(document)) catch {
    _ => rejected_right = true
  }
  assert_true(rejected_left && rejected_right)
}

///|
test "upstream diff returns empty for the exact same operation array" {
  let operations : Array[Op] = [Retain(1, empty_attributes())]
  let first = Delta::from_ops_raw(operations)
  let second = Delta::from_ops_raw(operations)
  assert_eq(first.diff(second), Delta::new())
}

///|
test "upstream iterator rest does not advance its cursor" {
  let bold = Json::object({ "bold": Json::boolean(true) })
  let delta = Delta::new()
    .insert_text("Hello", bold)
    .retain_plain(3)
    .insert_embed(
      Json::object({ "embed": Json::number(2) }),
      Json::object({ "src": Json::string("url") }),
    )
    .delete(4)
  let iterator = delta.iterator()
  assert_eq(iterator.next(2), InsertText("He", bold))
  let remaining = iterator.rest()
  assert_eq(remaining.length(), 4)
  assert_eq(remaining[0], InsertText("llo", bold))
  assert_eq(iterator.peek_length(), 3)
  assert_eq(iterator.next(10), InsertText("llo", bold))
  assert_eq(iterator.rest().length(), 3)
  assert_eq(iterator.next(3), Retain(3, empty_attributes()))
  assert_eq(iterator.rest().length(), 2)
}

///|
test "upstream transform position fixtures" {
  assert_eq(Delta::new().insert_plain("A").transform_position(2, false), 3)
  assert_eq(
    Delta::new().retain_plain(2).insert_plain("A").transform_position(1, false),
    1,
  )
  let at = Delta::new().retain_plain(2).insert_plain("A")
  assert_eq(at.transform_position(2, true), 2)
  assert_eq(at.transform_position(2, false), 3)
  assert_eq(Delta::new().delete(2).transform_position(4, false), 2)
  assert_eq(
    Delta::new().retain_plain(4).delete(2).transform_position(2, false),
    2,
  )
  assert_eq(
    Delta::new().retain_plain(1).delete(4).transform_position(2, false),
    1,
  )
  assert_eq(
    Delta::new()
    .retain_plain(2)
    .insert_plain("A")
    .delete(2)
    .transform_position(4, false),
    3,
  )
  assert_eq(
    Delta::new()
    .retain_plain(2)
    .insert_plain("A")
    .delete(4)
    .transform_position(4, false),
    3,
  )
  assert_eq(
    Delta::new()
    .delete(1)
    .retain_plain(1)
    .delete(4)
    .transform_position(4, false),
    1,
  )
}

///|
test "upstream attribute compose cases" {
  let base = Json::object({
    "bold": Json::boolean(true),
    "color": Json::string("red"),
  })
  assert_eq(
    attributes_compose(
      base,
      Json::object({ "italic": Json::boolean(true) }),
      false,
    ),
    Json::object({
      "bold": Json::boolean(true),
      "italic": Json::boolean(true),
      "color": Json::string("red"),
    }),
  )
  assert_eq(
    attributes_compose(
      base,
      Json::object({
        "bold": Json::boolean(false),
        "color": Json::string("blue"),
      }),
      false,
    ),
    Json::object({ "bold": Json::boolean(false), "color": Json::string("blue") }),
  )
  assert_eq(
    attributes_compose(base, Json::object({ "bold": Json::null() }), false),
    Json::object({ "color": Json::string("red") }),
  )
  assert_eq(
    attributes_compose(
      base,
      Json::object({ "bold": Json::null(), "color": Json::null() }),
      false,
    ),
    empty_attributes(),
  )
  assert_eq(
    attributes_compose(base, Json::object({ "italic": Json::null() }), false),
    base,
  )
}

///|
test "upstream attribute diff cases" {
  let base = Json::object({
    "bold": Json::boolean(true),
    "color": Json::string("red"),
  })
  assert_eq(attributes_diff(base, base), empty_attributes())
  assert_eq(
    attributes_diff(
      base,
      Json::object({
        "bold": Json::boolean(true),
        "italic": Json::boolean(true),
        "color": Json::string("red"),
      }),
    ),
    Json::object({ "italic": Json::boolean(true) }),
  )
  assert_eq(
    attributes_diff(base, Json::object({ "bold": Json::boolean(true) })),
    Json::object({ "color": Json::null() }),
  )
  assert_eq(
    attributes_diff(
      base,
      Json::object({
        "bold": Json::boolean(true),
        "color": Json::string("blue"),
      }),
    ),
    Json::object({ "color": Json::string("blue") }),
  )
}

///|
test "upstream attribute invert combined case" {
  let change = Json::object({
    "bold": Json::boolean(true),
    "italic": Json::null(),
    "color": Json::string("red"),
    "size": Json::string("12px"),
  })
  let base = Json::object({
    "font": Json::string("serif"),
    "italic": Json::boolean(true),
    "color": Json::string("blue"),
    "size": Json::string("12px"),
  })
  assert_eq(
    attributes_invert(change, base),
    Json::object({
      "bold": Json::null(),
      "italic": Json::boolean(true),
      "color": Json::string("blue"),
    }),
  )
}

///|
test "upstream attribute transform priority cases" {
  let left = Json::object({
    "bold": Json::boolean(true),
    "color": Json::string("red"),
    "font": Json::null(),
  })
  let right = Json::object({
    "color": Json::string("blue"),
    "font": Json::string("serif"),
    "italic": Json::boolean(true),
  })
  assert_eq(
    attributes_transform(left, right, true),
    Json::object({ "italic": Json::boolean(true) }),
  )
  assert_eq(attributes_transform(left, right, false), right)
}

///|
test "compatible JSON constructor preserves raw operation layout" {
  let source = "{\"ops\":[{\"insert\":\"a\"},{\"insert\":\"b\"},{\"insert\":\"\"},{\"insert\":{\"image\":\"url\",\"alt\":\"caption\"}}]}"
  let raw = Delta::parse_json_compatible(source)
  assert_eq(raw.count(), 4)
  assert_eq(raw.operations()[0], InsertText("a", empty_attributes()))
  assert_eq(raw.operations()[1], InsertText("b", empty_attributes()))
  assert_eq(raw.operations()[2], InsertText("", empty_attributes()))
  assert_eq(
    raw.operations()[3],
    InsertEmbed(
      Json::object({
        "image": Json::string("url"),
        "alt": Json::string("caption"),
      }),
      empty_attributes(),
    ),
  )
  let mut strict_rejected = false
  ignore(Delta::parse_json(source)) catch {
    _ => strict_rejected = true
  }
  assert_true(strict_rejected)
}

///|
test "compatible constructor treats missing or invalid ops as empty" {
  assert_eq(Delta::parse_json_compatible("{}"), Delta::new())
  assert_eq(Delta::parse_json_compatible("{\"ops\":null}"), Delta::new())
  assert_eq(Delta::parse_json_compatible("null"), Delta::new())
}

///|
test "upstream builders omit null and empty attributes" {
  assert_eq(
    Delta::new().insert_text("a", Json::null()),
    Delta::new().insert_plain("a"),
  )
  assert_eq(
    Delta::new().insert_text("a", empty_attributes()),
    Delta::new().insert_plain("a"),
  )
  assert_eq(
    Delta::new().retain(2, Json::null()).delete(1),
    Delta::new().retain_plain(2).delete(1),
  )
  assert_eq(
    Delta::new().insert_embed(
      Json::object({ "embed": Json::number(1) }),
      Json::null(),
    ),
    Delta::new().insert_embed(
      Json::object({ "embed": Json::number(1) }),
      empty_attributes(),
    ),
  )
}

///|
test "global embed registration supports default Delta methods" {
  Delta::register_embed(
    "global_counter",
    EmbedHandler::new(
      (base, update, _) => {
        Json::number(counter_number(base) + counter_number(update))
      },
      (update, _) => Json::number(-counter_number(update)),
      (_, other, _) => other,
    ),
  )
  let base = Delta::new().insert_embed(
    Json::object({ "global_counter": Json::number(5) }),
    empty_attributes(),
  )
  let update = Delta::new().retain_embed(
    Json::object({ "global_counter": Json::number(2) }),
    empty_attributes(),
  )
  let changed = base.apply(update)
  assert_eq(
    changed,
    Delta::new().insert_embed(
      Json::object({ "global_counter": Json::number(7) }),
      empty_attributes(),
    ),
  )
  assert_eq(changed.apply(update.invert(base)), base)
  Delta::unregister_embed("global_counter")
  let mut rejected = false
  ignore(base.apply(update)) catch {
    _ => rejected = true
  }
  assert_true(rejected)
}

///|
fn nested_delta_ops(document : Delta) -> Json {
  match document.to_json() {
    Object(fields) =>
      match fields.get("ops") {
        Some(value) => value
        None => Json::array([])
      }
    _ => Json::array([])
  }
}

///|
test "upstream nested Delta embed handler composes inverts and transforms" {
  let handlers = EmbedHandlers::new()
  handlers.register(
    "delta",
    EmbedHandler::new(
      (base, change, _) => {
        nested_delta_ops(
          Delta::from_json_compatible(base).compose(
            Delta::from_json_compatible(change),
          ),
        )
      },
      (change, base) => {
        nested_delta_ops(
          Delta::from_json_compatible(change).invert(
            Delta::from_json_compatible(base),
          ),
        )
      },
      (first, second, priority) => {
        nested_delta_ops(
          Delta::from_json_compatible(first).transform(
            Delta::from_json_compatible(second),
            priority,
          ),
        )
      },
    ),
  )
  let base = Delta::new().insert_embed(
    Json::object({
      "delta": Json::array([Json::object({ "insert": Json::string("a") })]),
    }),
    empty_attributes(),
  )
  let change = Delta::new().retain_embed(
    Json::object({
      "delta": Json::array([Json::object({ "insert": Json::string("b") })]),
    }),
    empty_attributes(),
  )
  let expected = Delta::new().insert_embed(
    Json::object({
      "delta": Json::array([Json::object({ "insert": Json::string("ba") })]),
    }),
    empty_attributes(),
  )
  assert_eq(base.compose_with_handlers(change, handlers), expected)
  let inverse = change.invert_with_handlers(base, handlers)
  assert_eq(expected.compose_with_handlers(inverse, handlers), base)
  let transformed = change.transform_with_handlers(change, true, handlers)
  assert_eq(transformed.count(), 1)
}

///|
test "upstream push merging and ordering fixtures" {
  let bold = Json::object({ "bold": Json::boolean(true) })
  assert_eq(
    Delta::new().insert_plain("a").delete(1).insert_plain("b"),
    Delta::new().insert_plain("ab").delete(1),
  )
  assert_eq(Delta::new().delete(2).delete(3), Delta::new().delete(5))
  assert_eq(
    Delta::new().insert_text("a", bold).insert_text("b", bold),
    Delta::new().insert_text("ab", bold),
  )
  assert_eq(
    Delta::new().retain(1, bold).retain(3, bold),
    Delta::new().retain(4, bold),
  )
  assert_eq(Delta::new().insert_text("a", bold).insert_plain("b").count(), 2)
  assert_eq(Delta::new().retain(1, bold).retain_plain(3).count(), 2)
  let embed = Json::object({ "embed": Json::number(1) })
  assert_eq(
    Delta::new().insert_embed(embed, bold).insert_embed(embed, bold).count(),
    2,
  )
  assert_eq(
    Delta::new().insert_plain("").delete(0).retain_plain(0),
    Delta::new(),
  )
}

///|
test "direct push preserves zero length operations while builders skip them" {
  let raw = Delta::new()
  ignore(raw.push(Delete(0)))
  assert_eq(raw.operations(), [Delete(0)])
  let builders = Delta::new()
  ignore(builders.delete(0).retain_plain(0).insert_plain(""))
  assert_eq(builders.count(), 0)
}

///|
test "iterator next with zero length consumes the full operation" {
  let iterator = Delta::new().insert_plain("abc").iterator()
  assert_eq(iterator.next(0), InsertText("abc", empty_attributes()))
  assert_true(!iterator.has_next())
}
