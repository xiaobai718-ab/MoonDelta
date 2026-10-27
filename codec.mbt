///|
/// Parse a Quill Delta JSON object or its bare operations array.
pub fn Delta::parse_json(source : String) -> Delta raise DeltaError {
  let value = @json.parse(source) catch { _ => raise Invalid("Invalid JSON") }
  Delta::from_json(value)
}

///|
pub fn Delta::from_json(value : Json) -> Delta raise DeltaError {
  let operations = match value {
    Array(items) => items
    Object(fields) =>
      match fields.get("ops") {
        Some(Array(items)) => items
        _ => raise Invalid("$.ops must be an array")
      }
    _ => raise Invalid("Delta must be an object or operations array")
  }
  let result = Delta::new()
  let mut total : Int64 = 0L
  for index, item in operations {
    let path = "$.ops[" + index.to_string() + "]"
    let fields = match item {
      Object(map) => map
      _ => raise Invalid(path + " must be an object")
    }
    let mut action_count = 0
    if fields.get("insert") is Some(_) {
      action_count += 1
    }
    if fields.get("retain") is Some(_) {
      action_count += 1
    }
    if fields.get("delete") is Some(_) {
      action_count += 1
    }
    if action_count != 1 {
      raise Invalid(path + " must contain exactly one action")
    }
    for key, _ in fields {
      if key != "insert" &&
        key != "retain" &&
        key != "delete" &&
        key != "attributes" {
        raise Invalid(path + " has unknown field " + key)
      }
    }
    let attrs = match fields.get("attributes") {
      None => empty_attributes()
      Some(Object(map)) => Json::object(map)
      _ => raise Invalid(path + ".attributes must be an object")
    }
    let op = match fields.get("insert") {
      Some(String(text)) => {
        if text.length() == 0 {
          raise Invalid(path + ".insert is empty")
        }
        InsertText(text, attrs)
      }
      Some(Object(embed)) => {
        if embed.length() != 1 {
          raise Invalid(path + ".insert embed must have one key")
        }
        InsertEmbed(Json::object(embed), attrs)
      }
      Some(_) => raise Invalid(path + ".insert must be text or an embed object")
      None =>
        match fields.get("retain") {
          Some(Number(n, ..)) =>
            Retain(checked_length(n, path + ".retain"), attrs)
          Some(Object(embed)) => {
            if embed.length() != 1 {
              raise Invalid(path + ".retain embed must have one key")
            }
            RetainEmbed(Json::object(embed), attrs)
          }
          Some(_) =>
            raise Invalid(path + ".retain must be a length or embed object")
          None =>
            match fields.get("delete") {
              Some(Number(n, ..)) => {
                if !attributes_empty(attrs) {
                  raise Invalid(path + ".delete cannot have attributes")
                }
                Delete(checked_length(n, path + ".delete"))
              }
              _ => raise Invalid(path + ".delete must be a length")
            }
        }
    }
    total += op.length().to_int64()
    if total > 2147483647L {
      raise Invalid("Delta exceeds maximum UTF-16 length")
    }
    ignore(result.push(op))
  }
  result
}

///|
fn checked_length(number : Double, path : String) -> Int32 raise DeltaError {
  if number < 1.0 ||
    number > 2147483647.0 ||
    number != number.to_int().to_double() {
    raise Invalid(path + " must be a positive integer")
  }
  number.to_int()
}

///|
pub fn Delta::to_json(self : Delta) -> Json {
  let items : Array[Json] = []
  for op in self.ops {
    let fields : Map[String, Json] = Map([])
    match op {
      InsertText(text, _) => fields.set("insert", Json::string(text))
      InsertEmbed(embed, _) => fields.set("insert", embed)
      Retain(n, _) => fields.set("retain", Json::number(n.to_double()))
      RetainEmbed(embed, _) => fields.set("retain", embed)
      Delete(n) => fields.set("delete", Json::number(n.to_double()))
    }
    match op {
      Delete(_) => ()
      _ =>
        if !attributes_empty(op.attributes()) {
          fields.set("attributes", op.attributes())
        }
    }
    items.push(Json::object(fields))
  }
  Json::object({ "ops": Json::array(items) })
}

///|
pub fn Delta::stringify(self : Delta) -> String {
  self.to_json().stringify()
}
