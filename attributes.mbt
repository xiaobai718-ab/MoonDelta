///|
/// Attribute maps are encoded as JSON objects so arbitrary Quill attributes
/// and application-defined embeds can round-trip without a fixed schema.
fn as_attribute_map(attributes : Json) -> Map[String, Json] {
  match attributes {
    Object(map) => map
    _ => {}
  }
}

///|
pub fn attributes_compose(left : Json, right : Json, keep_null : Bool) -> Json {
  let a = as_attribute_map(left)
  let b = as_attribute_map(right)
  let out : Map[String, Json] = Map([])
  for key, value in b {
    if keep_null || value != Json::null() {
      out.set(key, value)
    }
  }
  for key, value in a {
    if b.get(key) is None {
      out.set(key, value)
    }
  }
  Json::object(out)
}

///|
pub fn attributes_diff(left : Json, right : Json) -> Json {
  if left == right { return empty_attributes() }
  let a = as_attribute_map(left)
  let b = as_attribute_map(right)
  let out : Map[String, Json] = Map([])
  for key, value in a {
    match b.get(key) {
      Some(next) => if next != value { out.set(key, next) }
      None => out.set(key, Json::null())
    }
  }
  for key, value in b {
    if a.get(key) is None {
      out.set(key, value)
    }
  }
  Json::object(out)
}

///|
pub fn attributes_invert(change : Json, base : Json) -> Json {
  let a = as_attribute_map(change)
  let b = as_attribute_map(base)
  let out : Map[String, Json] = Map([])
  for key, old in b {
    match a.get(key) {
      Some(next) => if next != old { out.set(key, old) }
      None => ()
    }
  }
  for key, next in a {
    if b.get(key) is None && next != Json::null() {
      out.set(key, Json::null())
    }
  }
  Json::object(out)
}

///|
pub fn attributes_transform(left : Json, right : Json, priority : Bool) -> Json {
  if !priority {
    return right
  }
  let a = as_attribute_map(left)
  let b = as_attribute_map(right)
  let out : Map[String, Json] = Map([])
  for key, value in b {
    if a.get(key) is None {
      out.set(key, value)
    }
  }
  Json::object(out)
}
