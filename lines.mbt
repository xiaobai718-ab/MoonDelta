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

///|
/// Visit lines in an insert-only document. The callback receives the line
/// without its delimiter, the attributes of the delimiter, and a zero-based
/// line number. Returning false stops traversal. Non-document deltas visit no lines. The final unterminated line
/// is visited only when it contains content.
pub fn Delta::each_line(
  self : Delta,
  visit : (Delta, Json, Int32) -> Bool,
  newline~ : String = "\n",
) -> Unit raise DeltaError {
  if !self.is_document() {
    return
  }
  if newline.length() == 0 {
    raise Invalid("newline delimiter cannot be empty")
  }
  let mut position = 0
  let mut line_start = 0
  let mut line_index = 0
  for op in self.ops {
    match op {
      InsertText(text, attributes) => {
        let mut i = 0
        while i + newline.length() <= text.length() {
          let mut matches = true
          for j in 0..<newline.length() {
            if text.at(i + j) != newline.at(j) {
              matches = false
              break
            }
          }
          if matches {
            let line = self.slice(line_start, position + i)
            if !visit(line, attributes, line_index) {
              return
            }
            line_index += 1
            i += newline.length()
            line_start = position + i
          } else {
            i += 1
          }
        }
        position += text.length()
      }
      InsertEmbed(_, _) => position += 1
      _ => ()
    }
  }
  if line_start < position {
    ignore(visit(self.slice(line_start, position), empty_attributes(), line_index))
  }
}
