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
  let amount = if requested == 0 || requested >= remaining {
    remaining
  } else {
    requested
  }
  let start = self.offset
  if amount == remaining {
    self.index += 1
    self.offset = 0
  } else {
    self.offset += amount
  }
  match op {
    InsertText(text, attrs) =>
      InsertText(utf16_substring(text, start, amount), attrs)
    InsertEmbed(embed, attrs) => InsertEmbed(embed, attrs)
    Retain(_, attrs) => Retain(amount, attrs)
    RetainEmbed(embed, attrs) => RetainEmbed(embed, attrs)
    Delete(_) => Delete(amount)
  }
}

///|
/// Preserve isolated surrogate halves when an operation boundary falls inside
/// an emoji. JavaScript's substr() can return such halves; StringView::to_owned
/// does not preserve them on every MoonBit backend.
fn utf16_substring(text : String, start : Int32, length : Int32) -> String {
  if start == 0 && length == text.length() {
    return text
  }
  let units : Array[Char] = []
  for index in start..<(start + length) {
    units.push(text.at(index).to_int().unsafe_to_char())
  }
  String::from_array(units)
}

///|
pub fn OpIterator::rest(self : OpIterator) -> Array[Op] {
  let out : Array[Op] = []
  let cursor : OpIterator = {
    ops: self.ops,
    index: self.index,
    offset: self.offset,
  }
  while cursor.has_next() {
    out.push(cursor.next(cursor.peek_length()))
  }
  out
}

///|
pub fn Delta::slice(self : Delta, start : Int32, end : Int32) -> Delta {
  let result : Array[Op] = []
  let iter = OpIterator::new(self.ops)
  let mut index = 0
  while index < end && iter.has_next() {
    let amount = if index < start { start - index } else { end - index }
    let op = iter.next(amount)
    if index >= start {
      result.push(op)
    }
    index += op.length()
  }
  Delta::from_ops_raw(result)
}

///|
/// Return a cursor over a copy of the operation list.
pub fn Delta::iterator(self : Delta) -> OpIterator {
  OpIterator::new(self.operations())
}

///|
/// Slice from a UTF-16 offset through the end, corresponding to Quill's
/// slice(start) overload.
pub fn Delta::slice_from(self : Delta, start : Int32) -> Delta {
  self.slice(start, self.length())
}

///|
/// Return the whole Delta as a separate value, corresponding to slice().
pub fn Delta::slice_all(self : Delta) -> Delta {
  self.slice(0, self.length())
}

///|
/// Consume the remaining part of the next operation.
pub fn OpIterator::next_full(self : OpIterator) -> Op {
  self.next(self.peek_length())
}
