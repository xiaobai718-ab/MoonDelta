///|
/// Text diff components follow fast-diff 1.3.0's -1/0/1 convention. This
/// implementation operates on UTF-16 code units, matching JavaScript strings.
priv struct FastEdit {
  mut kind : Int32
  mut text : String
}

///|
fn fast_edit(kind : Int32, text : String) -> FastEdit {
  { kind, text, }
}

///|
priv struct HalfMatch {
  old_before : String
  old_after : String
  new_before : String
  new_after : String
  common : String
}

///|
fn fast_diff_text(old : String, next : String) -> Array[FastEdit] {
  fast_diff_main(old, next, true, true)
}

///|
fn fast_diff_main(
  old : String,
  next : String,
  semantic : Bool,
  fix_unicode : Bool,
) -> Array[FastEdit] {
  if old == next {
    if old.length() == 0 {
      return []
    }
    return [fast_edit(0, old)]
  }
  let prefix_length = fast_common_prefix(old, next)
  let prefix = old[:prefix_length].to_owned()
  let mut old_middle = old[prefix_length:].to_owned()
  let mut new_middle = next[prefix_length:].to_owned()
  let suffix_length = fast_common_suffix(old_middle, new_middle)
  let suffix = old_middle[old_middle.length() - suffix_length:].to_owned()
  old_middle = old_middle[:old_middle.length() - suffix_length].to_owned()
  new_middle = new_middle[:new_middle.length() - suffix_length].to_owned()
  let edits = fast_diff_compute(old_middle, new_middle)
  if prefix_length > 0 {
    edits.insert(0, fast_edit(0, prefix))
  }
  if suffix_length > 0 {
    edits.push(fast_edit(0, suffix))
  }
  fast_cleanup_merge(edits, fix_unicode)
  if semantic {
    fast_cleanup_semantic(edits)
  }
  edits
}

///|
fn fast_diff_compute(old : String, next : String) -> Array[FastEdit] {
  if old.length() == 0 {
    return [fast_edit(1, next)]
  }
  if next.length() == 0 {
    return [fast_edit(-1, old)]
  }
  let old_longer = old.length() > next.length()
  let long = if old_longer { old } else { next }
  let short = if old_longer { next } else { old }
  match long.find(short[:]) {
    Some(position) => {
      let kind = if old_longer { -1 } else { 1 }
      return [
        fast_edit(kind, long[:position].to_owned()),
        fast_edit(0, short),
        fast_edit(kind, long[position + short.length():].to_owned()),
      ]
    }
    None => ()
  }
  if short.length() == 1 {
    return [fast_edit(-1, old), fast_edit(1, next)]
  }
  match fast_half_match(old, next) {
    Some(half) => {
      let edits = fast_diff_main(half.old_before, half.new_before, false, false)
      edits.push(fast_edit(0, half.common))
      for edit in fast_diff_main(half.old_after, half.new_after, false, false) {
        edits.push(edit)
      }
      return edits
    }
    None => ()
  }
  fast_bisect(old, next)
}

///|
fn fast_common_prefix(left : String, right : String) -> Int32 {
  let limit = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  let mut amount = 0
  while amount < limit && left.at(amount) == right.at(amount) {
    amount += 1
  }
  if amount > 0 &&
    amount < left.length() &&
    left.at(amount - 1).to_int() >= 0xD800 &&
    left.at(amount - 1).to_int() <= 0xDBFF {
    amount -= 1
  }
  amount
}

///|
fn fast_common_suffix(left : String, right : String) -> Int32 {
  let limit = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  let mut amount = 0
  while amount < limit &&
        left.at(left.length() - amount - 1) ==
        right.at(right.length() - amount - 1) {
    amount += 1
  }
  if amount > 0 && amount < left.length() {
    let code = left.at(left.length() - amount).to_int()
    if code >= 0xDC00 && code <= 0xDFFF {
      amount -= 1
    }
  }
  amount
}

///|
fn fast_find_from(text : String, pattern : String, start : Int32) -> Int32? {
  match text[start:].to_owned().find(pattern[:]) {
    Some(offset) => Some(start + offset)
    None => None
  }
}

