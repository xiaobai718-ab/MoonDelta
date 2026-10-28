///|
/// Apply `next` after this Delta. A document composed with a change yields a
/// new document; composing two changes yields one equivalent change.
pub fn Delta::compose(self : Delta, next : Delta) -> Delta raise DeltaError {
  self.compose_with_handlers(next, default_embed_handlers)
}

///|
/// Compose using registered, type-specific embed payload algorithms.
pub fn Delta::compose_with_handlers(
  self : Delta,
  next : Delta,
  handlers : EmbedHandlers,
) -> Delta raise DeltaError {
  let left = OpIterator::new(self.ops)
  let right = OpIterator::new(next.ops)
  let result = Delta::new()
  match right.peek() {
    Some(Retain(length, attrs)) if no_attributes(attrs) => {
      let mut remaining = length
      while left.peek_kind() == "insert" && left.peek_length() <= remaining {
        let amount = left.peek_length()
        remaining -= amount
        result.ops.push(left.next(amount))
      }
      if length > remaining {
        ignore(right.next(length - remaining))
      }
    }
    _ => ()
  }
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
          a is Retain(_, _),
        )
        let composed : Op = match a {
          InsertText(text, _) => InsertText(text, attrs)
          InsertEmbed(embed, _) => InsertEmbed(embed, attrs)
          Retain(_, _) => Retain(amount, attrs)
          RetainEmbed(embed, _) => RetainEmbed(embed, attrs)
          Delete(_) => continue
        }
        ignore(result.push(composed))
        if !right.has_next() && result.ops[result.ops.length() - 1] == composed {
          return result.concat(Delta::from_ops_raw(left.rest())).chop()
        }
      }
      RetainEmbed(next_embed, next_attrs) => {
        let attrs = attributes_compose(
          a.attributes(),
          next_attrs,
          a is Retain(_, _),
        )
        let composed : Op = match a {
          Retain(_, _) => RetainEmbed(next_embed, attrs)
          InsertEmbed(original, _) => {
            let (kind, old_data, change_data) = embed_parts(
              original, next_embed,
            )
            let handler = handlers.require(kind)
            let data = (handler.compose_value)(old_data, change_data, false)
            InsertEmbed(wrap_embed(kind, data), attrs)
          }
          RetainEmbed(original, _) => {
            let (kind, old_data, change_data) = embed_parts(
              original, next_embed,
            )
            let handler = handlers.require(kind)
            let data = (handler.compose_value)(old_data, change_data, true)
            RetainEmbed(wrap_embed(kind, data), attrs)
          }
          InsertText(_, _) =>
            raise Invalid("cannot retain a text insert with an embed update")
          Delete(_) => continue
        }
        ignore(result.push(composed))
        if !right.has_next() && result.ops[result.ops.length() - 1] == composed {
          return result.concat(Delta::from_ops_raw(left.rest())).chop()
        }
      }
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
  self.apply_with_handlers(change, default_embed_handlers)
}

///|
pub fn Delta::apply_with_handlers(
  self : Delta,
  change : Delta,
  handlers : EmbedHandlers,
) -> Delta raise DeltaError {
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
  let result = self.compose_with_handlers(change, handlers)
  if !result.is_document() {
    raise Invalid("change did not produce a document")
  }
  result
}
