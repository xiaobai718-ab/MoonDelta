///|
/// Visit every operation with its UTF-16 offset in the input sequence.
pub fn Delta::for_each(self : Delta, visit : (Op, Int32) -> Unit) -> Unit {
  let mut offset = 0
  for op in self.ops {
    visit(op, offset)
    offset += op.length()
  }
}

///|
/// Map operations to arbitrary values. The offset counts prior operation
/// lengths, including deleted content, like the Quill Delta API.
pub fn[T] Delta::map(self : Delta, convert : (Op, Int32) -> T) -> Array[T] {
  let output : Array[T] = []
  let mut offset = 0
  for op in self.ops {
    output.push(convert(op, offset))
    offset += op.length()
  }
  output
}

///|
/// Return operations accepted by a predicate, preserving original order.
pub fn Delta::filter(
  self : Delta,
  predicate : (Op, Int32) -> Bool,
) -> Array[Op] {
  let output : Array[Op] = []
  let mut offset = 0
  for op in self.ops {
    if predicate(op, offset) {
      output.push(op)
    }
    offset += op.length()
  }
  output
}

///|
/// Split operations by a predicate. The first array contains accepted ops;
/// both arrays preserve the order of their source operations.
pub fn Delta::partition(
  self : Delta,
  predicate : (Op, Int32) -> Bool,
) -> (Array[Op], Array[Op]) {
  let accepted : Array[Op] = []
  let rejected : Array[Op] = []
  let mut offset = 0
  for op in self.ops {
    if predicate(op, offset) {
      accepted.push(op)
    } else {
      rejected.push(op)
    }
    offset += op.length()
  }
  (accepted, rejected)
}

///|
/// Fold a Delta's operations, passing each UTF-16 offset to the reducer.
pub fn[T] Delta::reduce(
  self : Delta,
  initial : T,
  combine : (T, Op, Int32) -> T,
) -> T {
  let mut value = initial
  let mut offset = 0
  for op in self.ops {
    value = combine(value, op, offset)
    offset += op.length()
  }
  value
}
