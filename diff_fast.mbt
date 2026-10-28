///|
/// Match Quill Delta's fast-diff 1.3.0 text operation mapping. Embeds are
/// represented by NUL placeholders for text alignment and then compared as
/// full JSON payloads in equal regions.
fn Delta::diff_fast(self : Delta, target : Delta) -> Delta {
  let old_text = self.diff_placeholder_text()
  let new_text = target.diff_placeholder_text()
  let edits = fast_diff_text(old_text, new_text)
  let old_iter = OpIterator::new(self.ops)
  let new_iter = OpIterator::new(target.ops)
  let result = Delta::new()
  for edit in edits {
    let mut remaining = edit.text.length()
    while remaining > 0 {
      if edit.kind == 1 {
        let available = new_iter.peek_length()
        let amount = if available < remaining { available } else { remaining }
        ignore(result.push(new_iter.next(amount)))
        remaining -= amount
      } else if edit.kind == -1 {
        let available = old_iter.peek_length()
        let amount = if available < remaining { available } else { remaining }
        ignore(old_iter.next(amount))
        ignore(result.delete(amount))
        remaining -= amount
      } else {
        let old_available = old_iter.peek_length()
        let new_available = new_iter.peek_length()
        let mut amount = if old_available < new_available {
          old_available
        } else {
          new_available
        }
        if remaining < amount {
          amount = remaining
        }
        let old_op = old_iter.next(amount)
        let new_op = new_iter.next(amount)
        if same_insert_content(old_op, new_op) {
          ignore(
            result.retain(
              amount,
              attributes_diff(old_op.attributes(), new_op.attributes()),
            ),
          )
        } else {
          ignore(result.push(new_op))
          ignore(result.delete(amount))
        }
        remaining -= amount
      }
    }
  }
  result.chop()
}

///|
fn Delta::diff_placeholder_text(self : Delta) -> String {
  let buffer = StringBuilder()
  for op in self.ops {
    match op {
      InsertText(text, _) => buffer.write_string(text)
      InsertEmbed(_, _) => buffer.write_char('\u{0000}')
      _ => ()
    }
  }
  buffer.to_string()
}

///|
fn same_insert_content(left : Op, right : Op) -> Bool {
  match (left, right) {
    (InsertText(a, _), InsertText(b, _)) => a == b
    (InsertEmbed(a, _), InsertEmbed(b, _)) => a == b
    _ => false
  }
}
