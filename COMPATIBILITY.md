# Quill Delta 5.1 compatibility

MoonDelta implements the Quill Delta data model in MoonBit. The table below separates implemented behavior from remaining differences with the JavaScript package.

| Upstream area | MoonDelta entry point | State |
| --- | --- | --- |
| Insert, retain, delete, push, chop, concat | `Delta` builder methods | Implemented; direct `push` deep-clones JSON data and preserves zero-length raw operations, while builders skip empty operations |
| Construct from an operations array | `from_ops_raw` | Preserves typed operation order and shares the array, as in the JavaScript constructor; unknown JSON fields are outside the typed `Op` model |
| JSON input and output | `parse_json`, `from_json`, `parse_json_compatible`, `from_json_compatible`, `to_json` | Strict normalized and permissive layout-preserving constructors; explicit empty attribute objects and unknown fields do not round-trip exactly |
| Attribute maps | `attributes_*` | Implemented with structural JSON equality |
| Compose, invert, transform, transform position | `Delta` methods | Implemented; compose retains untouched raw operation boundaries using the upstream fast paths, and embed payload updates use global or explicit handlers |
| Diff | `diff` | Myers diff with embed placeholder matching and short-equality semantic cleanup produces a correct change; tie-breaking and full `fast-diff` cleanup can still choose a different valid script |
| Numeric cursor hint | `diff_at` | Tries edits before then after the old caret, following upstream cursor convention; otherwise falls back to `diff` |
| Old/new range cursor hint | `diff_with_cursor_info` | Supports caret hints and selected old-range replacement; also accepts explicit edit ranges as an extension |
| Line and operation iteration | `each_line`, `OpIterator`, visitors | Implemented with MoonBit signatures; `each_line` visits completed prefix lines before a non-insert |

The port is **not yet exact behavioral parity** with the upstream JavaScript library. In particular, the full `fast-diff` algorithm and its lossless semantic cleanup are not reproduced byte for byte, the permissive JavaScript constructor accepts values outside MoonDelta's typed `Op` model, and upstream's complete test suite has not been ported. The current suite has 84 MoonBit whitebox tests plus executable diff and transform matrices. The whitebox suite passes on Native, JavaScript, Wasm, and Wasm GC using `scripts/test-short-path.ps1`; all four compilation targets and the JavaScript selftest pass using `scripts/verify.ps1`.

The remaining work for an exact port is to adapt the rest of the upstream fixture suite, compare serialized outputs against Quill Delta 5.1 for the same inputs, and port or reproduce `fast-diff` semantic cleanup and tie-breaking. The upstream implementation and format documentation are at [quilljs/delta](https://github.com/slab/delta) and [Quill Delta documentation](https://quilljs.com/docs/delta).
