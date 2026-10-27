///|
/// A rich-text line. `content` excludes the newline; formatting attached to
/// the newline is returned separately as `attributes` (Quill block formats).
pub(all) struct DeltaLine {
  content : Delta
  attributes : Json
  start : Int32
  terminated : Bool
} derive(Eq, Debug)

///|
/// Split an insert-only document into rich-text lines. The final unterminated
/// line is included when it has content. An empty document has no lines.
pub fn Delta::lines(self : Delta) -> Array[DeltaLine] raise DeltaError {
  if !self.is_document() {
    raise Invalid("lines requires an insert-only document")
  }
  let output : Array[DeltaLine] = []
  let mut position = 0
  let mut line_start = 0
  for op in self.ops {
    match op {
      InsertText(text, attrs) => {
        for i in 0..<text.length() {
          if text.at(i).to_int() == 10 {
            output.push({
              content: self.slice(line_start, position + i),
              attributes: attrs,
              start: line_start,
              terminated: true,
            })
            line_start = position + i + 1
          }
        }
        position += text.length()
      }
      InsertEmbed(_, _) => position += 1
      _ => ()
    }
  }
  if line_start < position {
    output.push({
      content: self.slice(line_start, position),
      attributes: empty_attributes(),
      start: line_start,
      terminated: false,
    })
  }
  output
}

///|
pub fn Delta::line_count(self : Delta) -> Int32 raise DeltaError {
  self.lines().length()
}
