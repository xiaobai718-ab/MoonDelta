///|
fn check(label : String, success : Bool) -> Unit {
  if !success {
    abort(label)
  }
}

///|
fn main raise {
  let base = @lib.Delta::new().insert_plain("abcd")
  check("plain text", base.plain_text() == Some("abcd"))
  check("document", base.is_document())
  check("length", base.length() == 4)
  check("slice", base.slice(1, 3).plain_text() == Some("bc"))
  let parsed = @lib.Delta::parse_json("{\"ops\":[{\"insert\":\"abc\"}]}")
  check("JSON parse", parsed.plain_text() == Some("abc"))
  check("JSON round trip", @lib.Delta::from_json(parsed.to_json()) == parsed)
  let insert = @lib.Delta::new().retain_plain(2).insert_plain("X")
  check("apply insert", base.apply(insert).plain_text() == Some("abXcd"))
  let deletion = @lib.Delta::new().retain_plain(1).delete(2)
  check("apply deletion", base.apply(deletion).plain_text() == Some("ad"))
  let replace = @lib.Delta::new().retain_plain(1).delete(2).insert_plain("XY")
  check("invert", base.apply(replace).apply(replace.invert(base)) == base)
  let attrs = Json::object({ "bold": Json::boolean(true) })
  let formatted = @lib.Delta::new().insert_text("a", attrs)
  check(
    "attribute JSON",
    @lib.Delta::from_json(formatted.to_json()) == formatted,
  )
  check(
    "attribute diff",
    @lib.attributes_compose(
      @lib.empty_attributes(),
      @lib.attributes_diff(@lib.empty_attributes(), attrs),
      false,
    ) ==
    attrs,
  )
  let a = @lib.Delta::new().retain_plain(1).insert_plain("X")
  let b = @lib.Delta::new().retain_plain(1).insert_plain("Y")
  check(
    "OT converge",
    base.apply(a).apply(a.transform(b, true)) ==
    base.apply(b).apply(b.transform(a, false)),
  )
  check("position insert", a.transform_position(1, false) == 2)
  check("position priority", a.transform_position(1, true) == 1)
  check("position delete", deletion.transform_position(2, false) == 1)
  let texts = [
    "", "a", "b", "ab", "ba", "abc", "ac", "cab", "cat", "cut", "hello",
  ]
  let mut cases = 0
  for old in texts {
    for next in texts {
      let before = @lib.Delta::new().insert_plain(old)
      let after = @lib.Delta::new().insert_plain(next)
      let patch = before.diff(after)
      check("diff " + old + " => " + next, before.apply(patch) == after)
      cases += 1
    }
  }
  let embed = Json::object({ "image": Json::string("picture") })
  let with_embed = @lib.Delta::new()
    .insert_plain("a")
    .insert_embed(embed, @lib.empty_attributes())
    .insert_plain("b")
  let without_embed = @lib.Delta::new().insert_plain("ab")
  check(
    "embed insertion",
    without_embed.apply(without_embed.diff(with_embed)) == with_embed,
  )
  check(
    "embed deletion",
    with_embed.apply(with_embed.diff(without_embed)) == without_embed,
  )
  let emoji_before = @lib.Delta::new().insert_plain("a😀b")
  let emoji_after = @lib.Delta::new().insert_plain("a🚀b")
  check("UTF-16 length", emoji_before.length() == 4)
  let emoji_patch = emoji_before.diff(emoji_after)
  check("emoji diff", emoji_before.apply(emoji_patch) == emoji_after)
  let long_prefix = "A".repeat(2000)
  let long_before = @lib.Delta::new().insert_plain(long_prefix + "old")
  let long_after = @lib.Delta::new().insert_plain(long_prefix + "new")
  check(
    "large shared prefix diff",
    long_before.apply(long_before.diff(long_after)) == long_after,
  )
  let heading = Json::object({ "header": Json::number(2) })
  let line_doc = @lib.Delta::new()
    .insert_plain("Title")
    .insert_text("\n", heading)
    .insert_plain("body\n")
  let lines = line_doc.lines()
  check("line count", lines.length() == 2)
  check("line content", lines[0].content.plain_text() == Some("Title"))
  check("block formatting", lines[0].attributes == heading)
  let history = @lib.History::new(base, 2)
  history.apply(replace)
  check("history edit", history.document().plain_text() == Some("aXYd"))
  check("history undo", history.undo() && history.document() == base)
  check(
    "history redo",
    history.redo() && history.document().plain_text() == Some("aXYd"),
  )
  check("history revision", history.revision() == 3)
  let mut ot_cases = 0
  for text in ["", "a", "ab", "abc", "abcd"] {
    let document = @lib.Delta::new().insert_plain(text)
    let changes : Array[@lib.Delta] = []
    for position in 0..<=text.length() {
      changes.push(@lib.Delta::new().retain_plain(position).insert_plain("X"))
      changes.push(@lib.Delta::new().retain_plain(position).insert_plain("Y"))
      if position < text.length() {
        changes.push(@lib.Delta::new().retain_plain(position).delete(1))
      }
    }
    for first in changes {
      for second in changes {
        let left = document.apply(first).apply(first.transform(second, true))
        let right = document.apply(second).apply(second.transform(first, false))
        check("OT matrix on " + text, left == right)
        ot_cases += 1
      }
    }
  }
  println(
    "MoonDelta selftest passed: " +
    cases.to_string() +
    " diff pairs, " +
    ot_cases.to_string() +
    " OT pairs, plus core checks",
  )
}