///|
fn fast_half_match(old : String, next : String) -> HalfMatch? {
  let old_longer = old.length() > next.length()
  let long = if old_longer { old } else { next }
  let short = if old_longer { next } else { old }
  if long.length() < 4 || short.length() * 2 < long.length() {
    return None
  }
  let quarter = (long.length() + 3) / 4
  let half = (long.length() + 1) / 2
  let first = fast_half_match_at(long, short, quarter)
  let second = fast_half_match_at(long, short, half)
  let best = match (first, second) {
    (None, None) => return None
    (Some(value), None) | (None, Some(value)) => value
    (Some(a), Some(b)) =>
      if a.common.length() > b.common.length() {
        a
      } else {
        b
      }
  }
  if old_longer {
    Some(best)
  } else {
    Some({
      old_before: best.new_before,
      old_after: best.new_after,
      new_before: best.old_before,
      new_after: best.old_after,
      common: best.common,
    })
  }
}

///|
fn fast_half_match_at(
  long : String,
  short : String,
  offset : Int32,
) -> HalfMatch? {
  let seed_size = long.length() / 4
  let seed = long[offset:offset + seed_size].to_owned()
  let mut search_from = 0
  let mut best_common = ""
  let mut best : HalfMatch? = None
  while search_from <= short.length() {
    let found = match fast_find_from(short, seed, search_from) {
      Some(position) => position
      None => break
    }
    let prefix = fast_common_prefix(
      long[offset:].to_owned(),
      short[found:].to_owned(),
    )
    let suffix = fast_common_suffix(
      long[:offset].to_owned(),
      short[:found].to_owned(),
    )
    if best_common.length() < prefix + suffix {
      best_common = short[found - suffix:found + prefix].to_owned()
      best = Some({
        old_before: long[:offset - suffix].to_owned(),
        old_after: long[offset + prefix:].to_owned(),
        new_before: short[:found - suffix].to_owned(),
        new_after: short[found + prefix:].to_owned(),
        common: best_common,
      })
    }
    search_from = found + 1
  }
  if best_common.length() * 2 >= long.length() {
    best
  } else {
    None
  }
}

///|
fn fast_bisect(old : String, next : String) -> Array[FastEdit] {
  let old_length = old.length()
  let new_length = next.length()
  let max_distance = (old_length + new_length + 1) / 2
  let offset = max_distance
  let table_length = 2 * max_distance
  let front = Array::make(table_length, -1)
  let reverse = Array::make(table_length, -1)
  front[offset + 1] = 0
  reverse[offset + 1] = 0
  let delta = old_length - new_length
  let odd = delta % 2 != 0
  let mut front_start = 0
  let mut front_end = 0
  let mut reverse_start = 0
  let mut reverse_end = 0
  for distance in 0..<max_distance {
    let mut diagonal = -distance + front_start
    while diagonal <= distance - front_end {
      let slot = offset + diagonal
      let mut x = if diagonal == -distance ||
        (diagonal != distance && front[slot - 1] < front[slot + 1]) {
        front[slot + 1]
      } else {
        front[slot - 1] + 1
      }
      let mut y = x - diagonal
      while x < old_length && y < new_length && old.at(x) == next.at(y) {
        x += 1
        y += 1
      }
      front[slot] = x
      if x > old_length {
        front_end += 2
      } else if y > new_length {
        front_start += 2
      } else if odd {
        let other_slot = offset + delta - diagonal
        if other_slot >= 0 &&
          other_slot < table_length &&
          reverse[other_slot] != -1 {
          let other_x = old_length - reverse[other_slot]
          if x >= other_x {
            return fast_bisect_split(old, next, x, y)
          }
        }
      }
      diagonal += 2
    }
    diagonal = -distance + reverse_start
    while diagonal <= distance - reverse_end {
      let slot = offset + diagonal
      let mut x = if diagonal == -distance ||
        (diagonal != distance && reverse[slot - 1] < reverse[slot + 1]) {
        reverse[slot + 1]
      } else {
        reverse[slot - 1] + 1
      }
      let mut y = x - diagonal
      while x < old_length &&
            y < new_length &&
            old.at(old_length - x - 1) == next.at(new_length - y - 1) {
        x += 1
        y += 1
      }
      reverse[slot] = x
      if x > old_length {
        reverse_end += 2
      } else if y > new_length {
        reverse_start += 2
      } else if !odd {
        let other_slot = offset + delta - diagonal
        if other_slot >= 0 &&
          other_slot < table_length &&
          front[other_slot] != -1 {
          let other_x = front[other_slot]
          let other_y = offset + other_x - other_slot
          x = old_length - x
          if other_x >= x {
            return fast_bisect_split(old, next, other_x, other_y)
          }
        }
      }
      diagonal += 2
    }
  }
  [fast_edit(-1, old), fast_edit(1, next)]
}

