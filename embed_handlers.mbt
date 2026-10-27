///|
/// Algorithms for one Quill embed type. The values are the JSON values under
/// the embed's single type key, not the outer `{ type: value }` object.
pub struct EmbedHandler {
  compose_value : (Json, Json, Bool) -> Json raise DeltaError
  invert_value : (Json, Json) -> Json raise DeltaError
  transform_value : (Json, Json, Bool) -> Json raise DeltaError
}

///|
pub fn EmbedHandler::new(
  compose : (Json, Json, Bool) -> Json raise DeltaError,
  invert : (Json, Json) -> Json raise DeltaError,
  transform : (Json, Json, Bool) -> Json raise DeltaError,
) -> EmbedHandler {
  { compose_value: compose, invert_value: invert, transform_value: transform }
}

///|
/// An explicit registry keeps embed behavior deterministic across independent
/// editors sharing a process. Pass it to the `_with_handlers` methods.
pub struct EmbedHandlers {
  handlers : Map[String, EmbedHandler]
}

///|
pub fn EmbedHandlers::new() -> EmbedHandlers {
  { handlers: Map([]) }
}

///|
pub fn EmbedHandlers::register(
  self : EmbedHandlers,
  embed_type : String,
  handler : EmbedHandler,
) -> Unit raise DeltaError {
  if embed_type == "" { raise Invalid("embed type cannot be empty") }
  self.handlers.set(embed_type, handler)
}

///|
pub fn EmbedHandlers::unregister(self : EmbedHandlers, embed_type : String) -> Unit {
  ignore(self.handlers.remove(embed_type))
}

///|
pub fn EmbedHandlers::contains(self : EmbedHandlers, embed_type : String) -> Bool {
  self.handlers.get(embed_type) is Some(_)
}

///|
fn EmbedHandlers::require(self : EmbedHandlers, embed_type : String) -> EmbedHandler raise DeltaError {
  match self.handlers.get(embed_type) {
    Some(handler) => handler
    None => raise Invalid("no handler for embed type \"" + embed_type + "\"")
  }
}

///|
fn embed_parts(left : Json, right : Json) -> (String, Json, Json) raise DeltaError {
  let a = match left {
    Object(map) if map.length() == 1 => map
    _ => raise Invalid("cannot retain a non-embed value")
  }
  let b = match right {
    Object(map) if map.length() == 1 => map
    _ => raise Invalid("retain embed must have one type")
  }
  for embed_type, data in a {
    match b.get(embed_type) {
      Some(next) => return (embed_type, data, next)
      None => raise Invalid("embed types do not match")
    }
  }
  raise Invalid("embed must have one type")
}

///|
fn wrap_embed(embed_type : String, data : Json) -> Json {
  let fields : Map[String, Json] = Map([])
  fields.set(embed_type, data)
  Json::object(fields)
}
