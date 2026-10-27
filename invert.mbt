///|
/// Create a change that reverses this change against the supplied full base
/// document. The base is required because deleted content is absent from a
/// Delta change.
pub fn Delta::invert(self : Delta, base : Delta) -> Delta raise DeltaError {
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
      RetainEmbed(_, _) =>
        raise Invalid("embed retain inversion needs a registered embed handler")
    }
  }
  result.chop()
}
