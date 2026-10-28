///|
/// Transform `other` against this Delta. With `priority = true`, this Delta
/// wins when both changes insert at the same position or format the same key.
pub fn Delta::transform(
  self : Delta,
  other : Delta,
  priority : Bool,
) -> Delta raise DeltaError {
  self.transform_with_handlers(other, priority, default_embed_handlers)
}

///|
/// Transform concurrent changes using registered embed payload algorithms.
pub fn Delta::transform_with_handlers(
  self : Delta,
  other : Delta,
  priority : Bool,
  handlers : EmbedHandlers,
) -> Delta raise DeltaError {
  let left = OpIterator::new(self.ops)
  let right = OpIterator::new(other.ops)
  let result = Delta::new()
  while left.has_next() || right.has_next() {
    if left.peek_kind() == "insert" &&
      (priority || right.peek_kind() != "insert") {
      ignore(result.retain_plain(left.next(left.peek_length()).length()))
      continue
    }
    if right.peek_kind() == "insert" {
      ignore(result.push(right.next(right.peek_length())))
      continue
    }
    let a_length = left.peek_length()
    let b_length = right.peek_length()
    let amount = if a_length < b_length { a_length } else { b_length }
    let a = left.next(amount)
    let b = right.next(amount)
    if a.kind() == "delete" {
      continue
    }
    match b {
      Delete(_) => ignore(result.delete(amount))
      RetainEmbed(embed, attrs) => {
        let mut transformed_embed = embed
        match a {
          RetainEmbed(own_embed, _) => {
            let parts = embed_parts(own_embed, embed) catch {
              _ => ("", Json::null(), Json::null())
            }
            let (kind, own_data, other_data) = parts
            if kind != "" {
              let handler = handlers.require(kind)
              transformed_embed = wrap_embed(
                kind,
                (handler.transform_value)(own_data, other_data, priority),
              )
            }
          }
          _ => ()
        }
        let transformed = attributes_transform(a.attributes(), attrs, priority)
        ignore(result.retain_embed(transformed_embed, transformed))
      }
      Retain(_, attrs) => {
        let transformed = attributes_transform(a.attributes(), attrs, priority)
        ignore(result.retain(amount, transformed))
      }
      _ => ()
    }
  }
  result.chop()
}

///|
/// Rebase a UTF-16 cursor position through this change.
pub fn Delta::transform_position(
  self : Delta,
  position : Int32,
  priority : Bool,
) -> Int32 {
  let mut index = position
  let mut offset = 0
  for op in self.ops {
    if offset > index {
      break
    }
    match op {
      InsertText(_, _) | InsertEmbed(_, _) => {
        if offset < index || (offset == index && !priority) {
          index += op.length()
        }
        offset += op.length()
      }
      Delete(length) =>
        if offset < index {
          let removable = index - offset
          index -= if removable < length { removable } else { length }
        }
      Retain(_, _) | RetainEmbed(_, _) => offset += op.length()
    }
  }
  index
}
