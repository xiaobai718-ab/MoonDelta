///|
/// A Quill Delta operation. Text positions are UTF-16 code-unit offsets.
/// Attributes are JSON objects; an empty object means no formatting change.
pub(all) enum Op {
  InsertText(String, Json)
  InsertEmbed(Json, Json)
  Retain(Int32, Json)
  RetainEmbed(Json, Json)
  Delete(Int32)
} derive(Eq, Debug)

///|
/// A sequence of rich-text editing operations. Builders normalize adjacent
/// operations, put inserts before deletes at the same position, and discard
/// operations with zero length.
pub(all) struct Delta {
  mut ops : Array[Op]
} derive(Eq, Debug)

///|
/// Validation errors include the path in the source JSON whenever possible.
pub suberror DeltaError {
  Invalid(String)
} derive(Debug)

///|
pub fn empty_attributes() -> Json {
  Json::object({})
}

///|
fn attributes_empty(attributes : Json) -> Bool {
  match attributes {
    Object(map) => map.is_empty()
    _ => false
  }
}

///|
fn no_attributes(attributes : Json) -> Bool {
  attributes_empty(attributes)
}

///|
pub fn Op::length(self : Op) -> Int32 {
  match self {
    InsertText(text, _) => text.length()
    InsertEmbed(_, _) | RetainEmbed(_, _) => 1
    Retain(n, _) | Delete(n) => n
  }
}

///|
pub fn Op::attributes(self : Op) -> Json {
  match self {
    InsertText(_, attrs)
    | InsertEmbed(_, attrs)
    | Retain(_, attrs)
    | RetainEmbed(_, attrs) => attrs
    Delete(_) => empty_attributes()
  }
}

///|
pub fn Op::kind(self : Op) -> String {
  match self {
    InsertText(_, _) | InsertEmbed(_, _) => "insert"
    Retain(_, _) | RetainEmbed(_, _) => "retain"
    Delete(_) => "delete"
  }
}

///|
pub fn Delta::new() -> Delta {
  { ops: [], }
}

///|
pub fn Delta::from_ops(ops : Array[Op]) -> Delta {
  let delta = Delta::new()
  for op in ops {
    ignore(delta.push(op))
  }
  delta
}

///|
pub fn Delta::operations(self : Delta) -> Array[Op] {
  let copy : Array[Op] = []
  for op in self.ops {
    copy.push(op)
  }
  copy
}

///|
pub fn Delta::count(self : Delta) -> Int32 {
  self.ops.length()
}

///|
pub fn Delta::is_empty(self : Delta) -> Bool {
  self.ops.is_empty()
}

///|
pub fn Delta::length(self : Delta) -> Int32 {
  let mut total = 0
  for op in self.ops {
    total += op.length()
  }
  total
}

///|
pub fn Delta::change_length(self : Delta) -> Int32 {
  let mut total = 0
  for op in self.ops {
    match op {
      InsertText(_, _) | InsertEmbed(_, _) => total += op.length()
      Delete(n) => total -= n
      Retain(_, _) | RetainEmbed(_, _) => ()
    }
  }
  total
}

///|
pub fn Delta::is_document(self : Delta) -> Bool {
  for op in self.ops {
    match op {
      InsertText(_, _) | InsertEmbed(_, _) => ()
      _ => return false
    }
  }
  true
}

///|
pub fn Delta::plain_text(self : Delta) -> String? {
  let builder = StringBuilder()
  for op in self.ops {
    match op {
      InsertText(text, _) => builder.write_string(text)
      _ => return None
    }
  }
  Some(builder.to_string())
}

///|
pub extend Op with Eq::{equal, not_equal}

///|
pub extend Op with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Delta with Eq::{equal, not_equal}

///|
pub extend Delta with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend DeltaError with @moonbitlang/core/debug.Debug::{to_repr}
