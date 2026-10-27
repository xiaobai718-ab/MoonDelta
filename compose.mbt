///|
/// Apply `next` after this Delta. A document composed with a change yields a
/// new document; composing two changes yields one equivalent change.
pub fn Delta::compose(self : Delta, next : Delta) -> Delta raise DeltaError {
  if self.has_embed_retain() || next.has_embed_retain() {
    raise Invalid("embed retain updates require a type-specific handler")
  }
  let left = OpIterator::new(self.ops)
  let right = OpIterator::new(next.ops)
  let result = Delta::new()
  while left.has_next() || right.has_next() {
    if right.peek_kind() == "insert" {
      ignore(result.push(right.next(right.peek_length())))
      continue
    }
    if left.peek_kind() == "delete" {
      ignore(result.push(left.next(left.peek_length())))
      continue
    }
    let left_length = left.peek_length()
    let right_length = right.peek_length()
    let amount = if left_length < right_length {
      left_length
    } else {
      right_length
    }
    let a = left.next(amount)
    let b = right.next(amount)
    match b {
      Retain(_, b_attrs) => {
        let attrs = attributes_compose(
          a.attributes(),
          b_attrs,
          a.kind() == "retain",
        )
        match a {
          InsertText(text, _) => ignore(result.push(InsertText(text, attrs)))
          InsertEmbed(embed, _) =>
            ignore(result.push(InsertEmbed(embed, attrs)))
          Retain(length, _) => ignore(result.push(Retain(length, attrs)))
          RetainEmbed(embed, _) =>
            ignore(result.push(RetainEmbed(embed, attrs)))
          Delete(_) => ()
        }
      }
      RetainEmbed(_, _) => ()
      Delete(_) =>
        match a {
          Retain(_, _) | RetainEmbed(_, _) =>
            ignore(result.push(Delete(amount)))
          _ => ()
        }
      _ => ()
    }
  }
  result.chop()
}

///|
/// Apply a change to a full insert-only document.
pub fn Delta::apply(self : Delta, change : Delta) -> Delta raise DeltaError {
  if !self.is_document() {
    raise Invalid("apply requires an insert-only document")
  }
  let mut consumed = 0
  for op in change.ops {
    match op {
      Retain(n, _) | Delete(n) => consumed += n
      RetainEmbed(_, _) => consumed += 1
      _ => ()
    }
  }
  if consumed > self.length() {
    raise Invalid("change consumes beyond the document")
  }
  let result = self.compose(change)
  if !result.is_document() {
    raise Invalid("change did not produce a document")
  }
  result
}