///|
fn fast_bisect_split(
  old : String,
  next : String,
  old_split : Int32,
  new_split : Int32,
) -> Array[FastEdit] {
  // StringView::to_owned does not preserve an isolated UTF-16 surrogate on
  // every backend. Move the bisect cut to a complete code point boundary.
  let old_split = if valid_utf16_cut(old, old_split) {
    old_split
  } else {
    old_split - 1
  }
  let new_split = if valid_utf16_cut(next, new_split) {
    new_split
  } else {
    new_split - 1
  }
  if (old_split == 0 && new_split == 0) ||
    (old_split == old.length() && new_split == next.length()) {
    return [fast_edit(-1, old), fast_edit(1, next)]
  }
  let edits = fast_diff_main(
    old[:old_split].to_owned(),
    next[:new_split].to_owned(),
    false,
    false,
  )
  for
    edit in fast_diff_main(
      old[old_split:].to_owned(),
      next[new_split:].to_owned(),
      false,
      false,
    ) {
    edits.push(edit)
  }
  edits
}

///|
fn fast_cleanup_merge(edits : Array[FastEdit], fix_unicode : Bool) -> Unit {
  edits.push(fast_edit(0, ""))
  let mut pointer = 0
  let mut count_delete = 0
  let mut count_insert = 0
  let mut text_delete = ""
  let mut text_insert = ""
  while pointer < edits.length() {
    if pointer < edits.length() - 1 && edits[pointer].text.length() == 0 {
      ignore(edits.remove(pointer))
      continue
    }
    if edits[pointer].kind == 1 {
      count_insert += 1
      text_insert += edits[pointer].text
      pointer += 1
      continue
    }
    if edits[pointer].kind == -1 {
      count_delete += 1
      text_delete += edits[pointer].text
      pointer += 1
      continue
    }
    let mut previous_equality = pointer - count_insert - count_delete - 1
    if fix_unicode {
      if previous_equality >= 0 &&
        fast_ends_pair_start(edits[previous_equality].text) {
        let previous = edits[previous_equality].text
        let stray = previous[previous.length() - 1:].to_owned()
        edits[previous_equality].text = previous[:previous.length() - 1].to_owned()
        text_delete = stray + text_delete
        text_insert = stray + text_insert
        if edits[previous_equality].text.length() == 0 {
          ignore(edits.remove(previous_equality))
          pointer -= 1
          let mut index = previous_equality - 1
          if index >= 0 && edits[index].kind == 1 {
            count_insert += 1
            text_insert = edits[index].text + text_insert
            index -= 1
          }
          if index >= 0 && edits[index].kind == -1 {
            count_delete += 1
            text_delete = edits[index].text + text_delete
            index -= 1
          }
          previous_equality = index
        }
      }
      if fast_starts_pair_end(edits[pointer].text) {
        let current = edits[pointer].text
        let stray = current[:1].to_owned()
        edits[pointer].text = current[1:].to_owned()
        text_delete += stray
        text_insert += stray
      }
    }
    if pointer < edits.length() - 1 && edits[pointer].text.length() == 0 {
      ignore(edits.remove(pointer))
      continue
    }
    if text_delete.length() > 0 || text_insert.length() > 0 {
      if text_delete.length() > 0 && text_insert.length() > 0 {
        let prefix = fast_common_prefix(text_insert, text_delete)
        if prefix > 0 {
          let common = text_insert[:prefix].to_owned()
          if previous_equality >= 0 {
            edits[previous_equality].text += common
          } else {
            edits.insert(0, fast_edit(0, common))
            pointer += 1
          }
          text_insert = text_insert[prefix:].to_owned()
          text_delete = text_delete[prefix:].to_owned()
        }
        let suffix = fast_common_suffix(text_insert, text_delete)
        if suffix > 0 {
          let common = text_insert[text_insert.length() - suffix:].to_owned()
          edits[pointer].text = common + edits[pointer].text
          text_insert = text_insert[:text_insert.length() - suffix].to_owned()
          text_delete = text_delete[:text_delete.length() - suffix].to_owned()
        }
      }
      let start = pointer - count_insert - count_delete
      let replacements : Array[FastEdit] = []
      if text_delete.length() > 0 {
        replacements.push(fast_edit(-1, text_delete))
      }
      if text_insert.length() > 0 {
        replacements.push(fast_edit(1, text_insert))
      }
      fast_splice(edits, start, count_insert + count_delete, replacements)
      pointer = start + replacements.length()
    }
    if pointer != 0 && edits[pointer - 1].kind == 0 {
      edits[pointer - 1].text += edits[pointer].text
      ignore(edits.remove(pointer))
    } else {
      pointer += 1
    }
    count_delete = 0
    count_insert = 0
    text_delete = ""
    text_insert = ""
  }
  if !edits.is_empty() && edits[edits.length() - 1].text.length() == 0 {
    ignore(edits.pop())
  }
  let mut shifted = false
  pointer = 1
  while pointer < edits.length() - 1 {
    if edits[pointer - 1].kind == 0 && edits[pointer + 1].kind == 0 {
      let before = edits[pointer - 1].text
      let change = edits[pointer].text
      let after = edits[pointer + 1].text
      if change.length() >= before.length() &&
        change[change.length() - before.length():] == before[:] {
        edits[pointer].text = before +
          change[:change.length() - before.length()].to_owned()
        edits[pointer + 1].text = before + after
        ignore(edits.remove(pointer - 1))
        shifted = true
      } else if change.length() >= after.length() &&
        change[:after.length()] == after[:] {
        edits[pointer - 1].text += after
        edits[pointer].text = change[after.length():].to_owned() + after
        ignore(edits.remove(pointer + 1))
        shifted = true
      }
    }
    pointer += 1
  }
  if shifted {
    fast_cleanup_merge(edits, fix_unicode)
  }
}

