///|
/// Create a change that reverses this change against the supplied full base
/// document. The base is required because deleted content is absent from a
/// Delta change.
pub fn Delta::invert(self : Delta, base : Delta) -> Delta raise DeltaError {
  self.invert_with_handlers(base, EmbedHandlers::new())
}

///|
/// Invert a change with registered algorithms for embed payload updates.
pub fn Delta::invert_with_handlers(
  self : Delta,
  base : Delta,
  handlers : EmbedHandlers,
) -> Delta raise DeltaError {
  if !base.is_document() {
    raise Invalid("invert requires an insert-only base document")
  }
  let result = Delta::new()
  let mut offset = 0
  for op in self.ops {
    match op {
      InsertText(_, _) | InsertEmbed(_, _) => ignore(result.delete(op.length()))
      Delete(length) => {
        if offset + length > base.length() {
          raise Invalid("delete exceeds the base document")
        }
        for original in base.slice(offset, offset + length).ops {
          ignore(result.push(original))
        }
        offset += length
      }
      Retain(length, attrs) => {
        if offset + length > base.length() {
          raise Invalid("retain exceeds the base document")
        }
        let segment = base.slice(offset, offset + length)
        for original in segment.ops {
          let inverted = attributes_invert(attrs, original.attributes())
          ignore(result.retain(original.length(), inverted))
        }
        offset += length
      }
      RetainEmbed(update, attrs) => {
        if offset + 1 > base.length() {
          raise Invalid("embed retain exceeds the base document")
        }
        let original = base.slice(offset, offset + 1)
        let original_op = original.ops[0]
        match original_op {
          InsertEmbed(original_embed, original_attrs) => {
            let (kind, update_data, original_data) = embed_parts(update, original_embed)
            let handler = handlers.require(kind)
            let inverse_data = (handler.invert_value)(update_data, original_data)
            let inverse_attrs = attributes_invert(attrs, original_attrs)
            ignore(result.retain_embed(wrap_embed(kind, inverse_data), inverse_attrs))
          }
          _ => raise Invalid("embed retain requires an embed in the base document")
        }
        offset += 1
      }
    }
  }
  result.chop()
}
