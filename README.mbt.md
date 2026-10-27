# MoonDelta

MoonDelta is a MoonBit implementation of the [Quill Delta](https://quilljs.com/docs/delta) rich-text document and change format. The library works on Native, JavaScript, Wasm, and Wasm GC without an editor UI or an external runtime.

## Supported operations

- Parse and serialize Quill-style `{"ops":[...]}` JSON with text, embeds, formatting attributes, numeric and embed retains, and deletions.
- Build canonical operation lists with `insert_text`, `insert_embed`, `retain`, `retain_embed`, `delete`, `push`, `chop`, and `concat`.
- Compose changes, apply them to full documents, invert changes for undo, transform concurrent changes, and transform cursor positions.
- Diff documents with Myers diff; `diff_at` uses a UTF-16 cursor position in the original document, and `diff_with_cursor_info` accepts explicit old and new ranges.
- Visit operations with `filter`, `for_each`, `map`, `partition`, and `reduce`; use `OpIterator` for partial operations.
- Visit rich-text lines with `each_line`, including delimiter attributes, custom delimiter, and early stop. `lines` returns line records.
- Register type-specific `EmbedHandler` algorithms for composing, inverting, and transforming retain-embed payload updates.
- Maintain a bounded local `History` for undo and redo.

Positions and lengths use UTF-16 code units, matching Quill. Diff treats Unicode scalar values and embeds as indivisible units.

## Example

```moonbit
let document = Delta::parse_json("{\"ops\":[{\"insert\":\"Hello world\\n\"}]}")
let change = Delta::new().retain_plain(6).delete(5).insert_plain("MoonBit")
let updated = document.apply(change)
println(updated.stringify())
// {"ops":[{"insert":"Hello MoonBit\n"}]}
```

For a reusable document state:

```moonbit
let history = History::new(document, 100)
history.apply(change)
ignore(history.undo())
ignore(history.redo())
```

Embedded payload updates require a registered handler for that embed type:

```moonbit
fn counter_value(value : Json) -> Double {
  match value {
    Number(number, ..) => number
    _ => 0.0
  }
}

let handlers = EmbedHandlers::new()
handlers.register(
  "counter",
  EmbedHandler::new(
    (base, update, _) =>
      Json::number(counter_value(base) + counter_value(update)),
    (update, _) => Json::number(-counter_value(update)),
    (_, other, _) => other,
  ),
)
let base = Delta::new().insert_embed(
  Json::object({ "counter": Json::number(5) }),
  empty_attributes(),
)
let increment = Delta::new().retain_embed(
  Json::object({ "counter": Json::number(2) }),
  empty_attributes(),
)
let changed = base.apply_with_handlers(increment, handlers)
```

The runnable example is in [cmd/main/main.mbt](cmd/main/main.mbt); the executable checks are in [cmd/selftest/main.mbt](cmd/selftest/main.mbt).

## Install and verify

After publication to Mooncakes:

```text
moon add xiaobai718-ab/moondelta
```

On a supported MoonBit installation:

```text
moon check --target native
moon check --target js
moon check --target wasm
moon check --target wasm-gc
moon test
moon run cmd/main
```

The MoonBit 2026-10-16 Windows toolchain can fail while creating a `\\?\` output path for `moon check`, `moon test`, `moon info`, and `moon fmt` in this workspace. The direct compiler script checks the library and whitebox test sources on all four targets, then runs the JavaScript selftest (121 text-diff pairs, 410 concurrent-transform pairs, and focused API checks):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1
```

To execute the 47 whitebox tests on Native and JavaScript despite the Windows path issue, the following script copies project source files to a short temporary directory, runs both targets, and removes the copy:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-short-path.ps1
```

## Compatibility notes

The implementation covers Quill Delta 5.1 core operations with MoonBit naming and explicit handler registries. `Delta::from_json` validates and normalizes input; `Delta::from_ops_raw` preserves the order of well-formed typed operations like the JavaScript constructor. A numeric `diff_at` hint is the cursor position before the edit and targets a single pure insertion or deletion. `diff_with_cursor_info` accepts `CursorInfo` containing old and new UTF-16 ranges. Both hint methods fall back to Myers diff when the supplied position or ranges cannot describe the edit. The exact edit script can differ from upstream `fast-diff` while producing the same document. The library does not include rendering, a GUI, network synchronization, or CRDT. `History` is local undo/redo and does not rebase stored inverses over remote edits.

The current feature-by-feature status and remaining parity work are listed in [COMPATIBILITY.md](COMPATIBILITY.md).

## License

MoonDelta is Apache-2.0 licensed. Quill Delta is a separate BSD-3-Clause project. Its notice is reproduced in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
