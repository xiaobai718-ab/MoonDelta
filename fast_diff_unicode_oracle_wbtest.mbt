///|
test "fast-diff unicode oracle 0" {
  let actual = fast_diff_text("a😀b", "a🚀b")
  let expected : Array[(Int32, String)] = [
    (0, "a"),
    (-1, "😀"),
    (1, "🚀"),
    (0, "b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a😀b")
  let after = Delta::new().insert_plain("a🚀b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 1" {
  let actual = fast_diff_text("😀😀", "😀🚀")
  let expected : Array[(Int32, String)] = [
    (0, "😀"),
    (-1, "😀"),
    (1, "🚀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀😀")
  let after = Delta::new().insert_plain("😀🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 2" {
  let actual = fast_diff_text("x🚀y", "🚀xy")
  let expected : Array[(Int32, String)] = [
    (-1, "x"),
    (0, "🚀"),
    (1, "x"),
    (0, "y"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("x🚀y")
  let after = Delta::new().insert_plain("🚀xy")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 3" {
  let actual = fast_diff_text("猫😀a", "猫🚀b")
  let expected : Array[(Int32, String)] = [
    (0, "猫"),
    (-1, "😀a"),
    (1, "🚀b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫😀a")
  let after = Delta::new().insert_plain("猫🚀b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 4" {
  let actual = fast_diff_text("😀abc", "🚀abc")
  let expected : Array[(Int32, String)] = [
    (-1, "😀"),
    (1, "🚀"),
    (0, "abc"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀abc")
  let after = Delta::new().insert_plain("🚀abc")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 5" {
  let actual = fast_diff_text("a\r\n\r\nb", "a\n\r\nb")
  let expected : Array[(Int32, String)] = [(0, "a"), (-1, "\r"), (0, "\n\r\nb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a\r\n\r\nb")
  let after = Delta::new().insert_plain("a\n\r\nb")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 6" {
  let actual = fast_diff_text("\r\n\nabc", "\n\r\nabc")
  let expected : Array[(Int32, String)] = [
    (-1, "\r"),
    (0, "\n"),
    (1, "\r"),
    (0, "\nabc"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r\n\nabc")
  let after = Delta::new().insert_plain("\n\r\nabc")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 7" {
  let actual = fast_diff_text("🚀", "\nb")
  let expected : Array[(Int32, String)] = [(-1, "🚀"), (1, "\nb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀")
  let after = Delta::new().insert_plain("\nb")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 8" {
  let actual = fast_diff_text("\n\na猫😀a😀", "😀b😀.")
  let expected : Array[(Int32, String)] = [
    (-1, "\n\na猫"),
    (0, "😀"),
    (-1, "a"),
    (1, "b"),
    (0, "😀"),
    (1, "."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n\na猫😀a😀")
  let after = Delta::new().insert_plain("😀b😀.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 9" {
  let actual = fast_diff_text("🚀  \r\r", "😀😀😀\n")
  let expected : Array[(Int32, String)] = [
    (-1, "🚀  \r\r"),
    (1, "😀😀😀\n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀  \r\r")
  let after = Delta::new().insert_plain("😀😀😀\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 10" {
  let actual = fast_diff_text("\raa ", ".😀.a..\n")
  let expected : Array[(Int32, String)] = [(-1, "\raa "), (1, ".😀.a..\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\raa ")
  let after = Delta::new().insert_plain(".😀.a..\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 11" {
  let actual = fast_diff_text(" ", "猫.\raaa")
  let expected : Array[(Int32, String)] = [(-1, " "), (1, "猫.\raaa")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" ")
  let after = Delta::new().insert_plain("猫.\raaa")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 12" {
  let actual = fast_diff_text("\rb😀😀.", " 猫a\r.")
  let expected : Array[(Int32, String)] = [
    (-1, "\rb😀😀"),
    (1, " 猫a\r"),
    (0, "."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\rb😀😀.")
  let after = Delta::new().insert_plain(" 猫a\r.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 13" {
  let actual = fast_diff_text("", ".a🚀")
  let expected : Array[(Int32, String)] = [(1, ".a🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain(".a🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 14" {
  let actual = fast_diff_text("", "\nab")
  let expected : Array[(Int32, String)] = [(1, "\nab")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("\nab")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 15" {
  let actual = fast_diff_text(".猫🚀 \n🚀.", "😀😀\n猫\n\r猫")
  let expected : Array[(Int32, String)] = [
    (-1, ".猫🚀 \n🚀."),
    (1, "😀😀\n猫\n\r猫"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".猫🚀 \n🚀.")
  let after = Delta::new().insert_plain("😀😀\n猫\n\r猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 16" {
  let actual = fast_diff_text("b 猫\n", "\r😀.🚀😀b😀")
  let expected : Array[(Int32, String)] = [
    (-1, "b 猫\n"),
    (1, "\r😀.🚀😀b😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b 猫\n")
  let after = Delta::new().insert_plain("\r😀.🚀😀b😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 17" {
  let actual = fast_diff_text("猫😀\n \r", "a")
  let expected : Array[(Int32, String)] = [(-1, "猫😀\n \r"), (1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫😀\n \r")
  let after = Delta::new().insert_plain("a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 18" {
  let actual = fast_diff_text("", "😀猫a\r猫")
  let expected : Array[(Int32, String)] = [(1, "😀猫a\r猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("😀猫a\r猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 19" {
  let actual = fast_diff_text("\n\n 猫猫", ".\r ")
  let expected : Array[(Int32, String)] = [(-1, "\n\n 猫猫"), (1, ".\r ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n\n 猫猫")
  let after = Delta::new().insert_plain(".\r ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 20" {
  let actual = fast_diff_text("\n", "")
  let expected : Array[(Int32, String)] = [(-1, "\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 21" {
  let actual = fast_diff_text("🚀", "🚀🚀")
  let expected : Array[(Int32, String)] = [(0, "🚀"), (1, "🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀")
  let after = Delta::new().insert_plain("🚀🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 22" {
  let actual = fast_diff_text(".😀🚀\na", "")
  let expected : Array[(Int32, String)] = [(-1, ".😀🚀\na")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".😀🚀\na")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 23" {
  let actual = fast_diff_text(" 猫\n猫🚀", "😀\r\r 🚀.\r")
  let expected : Array[(Int32, String)] = [
    (-1, " 猫\n猫🚀"),
    (1, "😀\r\r 🚀.\r"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" 猫\n猫🚀")
  let after = Delta::new().insert_plain("😀\r\r 🚀.\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 24" {
  let actual = fast_diff_text(".🚀", "😀\n")
  let expected : Array[(Int32, String)] = [(-1, ".🚀"), (1, "😀\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".🚀")
  let after = Delta::new().insert_plain("😀\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 25" {
  let actual = fast_diff_text("\r.猫", "a\r😀a猫b.")
  let expected : Array[(Int32, String)] = [(-1, "\r.猫"), (1, "a\r😀a猫b.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r.猫")
  let after = Delta::new().insert_plain("a\r😀a猫b.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 26" {
  let actual = fast_diff_text("a", "bb\n..猫a")
  let expected : Array[(Int32, String)] = [(1, "bb\n..猫"), (0, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("bb\n..猫a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 27" {
  let actual = fast_diff_text("猫b😀\n. ", "😀\r🚀a.")
  let expected : Array[(Int32, String)] = [
    (-1, "猫b😀\n. "),
    (1, "😀\r🚀a."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫b😀\n. ")
  let after = Delta::new().insert_plain("😀\r🚀a.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 28" {
  let actual = fast_diff_text(" 🚀\n\na猫", "\n\r猫😀.")
  let expected : Array[(Int32, String)] = [
    (-1, " 🚀\n\na猫"),
    (1, "\n\r猫😀."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" 🚀\n\na猫")
  let after = Delta::new().insert_plain("\n\r猫😀.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 29" {
  let actual = fast_diff_text("\n猫", "\rb😀😀aa\r")
  let expected : Array[(Int32, String)] = [
    (-1, "\n猫"),
    (1, "\rb😀😀aa\r"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n猫")
  let after = Delta::new().insert_plain("\rb😀😀aa\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 30" {
  let actual = fast_diff_text("a猫\n", "")
  let expected : Array[(Int32, String)] = [(-1, "a猫\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a猫\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 31" {
  let actual = fast_diff_text("", "\n.")
  let expected : Array[(Int32, String)] = [(1, "\n.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("\n.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 32" {
  let actual = fast_diff_text("b🚀🚀\n🚀猫 ", "😀")
  let expected : Array[(Int32, String)] = [
    (-1, "b🚀🚀\n🚀猫 "),
    (1, "😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b🚀🚀\n🚀猫 ")
  let after = Delta::new().insert_plain("😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 33" {
  let actual = fast_diff_text(".   猫\n\n", "🚀")
  let expected : Array[(Int32, String)] = [(-1, ".   猫\n\n"), (1, "🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".   猫\n\n")
  let after = Delta::new().insert_plain("🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 34" {
  let actual = fast_diff_text("", "ba.😀a😀")
  let expected : Array[(Int32, String)] = [(1, "ba.😀a😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("ba.😀a😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 35" {
  let actual = fast_diff_text("", "a.\rb🚀\na")
  let expected : Array[(Int32, String)] = [(1, "a.\rb🚀\na")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("a.\rb🚀\na")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 36" {
  let actual = fast_diff_text("b .a猫", " 🚀b猫")
  let expected : Array[(Int32, String)] = [
    (-1, "b .a"),
    (1, " 🚀b"),
    (0, "猫"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b .a猫")
  let after = Delta::new().insert_plain(" 🚀b猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 37" {
  let actual = fast_diff_text("", "a\na 🚀")
  let expected : Array[(Int32, String)] = [(1, "a\na 🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("a\na 🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 38" {
  let actual = fast_diff_text(" \n猫.\r ", "b🚀😀\n")
  let expected : Array[(Int32, String)] = [
    (-1, " \n猫.\r "),
    (1, "b🚀😀\n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" \n猫.\r ")
  let after = Delta::new().insert_plain("b🚀😀\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 39" {
  let actual = fast_diff_text("😀", "\n\na")
  let expected : Array[(Int32, String)] = [(-1, "😀"), (1, "\n\na")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀")
  let after = Delta::new().insert_plain("\n\na")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 40" {
  let actual = fast_diff_text("\na", "\n猫🚀 \n😀b")
  let expected : Array[(Int32, String)] = [
    (0, "\n"),
    (-1, "a"),
    (1, "猫🚀 \n😀b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\na")
  let after = Delta::new().insert_plain("\n猫🚀 \n😀b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 41" {
  let actual = fast_diff_text("", "a.bb.🚀")
  let expected : Array[(Int32, String)] = [(1, "a.bb.🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("a.bb.🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 42" {
  let actual = fast_diff_text("", " . ")
  let expected : Array[(Int32, String)] = [(1, " . ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain(" . ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 43" {
  let actual = fast_diff_text("b\na", "\rb\r")
  let expected : Array[(Int32, String)] = [(-1, "b\na"), (1, "\rb\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b\na")
  let after = Delta::new().insert_plain("\rb\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 44" {
  let actual = fast_diff_text(" a", "a\n b\r")
  let expected : Array[(Int32, String)] = [(-1, " "), (0, "a"), (1, "\n b\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" a")
  let after = Delta::new().insert_plain("a\n b\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 45" {
  let actual = fast_diff_text(" 😀猫 .b", " \na猫a")
  let expected : Array[(Int32, String)] = [
    (0, " "),
    (-1, "😀猫 .b"),
    (1, "\na猫a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" 😀猫 .b")
  let after = Delta::new().insert_plain(" \na猫a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 46" {
  let actual = fast_diff_text("😀😀.", "🚀  ")
  let expected : Array[(Int32, String)] = [(-1, "😀😀."), (1, "🚀  ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀😀.")
  let after = Delta::new().insert_plain("🚀  ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 47" {
  let actual = fast_diff_text("a", "")
  let expected : Array[(Int32, String)] = [(-1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 48" {
  let actual = fast_diff_text(".b \n.🚀", ".\nba🚀\n")
  let expected : Array[(Int32, String)] = [
    (0, "."),
    (-1, "b \n."),
    (1, "\nba"),
    (0, "🚀"),
    (1, "\n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".b \n.🚀")
  let after = Delta::new().insert_plain(".\nba🚀\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 49" {
  let actual = fast_diff_text("🚀a \n.ab", "a😀  a\r")
  let expected : Array[(Int32, String)] = [
    (-1, "🚀a \n.ab"),
    (1, "a😀  a\r"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀a \n.ab")
  let after = Delta::new().insert_plain("a😀  a\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 50" {
  let actual = fast_diff_text("..\rb\rb", ".")
  let expected : Array[(Int32, String)] = [(0, "."), (-1, ".\rb\rb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("..\rb\rb")
  let after = Delta::new().insert_plain(".")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 51" {
  let actual = fast_diff_text(" .\r猫 ", "")
  let expected : Array[(Int32, String)] = [(-1, " .\r猫 ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" .\r猫 ")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 52" {
  let actual = fast_diff_text("\r😀aa", "🚀b b.a")
  let expected : Array[(Int32, String)] = [
    (-1, "\r😀a"),
    (1, "🚀b b."),
    (0, "a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r😀aa")
  let after = Delta::new().insert_plain("🚀b b.a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 53" {
  let actual = fast_diff_text("ba🚀", "b\r.a aa")
  let expected : Array[(Int32, String)] = [
    (0, "b"),
    (-1, "a🚀"),
    (1, "\r.a aa"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("ba🚀")
  let after = Delta::new().insert_plain("b\r.a aa")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 54" {
  let actual = fast_diff_text("a🚀 🚀\n", "\r")
  let expected : Array[(Int32, String)] = [(-1, "a🚀 🚀\n"), (1, "\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a🚀 🚀\n")
  let after = Delta::new().insert_plain("\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 55" {
  let actual = fast_diff_text("b 🚀😀 😀a", "")
  let expected : Array[(Int32, String)] = [(-1, "b 🚀😀 😀a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b 🚀😀 😀a")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 56" {
  let actual = fast_diff_text("b🚀", " \n.")
  let expected : Array[(Int32, String)] = [(-1, "b🚀"), (1, " \n.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b🚀")
  let after = Delta::new().insert_plain(" \n.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 57" {
  let actual = fast_diff_text("😀🚀", "猫b")
  let expected : Array[(Int32, String)] = [(-1, "😀🚀"), (1, "猫b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀🚀")
  let after = Delta::new().insert_plain("猫b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 58" {
  let actual = fast_diff_text(" \n猫猫. ", " 🚀b")
  let expected : Array[(Int32, String)] = [
    (0, " "),
    (-1, "\n猫猫. "),
    (1, "🚀b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" \n猫猫. ")
  let after = Delta::new().insert_plain(" 🚀b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 59" {
  let actual = fast_diff_text("🚀", "")
  let expected : Array[(Int32, String)] = [(-1, "🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 60" {
  let actual = fast_diff_text(" \n猫🚀\n😀", "")
  let expected : Array[(Int32, String)] = [(-1, " \n猫🚀\n😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" \n猫🚀\n😀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 61" {
  let actual = fast_diff_text("", "\n")
  let expected : Array[(Int32, String)] = [(1, "\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 62" {
  let actual = fast_diff_text("😀猫.😀🚀", "\n. ")
  let expected : Array[(Int32, String)] = [
    (-1, "😀猫.😀🚀"),
    (1, "\n. "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀猫.😀🚀")
  let after = Delta::new().insert_plain("\n. ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 63" {
  let actual = fast_diff_text("b\r猫.🚀 ", "猫b")
  let expected : Array[(Int32, String)] = [
    (1, "猫"),
    (0, "b"),
    (-1, "\r猫.🚀 "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b\r猫.🚀 ")
  let after = Delta::new().insert_plain("猫b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 64" {
  let actual = fast_diff_text("猫猫\n\n", "")
  let expected : Array[(Int32, String)] = [(-1, "猫猫\n\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫猫\n\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 65" {
  let actual = fast_diff_text("\n.ba.😀", "🚀🚀😀aa\n🚀")
  let expected : Array[(Int32, String)] = [
    (-1, "\n.ba.😀"),
    (1, "🚀🚀😀aa\n🚀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n.ba.😀")
  let after = Delta::new().insert_plain("🚀🚀😀aa\n🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 66" {
  let actual = fast_diff_text("a🚀猫\n\n\n", "😀aa🚀\r")
  let expected : Array[(Int32, String)] = [
    (-1, "a🚀猫\n\n\n"),
    (1, "😀aa🚀\r"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a🚀猫\n\n\n")
  let after = Delta::new().insert_plain("😀aa🚀\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 67" {
  let actual = fast_diff_text("\r😀. 🚀a.", "猫\r.  \n")
  let expected : Array[(Int32, String)] = [
    (-1, "\r😀. 🚀a."),
    (1, "猫\r.  \n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r😀. 🚀a.")
  let after = Delta::new().insert_plain("猫\r.  \n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 68" {
  let actual = fast_diff_text(" a😀", "a \r😀 😀")
  let expected : Array[(Int32, String)] = [
    (-1, " "),
    (0, "a"),
    (1, " \r😀 "),
    (0, "😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" a😀")
  let after = Delta::new().insert_plain("a \r😀 😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 69" {
  let actual = fast_diff_text("🚀 \n ", "猫 .🚀😀")
  let expected : Array[(Int32, String)] = [
    (-1, "🚀 \n "),
    (1, "猫 .🚀😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀 \n ")
  let after = Delta::new().insert_plain("猫 .🚀😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 70" {
  let actual = fast_diff_text("🚀b", "\n😀 a\rb")
  let expected : Array[(Int32, String)] = [
    (-1, "🚀"),
    (1, "\n😀 a\r"),
    (0, "b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀b")
  let after = Delta::new().insert_plain("\n😀 a\rb")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 71" {
  let actual = fast_diff_text("😀a 🚀a😀", "🚀a.猫😀.")
  let expected : Array[(Int32, String)] = [
    (-1, "😀a "),
    (0, "🚀a"),
    (1, ".猫"),
    (0, "😀"),
    (1, "."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀a 🚀a😀")
  let after = Delta::new().insert_plain("🚀a.猫😀.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 72" {
  let actual = fast_diff_text("😀.\n 😀", ".猫\r\r.😀\n")
  let expected : Array[(Int32, String)] = [
    (-1, "😀.\n 😀"),
    (1, ".猫\r\r.😀\n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀.\n 😀")
  let after = Delta::new().insert_plain(".猫\r\r.😀\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 73" {
  let actual = fast_diff_text("🚀", "a😀猫")
  let expected : Array[(Int32, String)] = [(-1, "🚀"), (1, "a😀猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀")
  let after = Delta::new().insert_plain("a😀猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 74" {
  let actual = fast_diff_text(".😀", "\na 😀a\r\n")
  let expected : Array[(Int32, String)] = [(-1, ".😀"), (1, "\na 😀a\r\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".😀")
  let after = Delta::new().insert_plain("\na 😀a\r\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 75" {
  let actual = fast_diff_text(" 😀\nb ", "")
  let expected : Array[(Int32, String)] = [(-1, " 😀\nb ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" 😀\nb ")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 76" {
  let actual = fast_diff_text("\r😀 ", "\ra🚀\n\r")
  let expected : Array[(Int32, String)] = [
    (0, "\r"),
    (-1, "😀 "),
    (1, "a🚀\n\r"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r😀 ")
  let after = Delta::new().insert_plain("\ra🚀\n\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 77" {
  let actual = fast_diff_text("b😀🚀", " \n")
  let expected : Array[(Int32, String)] = [(-1, "b😀🚀"), (1, " \n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b😀🚀")
  let after = Delta::new().insert_plain(" \n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 78" {
  let actual = fast_diff_text(" .\n .\r", "猫a猫a猫")
  let expected : Array[(Int32, String)] = [(-1, " .\n .\r"), (1, "猫a猫a猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" .\n .\r")
  let after = Delta::new().insert_plain("猫a猫a猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 79" {
  let actual = fast_diff_text("😀", "\r")
  let expected : Array[(Int32, String)] = [(-1, "😀"), (1, "\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀")
  let after = Delta::new().insert_plain("\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 80" {
  let actual = fast_diff_text("猫\r🚀b猫.", "猫 😀")
  let expected : Array[(Int32, String)] = [
    (0, "猫"),
    (-1, "\r🚀b猫."),
    (1, " 😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫\r🚀b猫.")
  let after = Delta::new().insert_plain("猫 😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 81" {
  let actual = fast_diff_text("b😀.猫😀a", "")
  let expected : Array[(Int32, String)] = [(-1, "b😀.猫😀a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b😀.猫😀a")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 82" {
  let actual = fast_diff_text("b\n猫a .", ".😀 \r")
  let expected : Array[(Int32, String)] = [(-1, "b\n猫a ."), (1, ".😀 \r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b\n猫a .")
  let after = Delta::new().insert_plain(".😀 \r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 83" {
  let actual = fast_diff_text("b", "")
  let expected : Array[(Int32, String)] = [(-1, "b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 84" {
  let actual = fast_diff_text("🚀\n猫猫😀", "\rb猫b..😀")
  let expected : Array[(Int32, String)] = [
    (-1, "🚀\n猫猫"),
    (1, "\rb猫b.."),
    (0, "😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀\n猫猫😀")
  let after = Delta::new().insert_plain("\rb猫b..😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 85" {
  let actual = fast_diff_text("猫. 😀", "\nbb\r猫")
  let expected : Array[(Int32, String)] = [(-1, "猫. 😀"), (1, "\nbb\r猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫. 😀")
  let after = Delta::new().insert_plain("\nbb\r猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 86" {
  let actual = fast_diff_text("\r.\n", "🚀 \na🚀b")
  let expected : Array[(Int32, String)] = [(-1, "\r.\n"), (1, "🚀 \na🚀b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r.\n")
  let after = Delta::new().insert_plain("🚀 \na🚀b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 87" {
  let actual = fast_diff_text("😀", "")
  let expected : Array[(Int32, String)] = [(-1, "😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 88" {
  let actual = fast_diff_text(" \r\n \r", "b😀\n")
  let expected : Array[(Int32, String)] = [(-1, " \r\n \r"), (1, "b😀\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" \r\n \r")
  let after = Delta::new().insert_plain("b😀\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 89" {
  let actual = fast_diff_text(" 😀\n", "")
  let expected : Array[(Int32, String)] = [(-1, " 😀\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" 😀\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 90" {
  let actual = fast_diff_text("猫😀", "猫b \r猫😀 ")
  let expected : Array[(Int32, String)] = [
    (1, "猫b \r"),
    (0, "猫😀"),
    (1, " "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫😀")
  let after = Delta::new().insert_plain("猫b \r猫😀 ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 91" {
  let actual = fast_diff_text("a.\n", "")
  let expected : Array[(Int32, String)] = [(-1, "a.\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a.\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 92" {
  let actual = fast_diff_text(" .\n😀", "🚀.猫🚀")
  let expected : Array[(Int32, String)] = [
    (-1, " .\n😀"),
    (1, "🚀.猫🚀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" .\n😀")
  let after = Delta::new().insert_plain("🚀.猫🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 93" {
  let actual = fast_diff_text("\nb.b", "")
  let expected : Array[(Int32, String)] = [(-1, "\nb.b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\nb.b")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 94" {
  let actual = fast_diff_text("", "猫\ra\na\r")
  let expected : Array[(Int32, String)] = [(1, "猫\ra\na\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("猫\ra\na\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 95" {
  let actual = fast_diff_text("\naa😀b\r", "\na ")
  let expected : Array[(Int32, String)] = [
    (0, "\na"),
    (-1, "a😀b\r"),
    (1, " "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\naa😀b\r")
  let after = Delta::new().insert_plain("\na ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 96" {
  let actual = fast_diff_text("", ".😀\r😀a\r")
  let expected : Array[(Int32, String)] = [(1, ".😀\r😀a\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain(".😀\r😀a\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 97" {
  let actual = fast_diff_text(" ", "a\n")
  let expected : Array[(Int32, String)] = [(-1, " "), (1, "a\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" ")
  let after = Delta::new().insert_plain("a\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 98" {
  let actual = fast_diff_text("猫🚀猫😀b\n猫", " 😀 \rb😀 ")
  let expected : Array[(Int32, String)] = [
    (-1, "猫🚀猫😀b\n猫"),
    (1, " 😀 \rb😀 "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫🚀猫😀b\n猫")
  let after = Delta::new().insert_plain(" 😀 \rb😀 ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 99" {
  let actual = fast_diff_text("😀", "猫\n猫.😀🚀 ")
  let expected : Array[(Int32, String)] = [
    (-1, "😀"),
    (1, "猫\n猫.😀🚀 "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀")
  let after = Delta::new().insert_plain("猫\n猫.😀🚀 ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 100" {
  let actual = fast_diff_text("猫\n猫b", "\na\r\r😀 a")
  let expected : Array[(Int32, String)] = [
    (-1, "猫\n猫b"),
    (1, "\na\r\r😀 a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫\n猫b")
  let after = Delta::new().insert_plain("\na\r\r😀 a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 101" {
  let actual = fast_diff_text(" 🚀 \r🚀", "")
  let expected : Array[(Int32, String)] = [(-1, " 🚀 \r🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" 🚀 \r🚀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 102" {
  let actual = fast_diff_text("\nba   \n", "🚀😀\r ")
  let expected : Array[(Int32, String)] = [
    (-1, "\nba   \n"),
    (1, "🚀😀\r "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\nba   \n")
  let after = Delta::new().insert_plain("🚀😀\r ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 103" {
  let actual = fast_diff_text("b😀ab", "b\na")
  let expected : Array[(Int32, String)] = [(0, "b"), (-1, "😀ab"), (1, "\na")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b😀ab")
  let after = Delta::new().insert_plain("b\na")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 104" {
  let actual = fast_diff_text("ba猫", "\r")
  let expected : Array[(Int32, String)] = [(-1, "ba猫"), (1, "\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("ba猫")
  let after = Delta::new().insert_plain("\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 105" {
  let actual = fast_diff_text("a", " 😀a猫.")
  let expected : Array[(Int32, String)] = [(-1, "a"), (1, " 😀a猫.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain(" 😀a猫.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 106" {
  let actual = fast_diff_text("🚀", "\n🚀")
  let expected : Array[(Int32, String)] = [(1, "\n"), (0, "🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀")
  let after = Delta::new().insert_plain("\n🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 107" {
  let actual = fast_diff_text(".", "b猫\r\r")
  let expected : Array[(Int32, String)] = [(-1, "."), (1, "b猫\r\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".")
  let after = Delta::new().insert_plain("b猫\r\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 108" {
  let actual = fast_diff_text("b\n\n", "")
  let expected : Array[(Int32, String)] = [(-1, "b\n\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b\n\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 109" {
  let actual = fast_diff_text(" 猫.🚀\n \n", " \n.  a")
  let expected : Array[(Int32, String)] = [
    (0, " "),
    (-1, "猫.🚀\n \n"),
    (1, "\n.  a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" 猫.🚀\n \n")
  let after = Delta::new().insert_plain(" \n.  a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 110" {
  let actual = fast_diff_text(" bb", "\nba")
  let expected : Array[(Int32, String)] = [(-1, " bb"), (1, "\nba")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" bb")
  let after = Delta::new().insert_plain("\nba")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 111" {
  let actual = fast_diff_text("😀猫🚀 b", "😀\nb 猫🚀 ")
  let expected : Array[(Int32, String)] = [
    (0, "😀"),
    (1, "\nb "),
    (0, "猫🚀 "),
    (-1, "b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀猫🚀 b")
  let after = Delta::new().insert_plain("😀\nb 猫🚀 ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 112" {
  let actual = fast_diff_text("", ".a\na")
  let expected : Array[(Int32, String)] = [(1, ".a\na")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain(".a\na")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 113" {
  let actual = fast_diff_text(" \n", " 猫😀")
  let expected : Array[(Int32, String)] = [(0, " "), (-1, "\n"), (1, "猫😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" \n")
  let after = Delta::new().insert_plain(" 猫😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 114" {
  let actual = fast_diff_text("\rb😀a", "猫")
  let expected : Array[(Int32, String)] = [(-1, "\rb😀a"), (1, "猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\rb😀a")
  let after = Delta::new().insert_plain("猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 115" {
  let actual = fast_diff_text("猫.🚀", "")
  let expected : Array[(Int32, String)] = [(-1, "猫.🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫.🚀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 116" {
  let actual = fast_diff_text("猫猫b\n", "b🚀 \n. ")
  let expected : Array[(Int32, String)] = [(-1, "猫猫b\n"), (1, "b🚀 \n. ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫猫b\n")
  let after = Delta::new().insert_plain("b🚀 \n. ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 117" {
  let actual = fast_diff_text("\na\r😀a😀", "ab😀\r")
  let expected : Array[(Int32, String)] = [
    (-1, "\na\r😀a😀"),
    (1, "ab😀\r"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\na\r😀a😀")
  let after = Delta::new().insert_plain("ab😀\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 118" {
  let actual = fast_diff_text("", "😀猫😀.🚀猫.")
  let expected : Array[(Int32, String)] = [(1, "😀猫😀.🚀猫.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("😀猫😀.🚀猫.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 119" {
  let actual = fast_diff_text("b\nab", "😀猫😀b\r猫")
  let expected : Array[(Int32, String)] = [
    (-1, "b\nab"),
    (1, "😀猫😀b\r猫"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b\nab")
  let after = Delta::new().insert_plain("😀猫😀b\r猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 120" {
  let actual = fast_diff_text("\r\r猫🚀b", "😀")
  let expected : Array[(Int32, String)] = [(-1, "\r\r猫🚀b"), (1, "😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r\r猫🚀b")
  let after = Delta::new().insert_plain("😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 121" {
  let actual = fast_diff_text("a", ".")
  let expected : Array[(Int32, String)] = [(-1, "a"), (1, ".")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a")
  let after = Delta::new().insert_plain(".")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 122" {
  let actual = fast_diff_text("ba🚀\n\n", "")
  let expected : Array[(Int32, String)] = [(-1, "ba🚀\n\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("ba🚀\n\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 123" {
  let actual = fast_diff_text("🚀a ", ".😀aa🚀ab")
  let expected : Array[(Int32, String)] = [
    (1, ".😀aa"),
    (0, "🚀a"),
    (-1, " "),
    (1, "b"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀a ")
  let after = Delta::new().insert_plain(".😀aa🚀ab")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 124" {
  let actual = fast_diff_text("🚀.猫 .", "a")
  let expected : Array[(Int32, String)] = [(-1, "🚀.猫 ."), (1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀.猫 .")
  let after = Delta::new().insert_plain("a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 125" {
  let actual = fast_diff_text("b🚀. a🚀", ".b")
  let expected : Array[(Int32, String)] = [
    (1, "."),
    (0, "b"),
    (-1, "🚀. a🚀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b🚀. a🚀")
  let after = Delta::new().insert_plain(".b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 126" {
  let actual = fast_diff_text("a\r\n", "🚀")
  let expected : Array[(Int32, String)] = [(-1, "a\r\n"), (1, "🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a\r\n")
  let after = Delta::new().insert_plain("🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 127" {
  let actual = fast_diff_text("🚀", "\r猫.\n")
  let expected : Array[(Int32, String)] = [(-1, "🚀"), (1, "\r猫.\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀")
  let after = Delta::new().insert_plain("\r猫.\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 128" {
  let actual = fast_diff_text("", "   .🚀.🚀")
  let expected : Array[(Int32, String)] = [(1, "   .🚀.🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("   .🚀.🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 129" {
  let actual = fast_diff_text("\r", "猫🚀")
  let expected : Array[(Int32, String)] = [(-1, "\r"), (1, "猫🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r")
  let after = Delta::new().insert_plain("猫🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 130" {
  let actual = fast_diff_text("\n 🚀😀", "🚀a \n")
  let expected : Array[(Int32, String)] = [(-1, "\n 🚀😀"), (1, "🚀a \n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n 🚀😀")
  let after = Delta::new().insert_plain("🚀a \n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 131" {
  let actual = fast_diff_text("", "\r\r 😀\r\n")
  let expected : Array[(Int32, String)] = [(1, "\r\r 😀\r\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("\r\r 😀\r\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 132" {
  let actual = fast_diff_text("🚀猫猫a\n", "b")
  let expected : Array[(Int32, String)] = [(-1, "🚀猫猫a\n"), (1, "b")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀猫猫a\n")
  let after = Delta::new().insert_plain("b")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 133" {
  let actual = fast_diff_text("\n", "😀🚀猫😀🚀🚀\r")
  let expected : Array[(Int32, String)] = [
    (-1, "\n"),
    (1, "😀🚀猫😀🚀🚀\r"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n")
  let after = Delta::new().insert_plain("😀🚀猫😀🚀🚀\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 134" {
  let actual = fast_diff_text("b a.猫", " b\n ")
  let expected : Array[(Int32, String)] = [(-1, "b a.猫"), (1, " b\n ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b a.猫")
  let after = Delta::new().insert_plain(" b\n ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 135" {
  let actual = fast_diff_text(".abb.", "\n🚀\r")
  let expected : Array[(Int32, String)] = [(-1, ".abb."), (1, "\n🚀\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".abb.")
  let after = Delta::new().insert_plain("\n🚀\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 136" {
  let actual = fast_diff_text("a  b.ba", "a猫🚀")
  let expected : Array[(Int32, String)] = [
    (0, "a"),
    (-1, "  b.ba"),
    (1, "猫🚀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a  b.ba")
  let after = Delta::new().insert_plain("a猫🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 137" {
  let actual = fast_diff_text("\r 猫🚀猫\n", " 猫\rb\n\n")
  let expected : Array[(Int32, String)] = [
    (-1, "\r"),
    (0, " 猫"),
    (-1, "🚀猫"),
    (1, "\rb\n"),
    (0, "\n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r 猫🚀猫\n")
  let after = Delta::new().insert_plain(" 猫\rb\n\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 138" {
  let actual = fast_diff_text("", "\r\r\nb")
  let expected : Array[(Int32, String)] = [(1, "\r\r\nb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("\r\r\nb")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 139" {
  let actual = fast_diff_text("猫", "😀. 😀 😀")
  let expected : Array[(Int32, String)] = [(-1, "猫"), (1, "😀. 😀 😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫")
  let after = Delta::new().insert_plain("😀. 😀 😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 140" {
  let actual = fast_diff_text(" bb\r\nb", ". 🚀 .猫")
  let expected : Array[(Int32, String)] = [(-1, " bb\r\nb"), (1, ". 🚀 .猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" bb\r\nb")
  let after = Delta::new().insert_plain(". 🚀 .猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 141" {
  let actual = fast_diff_text("b\r.b🚀b\r", "ba🚀 \r.")
  let expected : Array[(Int32, String)] = [
    (0, "b"),
    (-1, "\r.b🚀b\r"),
    (1, "a🚀 \r."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b\r.b🚀b\r")
  let after = Delta::new().insert_plain("ba🚀 \r.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 142" {
  let actual = fast_diff_text(".🚀 .\r\r", "a😀")
  let expected : Array[(Int32, String)] = [(-1, ".🚀 .\r\r"), (1, "a😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".🚀 .\r\r")
  let after = Delta::new().insert_plain("a😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 143" {
  let actual = fast_diff_text(" 🚀ba\nb", "🚀😀")
  let expected : Array[(Int32, String)] = [
    (-1, " "),
    (0, "🚀"),
    (-1, "ba\nb"),
    (1, "😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" 🚀ba\nb")
  let after = Delta::new().insert_plain("🚀😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 144" {
  let actual = fast_diff_text("b猫b猫\n\nb", "😀🚀🚀🚀")
  let expected : Array[(Int32, String)] = [
    (-1, "b猫b猫\n\nb"),
    (1, "😀🚀🚀🚀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b猫b猫\n\nb")
  let after = Delta::new().insert_plain("😀🚀🚀🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 145" {
  let actual = fast_diff_text("a.a\n猫", ".猫猫\n ")
  let expected : Array[(Int32, String)] = [(-1, "a.a\n猫"), (1, ".猫猫\n ")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a.a\n猫")
  let after = Delta::new().insert_plain(".猫猫\n ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 146" {
  let actual = fast_diff_text("🚀\r😀a", "a \r.b😀")
  let expected : Array[(Int32, String)] = [
    (-1, "🚀\r"),
    (1, "a \r.b"),
    (0, "😀"),
    (-1, "a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀\r😀a")
  let after = Delta::new().insert_plain("a \r.b😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 147" {
  let actual = fast_diff_text("", "\raa")
  let expected : Array[(Int32, String)] = [(1, "\raa")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("\raa")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 148" {
  let actual = fast_diff_text(".", "\n.\rab猫")
  let expected : Array[(Int32, String)] = [(-1, "."), (1, "\n.\rab猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".")
  let after = Delta::new().insert_plain("\n.\rab猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 149" {
  let actual = fast_diff_text("😀 🚀", "")
  let expected : Array[(Int32, String)] = [(-1, "😀 🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀 🚀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 150" {
  let actual = fast_diff_text("", "\r😀")
  let expected : Array[(Int32, String)] = [(1, "\r😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("\r😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 151" {
  let actual = fast_diff_text("\r🚀 猫 \r", "\r\r猫😀  ")
  let expected : Array[(Int32, String)] = [
    (0, "\r"),
    (-1, "🚀 猫 \r"),
    (1, "\r猫😀  "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r🚀 猫 \r")
  let after = Delta::new().insert_plain("\r\r猫😀  ")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 152" {
  let actual = fast_diff_text("猫.aa🚀\r", "ab\rb\r\n😀")
  let expected : Array[(Int32, String)] = [
    (-1, "猫.aa🚀\r"),
    (1, "ab\rb\r\n😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫.aa🚀\r")
  let after = Delta::new().insert_plain("ab\rb\r\n😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 153" {
  let actual = fast_diff_text("🚀😀", "")
  let expected : Array[(Int32, String)] = [(-1, "🚀😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀😀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 154" {
  let actual = fast_diff_text("b\rbb", "ba😀")
  let expected : Array[(Int32, String)] = [(0, "b"), (-1, "\rbb"), (1, "a😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b\rbb")
  let after = Delta::new().insert_plain("ba😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 155" {
  let actual = fast_diff_text("猫", ".😀🚀babb")
  let expected : Array[(Int32, String)] = [(-1, "猫"), (1, ".😀🚀babb")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫")
  let after = Delta::new().insert_plain(".😀🚀babb")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 156" {
  let actual = fast_diff_text("\n \n \n\n", "")
  let expected : Array[(Int32, String)] = [(-1, "\n \n \n\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n \n \n\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 157" {
  let actual = fast_diff_text("a🚀  😀\ra", "")
  let expected : Array[(Int32, String)] = [(-1, "a🚀  😀\ra")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a🚀  😀\ra")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 158" {
  let actual = fast_diff_text("b.\n\r.", "a")
  let expected : Array[(Int32, String)] = [(-1, "b.\n\r."), (1, "a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b.\n\r.")
  let after = Delta::new().insert_plain("a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 159" {
  let actual = fast_diff_text("\r\n", " b\r🚀a.")
  let expected : Array[(Int32, String)] = [(-1, "\r\n"), (1, " b\r🚀a.")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r\n")
  let after = Delta::new().insert_plain(" b\r🚀a.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 160" {
  let actual = fast_diff_text("", "🚀")
  let expected : Array[(Int32, String)] = [(1, "🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 161" {
  let actual = fast_diff_text(" ", "\ra")
  let expected : Array[(Int32, String)] = [(-1, " "), (1, "\ra")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" ")
  let after = Delta::new().insert_plain("\ra")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 162" {
  let actual = fast_diff_text(" a🚀\n🚀😀\n", "")
  let expected : Array[(Int32, String)] = [(-1, " a🚀\n🚀😀\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" a🚀\n🚀😀\n")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 163" {
  let actual = fast_diff_text("a猫\n 猫b\n", ".🚀😀")
  let expected : Array[(Int32, String)] = [
    (-1, "a猫\n 猫b\n"),
    (1, ".🚀😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a猫\n 猫b\n")
  let after = Delta::new().insert_plain(".🚀😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 164" {
  let actual = fast_diff_text("😀b猫", "")
  let expected : Array[(Int32, String)] = [(-1, "😀b猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀b猫")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 165" {
  let actual = fast_diff_text(".😀", "")
  let expected : Array[(Int32, String)] = [(-1, ".😀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(".😀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 166" {
  let actual = fast_diff_text("a\r", "\r\r🚀\rb🚀")
  let expected : Array[(Int32, String)] = [
    (-1, "a"),
    (0, "\r"),
    (1, "\r🚀\rb🚀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a\r")
  let after = Delta::new().insert_plain("\r\r🚀\rb🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 167" {
  let actual = fast_diff_text("a猫\r a", "b\na\n.a")
  let expected : Array[(Int32, String)] = [
    (-1, "a猫\r "),
    (1, "b\na\n."),
    (0, "a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a猫\r a")
  let after = Delta::new().insert_plain("b\na\n.a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 168" {
  let actual = fast_diff_text("a \ra.", ".\ra \r\n")
  let expected : Array[(Int32, String)] = [
    (1, ".\r"),
    (0, "a \r"),
    (-1, "a."),
    (1, "\n"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("a \ra.")
  let after = Delta::new().insert_plain(".\ra \r\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 169" {
  let actual = fast_diff_text("b🚀 ", "\rb猫🚀")
  let expected : Array[(Int32, String)] = [
    (-1, "b"),
    (1, "\rb猫"),
    (0, "🚀"),
    (-1, " "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("b🚀 ")
  let after = Delta::new().insert_plain("\rb猫🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 170" {
  let actual = fast_diff_text("\r", "")
  let expected : Array[(Int32, String)] = [(-1, "\r")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 171" {
  let actual = fast_diff_text("\r🚀猫猫", "😀.\raa")
  let expected : Array[(Int32, String)] = [
    (-1, "\r🚀猫猫"),
    (1, "😀.\raa"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r🚀猫猫")
  let after = Delta::new().insert_plain("😀.\raa")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 172" {
  let actual = fast_diff_text("bb", "\r \r🚀🚀")
  let expected : Array[(Int32, String)] = [(-1, "bb"), (1, "\r \r🚀🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("bb")
  let after = Delta::new().insert_plain("\r \r🚀🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 173" {
  let actual = fast_diff_text("\r😀\na🚀", "")
  let expected : Array[(Int32, String)] = [(-1, "\r😀\na🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\r😀\na🚀")
  let after = Delta::new().insert_plain("")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 174" {
  let actual = fast_diff_text("", "\r 🚀")
  let expected : Array[(Int32, String)] = [(1, "\r 🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("")
  let after = Delta::new().insert_plain("\r 🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 175" {
  let actual = fast_diff_text(" \n🚀", "\n.ab\n")
  let expected : Array[(Int32, String)] = [(-1, " \n🚀"), (1, "\n.ab\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" \n🚀")
  let after = Delta::new().insert_plain("\n.ab\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 176" {
  let actual = fast_diff_text("猫b", "b\n")
  let expected : Array[(Int32, String)] = [(-1, "猫"), (0, "b"), (1, "\n")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫b")
  let after = Delta::new().insert_plain("b\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 177" {
  let actual = fast_diff_text("ba😀\ra", "😀.\rb猫.")
  let expected : Array[(Int32, String)] = [
    (-1, "ba😀\ra"),
    (1, "😀.\rb猫."),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("ba😀\ra")
  let after = Delta::new().insert_plain("😀.\rb猫.")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 178" {
  let actual = fast_diff_text("猫\na\nb", "😀a")
  let expected : Array[(Int32, String)] = [(-1, "猫\na\nb"), (1, "😀a")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("猫\na\nb")
  let after = Delta::new().insert_plain("😀a")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 179" {
  let actual = fast_diff_text("🚀", "猫🚀\r..")
  let expected : Array[(Int32, String)] = [(1, "猫"), (0, "🚀"), (1, "\r..")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("🚀")
  let after = Delta::new().insert_plain("猫🚀\r..")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 180" {
  let actual = fast_diff_text("\rb 🚀\r\na", "\r\n")
  let expected : Array[(Int32, String)] = [
    (-1, "\rb 🚀"),
    (0, "\r\n"),
    (-1, "a"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\rb 🚀\r\na")
  let after = Delta::new().insert_plain("\r\n")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 181" {
  let actual = fast_diff_text(" \rb🚀", "🚀")
  let expected : Array[(Int32, String)] = [(-1, " \rb"), (0, "🚀")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(" \rb🚀")
  let after = Delta::new().insert_plain("🚀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 182" {
  let actual = fast_diff_text("\n猫 .", "ab 🚀😀.\r")
  let expected : Array[(Int32, String)] = [
    (-1, "\n猫 ."),
    (1, "ab 🚀😀.\r"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n猫 .")
  let after = Delta::new().insert_plain("ab 🚀😀.\r")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 183" {
  let actual = fast_diff_text(". 😀🚀🚀\r\r", "\naa😀")
  let expected : Array[(Int32, String)] = [
    (-1, ". 😀🚀🚀\r\r"),
    (1, "\naa😀"),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain(". 😀🚀🚀\r\r")
  let after = Delta::new().insert_plain("\naa😀")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 184" {
  let actual = fast_diff_text("\n😀.a🚀", "a猫")
  let expected : Array[(Int32, String)] = [(-1, "\n😀.a🚀"), (1, "a猫")]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("\n😀.a🚀")
  let after = Delta::new().insert_plain("a猫")
  assert_eq(before.apply(before.diff(after)), after)
}

///|
test "fast-diff unicode oracle 185" {
  let actual = fast_diff_text("😀 .b\r\r", "🚀猫\n😀.. ")
  let expected : Array[(Int32, String)] = [
    (-1, "😀 .b\r\r"),
    (1, "🚀猫\n😀.. "),
  ]
  assert_eq(actual.length(), expected.length())
  for index, item in expected {
    let (kind, text) = item
    assert_eq(actual[index].kind, kind)
    assert_eq(actual[index].text, text)
  }
  let before = Delta::new().insert_plain("😀 .b\r\r")
  let after = Delta::new().insert_plain("🚀猫\n😀.. ")
  assert_eq(before.apply(before.diff(after)), after)
}
