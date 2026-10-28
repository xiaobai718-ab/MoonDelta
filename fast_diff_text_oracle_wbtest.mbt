///|
test "fast-diff text oracle 0" {
  let actual = fast_diff_text("ab", "ba")
  let expected : Array[(Int32, String)] = [(-1, "a"), (0, "b"), (1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 1" {
  let actual = fast_diff_text("Badcat", "Gooddog")
  let expected : Array[(Int32, String)] = [(-1, "Badcat"), (1, "Gooddog")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 2" {
  let actual = fast_diff_text("abc", "axc")
  let expected : Array[(Int32, String)] = [
    (0, "a"),
    (-1, "b"),
    (1, "x"),
    (0, "c"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 3" {
  let actual = fast_diff_text("aaaa", "aaa")
  let expected : Array[(Int32, String)] = [(0, "aaa"), (-1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 4" {
  let actual = fast_diff_text("aaa", "aaaa")
  let expected : Array[(Int32, String)] = [(0, "aaa"), (1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 5" {
  let actual = fast_diff_text("cat", "cut")
  let expected : Array[(Int32, String)] = [
    (0, "c"),
    (-1, "a"),
    (1, "u"),
    (0, "t"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 6" {
  let actual = fast_diff_text("The cat came.", "The black cat came.")
  let expected : Array[(Int32, String)] = [
    (0, "The "),
    (1, "black "),
    (0, "cat came."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 7" {
  let actual = fast_diff_text("The c came.", "The cat came.")
  let expected : Array[(Int32, String)] = [
    (0, "The c"),
    (1, "at"),
    (0, " came."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 8" {
  let actual = fast_diff_text("a b", "ab ")
  let expected : Array[(Int32, String)] = [
    (0, "a"),
    (-1, " "),
    (0, "b"),
    (1, " "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 9" {
  let actual = fast_diff_text("abcabc", "abXabc")
  let expected : Array[(Int32, String)] = [
    (0, "ab"),
    (-1, "c"),
    (1, "X"),
    (0, "abc"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 10" {
  let actual = fast_diff_text("a😀b", "x😀y")
  let expected : Array[(Int32, String)] = [
    (-1, "a"),
    (1, "x"),
    (0, "😀"),
    (-1, "b"),
    (1, "y"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 11" {
  let actual = fast_diff_text("hello world", "hello MoonBit")
  let expected : Array[(Int32, String)] = [
    (0, "hello "),
    (-1, "world"),
    (1, "MoonBit"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 12" {
  let actual = fast_diff_text("\n.c.\n", " \n ca")
  let expected : Array[(Int32, String)] = [(-1, "\n.c.\n"), (1, " \n ca")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 13" {
  let actual = fast_diff_text("", ".babb")
  let expected : Array[(Int32, String)] = [(1, ".babb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 14" {
  let actual = fast_diff_text(" cab", "bcbc c")
  let expected : Array[(Int32, String)] = [(1, "bcbc"), (0, " c"), (-1, "ab")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 15" {
  let actual = fast_diff_text("\n\n.b", ".caa")
  let expected : Array[(Int32, String)] = [(-1, "\n\n.b"), (1, ".caa")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 16" {
  let actual = fast_diff_text("b\n", "a. ba")
  let expected : Array[(Int32, String)] = [(-1, "b\n"), (1, "a. ba")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 17" {
  let actual = fast_diff_text(".\n aa", "a\nac .")
  let expected : Array[(Int32, String)] = [(-1, ".\n aa"), (1, "a\nac .")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 18" {
  let actual = fast_diff_text("bba\n \n ", "a.a")
  let expected : Array[(Int32, String)] = [(-1, "bba\n \n "), (1, "a.a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 19" {
  let actual = fast_diff_text("cb.b", "bcb ")
  let expected : Array[(Int32, String)] = [
    (1, "b"),
    (0, "cb"),
    (-1, ".b"),
    (1, " "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 20" {
  let actual = fast_diff_text("a", ". ")
  let expected : Array[(Int32, String)] = [(-1, "a"), (1, ". ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 21" {
  let actual = fast_diff_text("ac\n..", "a.. b")
  let expected : Array[(Int32, String)] = [
    (0, "a"),
    (-1, "c\n"),
    (0, ".."),
    (1, " b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 22" {
  let actual = fast_diff_text("b.", "b.. \n  ")
  let expected : Array[(Int32, String)] = [(0, "b."), (1, ". \n  ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 23" {
  let actual = fast_diff_text("c .b b.", "c")
  let expected : Array[(Int32, String)] = [(0, "c"), (-1, " .b b.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 24" {
  let actual = fast_diff_text("b b", "\n a\n..")
  let expected : Array[(Int32, String)] = [(-1, "b b"), (1, "\n a\n..")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 25" {
  let actual = fast_diff_text("aa\n", "")
  let expected : Array[(Int32, String)] = [(-1, "aa\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 26" {
  let actual = fast_diff_text("cc\nbab", " .a  ac")
  let expected : Array[(Int32, String)] = [(-1, "cc\nbab"), (1, " .a  ac")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 27" {
  let actual = fast_diff_text("\na ba", "ba")
  let expected : Array[(Int32, String)] = [(-1, "\na "), (0, "ba")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 28" {
  let actual = fast_diff_text("c\n", "\n")
  let expected : Array[(Int32, String)] = [(-1, "c"), (0, "\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 29" {
  let actual = fast_diff_text("c", ".cbc")
  let expected : Array[(Int32, String)] = [(1, ".cb"), (0, "c")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 30" {
  let actual = fast_diff_text("", "bacc")
  let expected : Array[(Int32, String)] = [(1, "bacc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 31" {
  let actual = fast_diff_text("cb\n", "\n\nb\n.cb")
  let expected : Array[(Int32, String)] = [
    (1, "\n\nb\n."),
    (0, "cb"),
    (-1, "\n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 32" {
  let actual = fast_diff_text("aa\n \n", "")
  let expected : Array[(Int32, String)] = [(-1, "aa\n \n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 33" {
  let actual = fast_diff_text("c .c", "bcc")
  let expected : Array[(Int32, String)] = [
    (1, "b"),
    (0, "c"),
    (-1, " ."),
    (0, "c"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 34" {
  let actual = fast_diff_text(" ", ".bcc a")
  let expected : Array[(Int32, String)] = [(-1, " "), (1, ".bcc a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 35" {
  let actual = fast_diff_text("", "c\n.\nc.")
  let expected : Array[(Int32, String)] = [(1, "c\n.\nc.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 36" {
  let actual = fast_diff_text("ac", "b b\n.")
  let expected : Array[(Int32, String)] = [(-1, "ac"), (1, "b b\n.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 37" {
  let actual = fast_diff_text("ac \n.ab", "a ")
  let expected : Array[(Int32, String)] = [(0, "a"), (-1, "c \n.ab"), (1, " ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 38" {
  let actual = fast_diff_text("", "")
  let expected : Array[(Int32, String)] = []
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 39" {
  let actual = fast_diff_text("\nb\n", "a \na")
  let expected : Array[(Int32, String)] = [(-1, "\nb\n"), (1, "a \na")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 40" {
  let actual = fast_diff_text("", "cca")
  let expected : Array[(Int32, String)] = [(1, "cca")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 41" {
  let actual = fast_diff_text("abb", "\nacb c.")
  let expected : Array[(Int32, String)] = [(-1, "abb"), (1, "\nacb c.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 42" {
  let actual = fast_diff_text("cb  ", "cbc\n\n")
  let expected : Array[(Int32, String)] = [(0, "cb"), (-1, "  "), (1, "c\n\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 43" {
  let actual = fast_diff_text("... ", " ")
  let expected : Array[(Int32, String)] = [(-1, "..."), (0, " ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 44" {
  let actual = fast_diff_text(".bb", "bcc")
  let expected : Array[(Int32, String)] = [(-1, ".bb"), (1, "bcc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 45" {
  let actual = fast_diff_text(" ", "ca ac")
  let expected : Array[(Int32, String)] = [(-1, " "), (1, "ca ac")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 46" {
  let actual = fast_diff_text("a", "\n.\na\n ")
  let expected : Array[(Int32, String)] = [(-1, "a"), (1, "\n.\na\n ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 47" {
  let actual = fast_diff_text("\n", "b \n.a")
  let expected : Array[(Int32, String)] = [(-1, "\n"), (1, "b \n.a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 48" {
  let actual = fast_diff_text("", "b.")
  let expected : Array[(Int32, String)] = [(1, "b.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 49" {
  let actual = fast_diff_text(".aba", "   ")
  let expected : Array[(Int32, String)] = [(-1, ".aba"), (1, "   ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 50" {
  let actual = fast_diff_text("\n.\nb.c", "caca\n ")
  let expected : Array[(Int32, String)] = [(-1, "\n.\nb.c"), (1, "caca\n ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 51" {
  let actual = fast_diff_text(" .a  b", "")
  let expected : Array[(Int32, String)] = [(-1, " .a  b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 52" {
  let actual = fast_diff_text("ac\nb\n\n ", "b.c\n .b")
  let expected : Array[(Int32, String)] = [(-1, "ac\nb\n\n "), (1, "b.c\n .b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 53" {
  let actual = fast_diff_text(".cb bb", "c\n")
  let expected : Array[(Int32, String)] = [(-1, ".cb bb"), (1, "c\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 54" {
  let actual = fast_diff_text(" ", "   b")
  let expected : Array[(Int32, String)] = [(0, " "), (1, "  b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 55" {
  let actual = fast_diff_text("", "aca")
  let expected : Array[(Int32, String)] = [(1, "aca")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 56" {
  let actual = fast_diff_text("\nc", "")
  let expected : Array[(Int32, String)] = [(-1, "\nc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 57" {
  let actual = fast_diff_text("\nca c\n", "b.bc")
  let expected : Array[(Int32, String)] = [(-1, "\nca c\n"), (1, "b.bc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 58" {
  let actual = fast_diff_text("b acb.", "c\nc")
  let expected : Array[(Int32, String)] = [(-1, "b acb."), (1, "c\nc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 59" {
  let actual = fast_diff_text("bcbb", "a.")
  let expected : Array[(Int32, String)] = [(-1, "bcbb"), (1, "a.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 60" {
  let actual = fast_diff_text(" aa\nc", "")
  let expected : Array[(Int32, String)] = [(-1, " aa\nc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 61" {
  let actual = fast_diff_text(" b  a", "\nac..")
  let expected : Array[(Int32, String)] = [(-1, " b  a"), (1, "\nac..")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 62" {
  let actual = fast_diff_text("", "acbc")
  let expected : Array[(Int32, String)] = [(1, "acbc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 63" {
  let actual = fast_diff_text("c", " abb ")
  let expected : Array[(Int32, String)] = [(-1, "c"), (1, " abb ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 64" {
  let actual = fast_diff_text("b. c  .", ".ab")
  let expected : Array[(Int32, String)] = [(-1, "b. c  ."), (1, ".ab")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 65" {
  let actual = fast_diff_text("\n ", "aa")
  let expected : Array[(Int32, String)] = [(-1, "\n "), (1, "aa")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 66" {
  let actual = fast_diff_text("ca \n.cb", "c")
  let expected : Array[(Int32, String)] = [(0, "c"), (-1, "a \n.cb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 67" {
  let actual = fast_diff_text("", " abcca")
  let expected : Array[(Int32, String)] = [(1, " abcca")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 68" {
  let actual = fast_diff_text("c. \n\n", "")
  let expected : Array[(Int32, String)] = [(-1, "c. \n\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 69" {
  let actual = fast_diff_text(" a.", "cb")
  let expected : Array[(Int32, String)] = [(-1, " a."), (1, "cb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 70" {
  let actual = fast_diff_text("c.cc", "b\na")
  let expected : Array[(Int32, String)] = [(-1, "c.cc"), (1, "b\na")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 71" {
  let actual = fast_diff_text(".\n\n", " bc ")
  let expected : Array[(Int32, String)] = [(-1, ".\n\n"), (1, " bc ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 72" {
  let actual = fast_diff_text("cbcc", "")
  let expected : Array[(Int32, String)] = [(-1, "cbcc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 73" {
  let actual = fast_diff_text("c", "cb..")
  let expected : Array[(Int32, String)] = [(0, "c"), (1, "b..")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 74" {
  let actual = fast_diff_text("ab\n", "bbb\nb")
  let expected : Array[(Int32, String)] = [
    (-1, "a"),
    (1, "bb"),
    (0, "b\n"),
    (1, "b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 75" {
  let actual = fast_diff_text(" \n . a", "")
  let expected : Array[(Int32, String)] = [(-1, " \n . a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 76" {
  let actual = fast_diff_text(" ", "bca. a")
  let expected : Array[(Int32, String)] = [(-1, " "), (1, "bca. a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 77" {
  let actual = fast_diff_text("\n\n  \nb\n", "a...\n")
  let expected : Array[(Int32, String)] = [
    (-1, "\n\n  \nb"),
    (1, "a..."),
    (0, "\n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 78" {
  let actual = fast_diff_text("\n \nb c.", "\na b.b")
  let expected : Array[(Int32, String)] = [
    (0, "\n"),
    (-1, " \nb c."),
    (1, "a b.b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 79" {
  let actual = fast_diff_text("b.\n", "")
  let expected : Array[(Int32, String)] = [(-1, "b.\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 80" {
  let actual = fast_diff_text("ca.bc.", ".  ")
  let expected : Array[(Int32, String)] = [(-1, "ca.bc."), (1, ".  ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 81" {
  let actual = fast_diff_text("\na ", " ac")
  let expected : Array[(Int32, String)] = [(-1, "\na "), (1, " ac")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 82" {
  let actual = fast_diff_text(" ", "abb")
  let expected : Array[(Int32, String)] = [(-1, " "), (1, "abb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 83" {
  let actual = fast_diff_text("a", "")
  let expected : Array[(Int32, String)] = [(-1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 84" {
  let actual = fast_diff_text(" \n", "")
  let expected : Array[(Int32, String)] = [(-1, " \n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 85" {
  let actual = fast_diff_text("bcc   ", "c. b ")
  let expected : Array[(Int32, String)] = [(-1, "bcc  "), (1, "c. b"), (0, " ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 86" {
  let actual = fast_diff_text("  cc.", "\n")
  let expected : Array[(Int32, String)] = [(-1, "  cc."), (1, "\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 87" {
  let actual = fast_diff_text("\nb", "b\n ")
  let expected : Array[(Int32, String)] = [(-1, "\n"), (0, "b"), (1, "\n ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 88" {
  let actual = fast_diff_text("a\n\n\n\nb", ".c\nba.b")
  let expected : Array[(Int32, String)] = [
    (-1, "a\n\n\n\n"),
    (1, ".c\nba."),
    (0, "b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 89" {
  let actual = fast_diff_text("\n", ".b b ")
  let expected : Array[(Int32, String)] = [(-1, "\n"), (1, ".b b ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 90" {
  let actual = fast_diff_text("", ".\n")
  let expected : Array[(Int32, String)] = [(1, ".\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 91" {
  let actual = fast_diff_text("\na \n", "c")
  let expected : Array[(Int32, String)] = [(-1, "\na \n"), (1, "c")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 92" {
  let actual = fast_diff_text("b   ", "baa.\na")
  let expected : Array[(Int32, String)] = [(0, "b"), (-1, "   "), (1, "aa.\na")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 93" {
  let actual = fast_diff_text("", "\n.")
  let expected : Array[(Int32, String)] = [(1, "\n.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 94" {
  let actual = fast_diff_text("c.c.b", "  \n")
  let expected : Array[(Int32, String)] = [(-1, "c.c.b"), (1, "  \n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 95" {
  let actual = fast_diff_text("bb \n. b", "\n .\ncc ")
  let expected : Array[(Int32, String)] = [(-1, "bb \n. b"), (1, "\n .\ncc ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 96" {
  let actual = fast_diff_text("a \nabc", "b.a a")
  let expected : Array[(Int32, String)] = [(-1, "a \nabc"), (1, "b.a a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 97" {
  let actual = fast_diff_text("b. \n", "bbb")
  let expected : Array[(Int32, String)] = [(0, "b"), (-1, ". \n"), (1, "bb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 98" {
  let actual = fast_diff_text("c  ", "c\nc")
  let expected : Array[(Int32, String)] = [(0, "c"), (-1, "  "), (1, "\nc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 99" {
  let actual = fast_diff_text(" .\n\nb", "")
  let expected : Array[(Int32, String)] = [(-1, " .\n\nb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 100" {
  let actual = fast_diff_text("\na b ca", " ")
  let expected : Array[(Int32, String)] = [(-1, "\na b ca"), (1, " ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 101" {
  let actual = fast_diff_text("  a.", "\nb")
  let expected : Array[(Int32, String)] = [(-1, "  a."), (1, "\nb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 102" {
  let actual = fast_diff_text(" \n.", "a . ")
  let expected : Array[(Int32, String)] = [(-1, " \n."), (1, "a . ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 103" {
  let actual = fast_diff_text("\nb\n\nc", "c\n.")
  let expected : Array[(Int32, String)] = [(-1, "\nb\n\nc"), (1, "c\n.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 104" {
  let actual = fast_diff_text(" \n", "..")
  let expected : Array[(Int32, String)] = [(-1, " \n"), (1, "..")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 105" {
  let actual = fast_diff_text(".a", "")
  let expected : Array[(Int32, String)] = [(-1, ".a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 106" {
  let actual = fast_diff_text("b\n b.", " .\nc\ncc")
  let expected : Array[(Int32, String)] = [(-1, "b\n b."), (1, " .\nc\ncc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 107" {
  let actual = fast_diff_text(" \n.ab", "b.")
  let expected : Array[(Int32, String)] = [(-1, " \n.a"), (0, "b"), (1, ".")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 108" {
  let actual = fast_diff_text("c.ac a\n", "ba.cc")
  let expected : Array[(Int32, String)] = [(-1, "c.ac a\n"), (1, "ba.cc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 109" {
  let actual = fast_diff_text("ac", " bbc\n")
  let expected : Array[(Int32, String)] = [(-1, "ac"), (1, " bbc\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 110" {
  let actual = fast_diff_text("c", "b b. c.")
  let expected : Array[(Int32, String)] = [(-1, "c"), (1, "b b. c.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 111" {
  let actual = fast_diff_text(".", "")
  let expected : Array[(Int32, String)] = [(-1, ".")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 112" {
  let actual = fast_diff_text(" bca\n c", "a")
  let expected : Array[(Int32, String)] = [(-1, " bca\n c"), (1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 113" {
  let actual = fast_diff_text("bccc\n\n", "aa.bcb")
  let expected : Array[(Int32, String)] = [(-1, "bccc\n\n"), (1, "aa.bcb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 114" {
  let actual = fast_diff_text(" \nb \nc", ".")
  let expected : Array[(Int32, String)] = [(-1, " \nb \nc"), (1, ".")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 115" {
  let actual = fast_diff_text("..bb", ". cac\nb")
  let expected : Array[(Int32, String)] = [
    (0, "."),
    (-1, ".b"),
    (1, " cac\n"),
    (0, "b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 116" {
  let actual = fast_diff_text("a\n", "ca\nb")
  let expected : Array[(Int32, String)] = [(1, "c"), (0, "a\n"), (1, "b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 117" {
  let actual = fast_diff_text("a", "b")
  let expected : Array[(Int32, String)] = [(-1, "a"), (1, "b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 118" {
  let actual = fast_diff_text("b.", "ac\nc")
  let expected : Array[(Int32, String)] = [(-1, "b."), (1, "ac\nc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 119" {
  let actual = fast_diff_text("\nc\nb ca", " a c")
  let expected : Array[(Int32, String)] = [
    (-1, "\nc\nb"),
    (1, " a"),
    (0, " c"),
    (-1, "a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 120" {
  let actual = fast_diff_text("c\nb\nc", "cc\nbb\na")
  let expected : Array[(Int32, String)] = [
    (1, "c"),
    (0, "c\nb"),
    (1, "b"),
    (0, "\n"),
    (-1, "c"),
    (1, "a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 121" {
  let actual = fast_diff_text("ab\n\nb\n", "a ")
  let expected : Array[(Int32, String)] = [(0, "a"), (-1, "b\n\nb\n"), (1, " ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 122" {
  let actual = fast_diff_text("c\nbabb\n", " b.")
  let expected : Array[(Int32, String)] = [(-1, "c\nbabb\n"), (1, " b.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 123" {
  let actual = fast_diff_text("c .\nac", "b\n")
  let expected : Array[(Int32, String)] = [(-1, "c .\nac"), (1, "b\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 124" {
  let actual = fast_diff_text(".", " . aa")
  let expected : Array[(Int32, String)] = [(-1, "."), (1, " . aa")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 125" {
  let actual = fast_diff_text("...a. ", ".b\n bc")
  let expected : Array[(Int32, String)] = [
    (0, "."),
    (-1, "..a. "),
    (1, "b\n bc"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 126" {
  let actual = fast_diff_text("a.\n.\n.", ". c\ncc")
  let expected : Array[(Int32, String)] = [(-1, "a.\n.\n."), (1, ". c\ncc")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 127" {
  let actual = fast_diff_text("b\n.a.cc", "cc. \nc")
  let expected : Array[(Int32, String)] = [
    (-1, "b\n.a.c"),
    (1, "cc. \n"),
    (0, "c"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 128" {
  let actual = fast_diff_text("", "b\na.a")
  let expected : Array[(Int32, String)] = [(1, "b\na.a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 129" {
  let actual = fast_diff_text("ab", "\nba")
  let expected : Array[(Int32, String)] = [(1, "\nb"), (0, "a"), (-1, "b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}

///|
test "fast-diff text oracle 130" {
  let actual = fast_diff_text("\n. \n\nc.", " .bc..c")
  let expected : Array[(Int32, String)] = [(-1, "\n. \n\nc."), (1, " .bc..c")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
}
