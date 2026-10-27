///|
/// Internal cursor over operations. It splits text using UTF-16 offsets, the
/// same unit used by Quill's JavaScript implementation.
pub struct OpIterator {
  ops : Array[Op]
  mut index : Int32
  mut offset : Int32
}

///|
pub fn OpIterator::new(ops : Array[Op]) -> OpIterator {
  { ops, index: 0, offset: 0, }
}

///|
pub fn OpIterator::has_next(self : OpIterator) -> Bool {
  self.index < self.ops.length()
}

///|
pub fn OpIterator::peek(self : OpIterator) -> Op? {
  if self.has_next() {
    Some(self.ops[self.index])
  } else {
    None
  }
}

///|
pub fn OpIterator::peek_length(self : OpIterator) -> Int32 {
  if self.has_next() {
    self.ops[self.index].length() - self.offset
  } else {
    2147483647
  }
}

///|
pub fn OpIterator::peek_kind(self : OpIterator) -> String {
  if self.has_next() {
    self.ops[self.index].kind()
  } else {
    "retain"
  }
}

///|
pub fn OpIterator::next(self : OpIterator, requested : Int32) -> Op {
  if !self.has_next() {
    return Retain(2147483647, empty_attributes())
  }
  let op = self.ops[self.index]
  let remaining = op.length() - self.offset
  let amount = if requested < remaining { requested } else { remaining }
  let start = self.offset
  if amount == remaining {
    self.index += 1
    self.offset = 0
  } else {
    self.offset += amount
  }
  match op {
    InsertText(text, attrs) =>
      InsertText(text[start:start + amount].to_owned(), attrs)
    InsertEmbed(embed, attrs) => InsertEmbed(embed, attrs)
    Retain(_, attrs) => Retain(amount, attrs)
    RetainEmbed(embed, attrs) => RetainEmbed(embed, attrs)
    Delete(_) => Delete(amount)
  }
}

///|
pub fn OpIterator::rest(self : OpIterator) -> Array[Op] {
  let out : Array[Op] = []
  while self.has_next() {
    out.push(self.next(self.peek_length()))
  }
  out
}

///|
pub fn Delta::slice(self : Delta, start : Int32, end : Int32) -> Delta {
  let result = Delta::new()
  let iter = OpIterator::new(self.ops)
  let mut index = 0
  while index < end && iter.has_next() {
    let amount = if index < start { start - index } else { end - index }
    let op = iter.next(amount)
    if index >= start {
      ignore(result.push(op))
    }
    index += op.length()
  }
  result
}

///|
/// Return a cursor over a copy of the operation list.
pub fn Delta::iterator(self : Delta) -> OpIterator {
  OpIterator::new(self.operations())
}
