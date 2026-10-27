///|
/// Visit every operation with its zero-based operation index.
pub fn Delta::for_each(self : Delta, visit : (Op, Int32) -> Unit) -> Unit {
  for index, op in self.ops {
    visit(op, index)
  }
}

///|
/// Map operations to arbitrary values, passing the operation index.
pub fn[T] Delta::map(self : Delta, convert : (Op, Int32) -> T) -> Array[T] {
  let output : Array[T] = []
  for index, op in self.ops {
    output.push(convert(op, index))
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
  for index, op in self.ops {
    if predicate(op, index) {
      output.push(op)
    }
  }
  output
}

///|
/// Split operations by a predicate. The first array contains accepted ops;
/// both arrays preserve the order of their source operations.
pub fn Delta::partition(
  self : Delta,
  predicate : (Op) -> Bool,
) -> (Array[Op], Array[Op]) {
  let accepted : Array[Op] = []
  let rejected : Array[Op] = []
  for op in self.ops {
    if predicate(op) {
      accepted.push(op)
    } else {
      rejected.push(op)
    }
  }
  (accepted, rejected)
}

///|
/// Fold a Delta's operations, passing each operation index to the reducer.
pub fn[T] Delta::reduce(
  self : Delta,
  initial : T,
  combine : (T, Op, Int32) -> T,
) -> T {
  let mut value = initial
  for index, op in self.ops {
    value = combine(value, op, index)
  }
  value
}
