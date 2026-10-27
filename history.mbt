///|
/// Local rich-text document with reversible changes. History stores inverse
/// Deltas, so edits to embedded values have the same restrictions as invert.
pub struct History {
  mut document : Delta
  undo_stack : Array[Delta]
  mut redo_stack : Array[Delta]
  mut revision : Int32
  max_depth : Int32
}

///|
pub fn History::new(
  document : Delta,
  max_depth : Int32,
) -> History raise DeltaError {
  if !document.is_document() {
    raise Invalid("history requires an insert-only document")
  }
  if max_depth <= 0 {
    raise Invalid("history depth must be positive")
  }
  {
    document: Delta::from_ops(document.operations()),
    undo_stack: [],
    redo_stack: [],
    revision: 0,
    max_depth,
  }
}

///|
pub fn History::document(self : History) -> Delta {
  Delta::from_ops(self.document.operations())
}

///|
pub fn History::revision(self : History) -> Int32 {
  self.revision
}

///|
pub fn History::can_undo(self : History) -> Bool {
  !self.undo_stack.is_empty()
}

///|
pub fn History::can_redo(self : History) -> Bool {
  !self.redo_stack.is_empty()
}

///|
pub fn History::undo_depth(self : History) -> Int32 {
  self.undo_stack.length()
}

///|
pub fn History::redo_depth(self : History) -> Int32 {
  self.redo_stack.length()
}

///|
pub fn History::apply(self : History, change : Delta) -> Unit raise DeltaError {
  let inverse = change.invert(self.document)
  let next = self.document.apply(change)
  self.document = next
  self.undo_stack.push(inverse)
  if self.undo_stack.length() > self.max_depth {
    ignore(self.undo_stack.remove(0))
  }
  self.redo_stack = []
  self.revision += 1
}

///|
/// Undo the most recent local edit. Returns false when there is nothing to do.
pub fn History::undo(self : History) -> Bool raise DeltaError {
  let inverse = match self.undo_stack.pop() {
    Some(change) => change
    None => return false
  }
  let redo = inverse.invert(self.document)
  self.document = self.document.apply(inverse)
  self.redo_stack.push(redo)
  self.revision += 1
  true
}

///|
/// Redo the most recently undone edit. Returns false when there is none.
pub fn History::redo(self : History) -> Bool raise DeltaError {
  let change = match self.redo_stack.pop() {
    Some(change) => change
    None => return false
  }
  let inverse = change.invert(self.document)
  self.document = self.document.apply(change)
  self.undo_stack.push(inverse)
  if self.undo_stack.length() > self.max_depth {
    ignore(self.undo_stack.remove(0))
  }
  self.revision += 1
  true
}
