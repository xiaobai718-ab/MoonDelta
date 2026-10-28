///|
/// Clone mutable JSON arrays and maps so a pushed operation cannot be changed
/// later through the caller's references.
fn clone_json(value : Json) -> Json {
  match value {
    Array(items) => {
      let copy : Array[Json] = []
      for item in items {
        copy.push(clone_json(item))
      }
      Json::array(copy)
    }
    Object(fields) => {
      let copy : Map[String, Json] = Map([])
      for key, item in fields {
        copy.set(key, clone_json(item))
      }
      Json::object(copy)
    }
    _ => value
  }
}

///|
fn clone_op(op : Op) -> Op {
  match op {
    InsertText(text, attrs) => InsertText(text, clone_json(attrs))
    InsertEmbed(embed, attrs) => InsertEmbed(clone_json(embed), clone_json(attrs))
    Retain(length, attrs) => Retain(length, clone_json(attrs))
    RetainEmbed(embed, attrs) => RetainEmbed(clone_json(embed), clone_json(attrs))
    Delete(length) => Delete(length)
  }
}