///|
fn fast_splice(
  edits : Array[FastEdit],
  start : Int32,
  count : Int32,
  replacements : Array[FastEdit],
) -> Unit {
  for _ in 0..<count {
    ignore(edits.remove(start))
  }
  for index, edit in replacements {
    edits.insert(start + index, edit)
  }
}

///|
fn fast_ends_pair_start(text : String) -> Bool {
  text.length() > 0 &&
  text.at(text.length() - 1).to_int() >= 0xD800 &&
  text.at(text.length() - 1).to_int() <= 0xDBFF
}

///|
fn fast_starts_pair_end(text : String) -> Bool {
  text.length() > 0 &&
  text.at(0).to_int() >= 0xDC00 &&
  text.at(0).to_int() <= 0xDFFF
}

///|
fn fast_cleanup_semantic(edits : Array[FastEdit]) -> Unit {
  let equalities : Array[Int32] = []
  let mut last_equality = ""
  let mut pointer = 0
  let mut insertions_before = 0
  let mut deletions_before = 0
  let mut insertions_after = 0
  let mut deletions_after = 0
  let mut changed = false
  while pointer < edits.length() {
    if edits[pointer].kind == 0 {
      equalities.push(pointer)
      insertions_before = insertions_after
      deletions_before = deletions_after
      insertions_after = 0
      deletions_after = 0
      last_equality = edits[pointer].text
    } else {
      if edits[pointer].kind == 1 {
        insertions_after += edits[pointer].text.length()
      } else {
        deletions_after += edits[pointer].text.length()
      }
      let before = if insertions_before > deletions_before {
        insertions_before
      } else {
        deletions_before
      }
      let after = if insertions_after > deletions_after {
        insertions_after
      } else {
        deletions_after
      }
      if last_equality.length() > 0 &&
        last_equality.length() <= before &&
        last_equality.length() <= after {
        let location = equalities[equalities.length() - 1]
        edits.insert(location, fast_edit(-1, last_equality))
        edits[location + 1].kind = 1
        ignore(equalities.pop())
        ignore(equalities.pop())
        pointer = if equalities.is_empty() {
          -1
        } else {
          equalities[equalities.length() - 1]
        }
        insertions_before = 0
        deletions_before = 0
        insertions_after = 0
        deletions_after = 0
        last_equality = ""
        changed = true
      }
    }
    pointer += 1
  }
  if changed {
    fast_cleanup_merge(edits, false)
  }
  fast_cleanup_semantic_lossless(edits)
  pointer = 1
  while pointer < edits.length() {
    if edits[pointer - 1].kind == -1 && edits[pointer].kind == 1 {
      let deletion = edits[pointer - 1].text
      let insertion = edits[pointer].text
      let forward = common_overlap(deletion, insertion)
      let backward = common_overlap(insertion, deletion)
      if forward >= backward {
        if overlap_is_substantial(
            forward,
            deletion.length(),
            insertion.length(),
          ) {
          edits.insert(pointer, fast_edit(0, insertion[:forward].to_owned()))
          edits[pointer - 1].text = deletion[:deletion.length() - forward].to_owned()
          edits[pointer + 1].text = insertion[forward:].to_owned()
          pointer += 1
        }
      } else if overlap_is_substantial(
          backward,
          deletion.length(),
          insertion.length(),
        ) {
        edits.insert(pointer, fast_edit(0, deletion[:backward].to_owned()))
        edits[pointer - 1].kind = 1
        edits[pointer - 1].text = insertion[:insertion.length() - backward].to_owned()
        edits[pointer + 1].kind = -1
        edits[pointer + 1].text = deletion[backward:].to_owned()
        pointer += 1
      }
      pointer += 1
    }
    pointer += 1
  }
}

