///|
/// A small executable that demonstrates document editing and JSON output.
fn main raise {
  let document = @lib.Delta::parse_json(
    "{\"ops\":[{\"insert\":\"Hello world\\n\"}]}",
  )
  let change = @lib.Delta::new()
    .retain_plain(6)
    .delete(5)
    .insert_plain("MoonBit")
  let updated = document.apply(change)
  println(updated.stringify())
}
