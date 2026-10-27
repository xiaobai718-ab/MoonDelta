# MoonDelta

MoonDelta is a pure MoonBit implementation of the [Quill Delta](https://quilljs.com/docs/delta) rich-text change format. It provides a reusable format and editing engine for MoonBit applications on native, JavaScript, Wasm, and Wasm GC targets. It has no browser, GUI, or external editor dependency.

## What works

- Read and write Quill-style `{ "ops": [...] }` JSON, including text, embeds, retains, deletes, and arbitrary formatting attributes.
- Normalize adjacent operations and keep inserts before deletes at the same position.
- Compose consecutive changes, apply them to a document, transform concurrent changes, and transform cursor positions.
- Invert a change against its original document for undo, and calculate a change between two full documents.
- Split a document into rich-text lines with newline attributes kept as block formats.
- Keep a bounded local undo/redo history.

All positions and lengths use UTF-16 code units, matching JavaScript and Quill. A Unicode scalar outside the BMP, such as an emoji, has length two. The diff algorithm keeps surrogate pairs intact.

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

The runnable example is in [`cmd/main/main.mbt`](cmd/main/main.mbt). The self-test program is in [`cmd/selftest/main.mbt`](cmd/selftest/main.mbt).

## Install and verify

Add the Mooncake to a MoonBit project after it is published:

```text
moon add xiaobai718-ab/moondelta
```

Normal validation on a supported MoonBit installation:

```text
moon check --target native
moon check --target js
moon check --target wasm
moon check --target wasm-gc
moon test
moon run cmd/main
```

With the MoonBit 2026-10-16 toolchain on some Windows paths, `moon check`, `moon info`, `moon fmt`, and `moon test` can fail before checking source because the compiler cannot create a `\\?\` output path. The repository includes a direct-compiler workaround that checks all four targets and runs 121 text-diff pairs, 410 operational-transform pairs, and other behavior checks:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1
```

## Compatibility scope

MoonDelta follows the Quill Delta JSON model and core text algorithms. An insert-only Delta is a document; a Delta containing retain/delete operations is a change. `apply`, `diff`, `invert`, and `lines` validate where a full document is required.

Embedded object inserts round-trip and can be added or removed using insert/delete changes. Quill 5's type-specific **retain-embed payload updates** are not yet implemented. `invert` rejects those updates because they need an embed handler to recover the previous value. Consumers needing that operation should express replacement as delete plus insert for now.

Diff keeps common prefixes and suffixes and uses a bounded longest-common-subsequence matrix for the edited middle. When the middle would exceed one million matrix cells, it emits a correct replacement change rather than a minimal one. History is local undo/redo; it does not rebase stored inverses over incoming remote changes.

## License

MoonDelta is Apache-2.0 licensed. Quill Delta is a separate BSD-3-Clause project. Its license notice is reproduced in [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).
