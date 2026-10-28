///|
/// Parse a Quill Delta JSON value while preserving operation order, empty
/// text operations, and multi-key embed objects accepted by the JavaScript
/// constructor. Unknown JSON fields cannot be represented by typed Op values
/// and are ignored.
pub fn Delta::from_json_compatible(value : Json) -> Delta raise DeltaError {
  let items = match value {
    Array(operations) => operations
    Object(fields) =>
      match fields.get("ops") {
        Some(Array(operations)) => operations
        _ => raise Invalid("$.ops must be an array")
      }
    _ => raise Invalid("Delta must be an object or operations array")
  }
  let operations : Array[Op] = []
  for index, item in items {
    let path = "$.ops[" + index.to_string() + "]"
    let fields = match item {
      Object(map) => map
      _ => raise Invalid(path + " must be an object")
    }
    let attributes = match fields.get("attributes") {
      Some(value) => value
      None => empty_attributes()
    }
    let op = match fields.get("insert") {
      Some(String(text)) => InsertText(text, attributes)
      Some(Object(embed)) => InsertEmbed(Json::object(embed), attributes)
      Some(_) => raise Invalid(path + ".insert must be text or an embed object")
      None =>
        match fields.get("retain") {
          Some(Number(value, ..)) =>
            Retain(compatible_length(value, path + ".retain"), attributes)
          Some(Object(embed)) => RetainEmbed(Json::object(embed), attributes)
          Some(_) => raise Invalid(path + ".retain must be a length or embed object")
          None =>
            match fields.get("delete") {
              Some(Number(value, ..)) =>
                Delete(compatible_length(value, path + ".delete"))
              _ => raise Invalid(path + " must contain an action")
            }
        }
    }
    operations.push(op)
  }
  Delta::from_ops_raw(operations)
}

///|
pub fn Delta::parse_json_compatible(source : String) -> Delta raise DeltaError {
  let value = @json.parse(source) catch { _ => raise Invalid("Invalid JSON") }
  Delta::from_json_compatible(value)
}

///|
fn compatible_length(value : Double, path : String) -> Int32 raise DeltaError {
  if value < -2147483648.0 ||
    value > 2147483647.0 ||
    value != value.to_int().to_double() {
    raise Invalid(path + " must be an Int32 integer")
  }
  value.to_int()
}
