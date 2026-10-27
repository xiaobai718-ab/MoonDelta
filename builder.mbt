///|
/// Append an operation while maintaining Quill's canonical operation order.
pub fn Delta::push(self : Delta, op : Op) -> Delta {
  let length = op.length()
  if length <= 0 {
    return self
  }
  let count = self.ops.length()
  if count == 0 {
    self.ops.push(op)
    return self
  }
  let last = self.ops[count - 1]
  match (last, op) {
    (Delete(a), Delete(b)) => {
      self.ops[count - 1] = Delete(a + b)
      return self
    }
    (Delete(n), InsertText(_, _) | InsertEmbed(_, _)) => {
      ignore(self.ops.pop())
      ignore(self.push(op))
      ignore(self.push(Delete(n)))
      return self
    }
    (InsertText(a, attrs_a), InsertText(b, attrs_b)) if attrs_a == attrs_b => {
      self.ops[count - 1] = InsertText(a + b, attrs_a)
      return self
    }
    (Retain(a, attrs_a), Retain(b, attrs_b)) if attrs_a == attrs_b => {
      self.ops[count - 1] = Retain(a + b, attrs_a)
      return self
    }
    _ => ()
  }
  self.ops.push(op)
  self
}

///|
pub fn Delta::insert_text(
  self : Delta,
  text : String,
  attributes : Json,
) -> Delta {
  self.push(InsertText(text, attributes))
}

///|
pub fn Delta::insert_plain(self : Delta, text : String) -> Delta {
  self.push(InsertText(text, empty_attributes()))
}

///|
pub fn Delta::insert_embed(
  self : Delta,
  embed : Json,
  attributes : Json,
) -> Delta {
  self.push(InsertEmbed(embed, attributes))
}

///|
pub fn Delta::retain(self : Delta, length : Int32, attributes : Json) -> Delta {
  self.push(Retain(length, attributes))
}

///|
pub fn Delta::retain_plain(self : Delta, length : Int32) -> Delta {
  self.push(Retain(length, empty_attributes()))
}

///|
pub fn Delta::retain_embed(
  self : Delta,
  embed : Json,
  attributes : Json,
) -> Delta {
  self.push(RetainEmbed(embed, attributes))
}

///|
pub fn Delta::delete(self : Delta, length : Int32) -> Delta {
  self.push(Delete(length))
}

///|
/// A trailing unformatted retain has no observable effect on a change.
pub fn Delta::chop(self : Delta) -> Delta {
  if self.ops.length() > 0 {
    let last = self.ops[self.ops.length() - 1]
    match last {
      Retain(_, attrs) if no_attributes(attrs) => ignore(self.ops.pop())
      _ => ()
    }
  }
  self
}

///|
pub fn Delta::concat(self : Delta, other : Delta) -> Delta {
  let result = Delta::from_ops_raw(self.operations())
  if !other.ops.is_empty() {
    ignore(result.push(other.ops[0]))
    for index in 1..<other.ops.length() {
      result.ops.push(other.ops[index])
    }
  }
  result
}