///|
fn fast_cleanup_semantic_lossless(edits : Array[FastEdit]) -> Unit {
  let mut pointer = 1
  while pointer < edits.length() - 1 {
    if edits[pointer - 1].kind == 0 && edits[pointer + 1].kind == 0 {
      let mut left = edits[pointer - 1].text
      let mut change = edits[pointer].text
      let mut right = edits[pointer + 1].text
      let common = fast_common_suffix(left, change)
      if common > 0 {
        let shifted = change[change.length() - common:].to_owned()
        left = left[:left.length() - common].to_owned()
        change = shifted + change[:change.length() - common].to_owned()
        right = shifted + right
      }
      let mut best_left = left
      let mut best_change = change
      let mut best_right = right
      let mut best_score = fast_semantic_score(left, change) +
        fast_semantic_score(change, right)
      while change.length() > 0 &&
            right.length() > 0 &&
            change.at(0) == right.at(0) {
        let leading = change[:1].to_owned()
        left += leading
        change = change[1:].to_owned() + right[:1].to_owned()
        right = right[1:].to_owned()
        let score = fast_semantic_score(left, change) +
          fast_semantic_score(change, right)
        if score >= best_score {
          best_score = score
          best_left = left
          best_change = change
          best_right = right
        }
      }
      if edits[pointer - 1].text != best_left {
        if best_left.length() > 0 {
          edits[pointer - 1].text = best_left
        } else {
          ignore(edits.remove(pointer - 1))
          pointer -= 1
        }
        edits[pointer].text = best_change
        if best_right.length() > 0 {
          edits[pointer + 1].text = best_right
        } else {
          ignore(edits.remove(pointer + 1))
          pointer -= 1
        }
      }
    }
    pointer += 1
  }
}

///|
fn fast_semantic_score(left : String, right : String) -> Int32 {
  if left.length() == 0 || right.length() == 0 {
    return 6
  }
  let last = left.at(left.length() - 1).to_int()
  let first = right.at(0).to_int()
  let non_alnum_left = !fast_ascii_alnum(last)
  let non_alnum_right = !fast_ascii_alnum(first)
  let whitespace_left = non_alnum_left && fast_whitespace(last)
  let whitespace_right = non_alnum_right && fast_whitespace(first)
  let line_left = whitespace_left && (last == 10 || last == 13)
  let line_right = whitespace_right && (first == 10 || first == 13)
  if (line_left && fast_blank_line_end(left)) ||
    (line_right && fast_blank_line_start(right)) {
    return 5
  }
  if line_left || line_right {
    return 4
  }
  if non_alnum_left && !whitespace_left && whitespace_right {
    return 3
  }
  if whitespace_left || whitespace_right {
    return 2
  }
  if non_alnum_left || non_alnum_right {
    return 1
  }
  0
}

///|
fn fast_ascii_alnum(code : Int32) -> Bool {
  (code >= 48 && code <= 57) ||
  (code >= 65 && code <= 90) ||
  (code >= 97 && code <= 122)
}

///|
fn fast_whitespace(code : Int32) -> Bool {
  code == 9 ||
  code == 10 ||
  code == 11 ||
  code == 12 ||
  code == 13 ||
  code == 32 ||
  code == 0xA0 ||
  code == 0x1680 ||
  (code >= 0x2000 && code <= 0x200A) ||
  code == 0x2028 ||
  code == 0x2029 ||
  code == 0x202F ||
  code == 0x205F ||
  code == 0x3000 ||
  code == 0xFEFF
}

///|
fn fast_blank_line_end(text : String) -> Bool {
  let length = text.length()
  (length >= 2 && text[length - 2:] == "\n\n"[:]) ||
  (length >= 3 && text[length - 3:] == "\n\r\n"[:]) ||
  (length >= 3 && text[length - 3:] == "\r\n\n"[:]) ||
  (length >= 4 && text[length - 4:] == "\r\n\r\n"[:])
}

///|
fn fast_blank_line_start(text : String) -> Bool {
  (text.length() >= 2 && text[:2] == "\n\n"[:]) ||
  (text.length() >= 3 && text[:3] == "\n\r\n"[:]) ||
  (text.length() >= 3 && text[:3] == "\r\n\n"[:]) ||
  (text.length() >= 4 && text[:4] == "\r\n\r\n"[:])
}
