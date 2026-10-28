# Quill Delta 5.1 compatibility

MoonDelta implements the Quill Delta data model in MoonBit. The table below separates implemented behavior from remaining differences with the JavaScript package.

| Upstream area | MoonDelta entry point | State |
| --- | --- | --- |
| Insert, retain, delete, push, chop, concat | `Delta` builder methods | Implemented; direct `push` deep-clones JSON data and preserves zero-length raw operations, while builders skip empty operations |
| Construct from an operations array | `from_ops_raw` | Preserves typed operation order and shares the array, as in the JavaScript constructor; unknown JSON fields are outside the typed `Op` model |
| JSON input and output | `parse_json`, `from_json`, `parse_json_compatible`, `from_json_compatible`, `to_json` | Strict normalized and permissive layout-preserving constructors; explicit empty attribute objects and unknown fields do not round-trip exactly |
| Attribute maps | `attributes_*` | Implemented with structural JSON equality |
| Compose, invert, transform, transform position | `Delta` methods | Implemented; compose retains untouched raw operation boundaries using the upstream fast paths, and embed payload updates use global or explicit handlers |
| Diff | `diff` | MoonBit port of fast-diff 1.3.0 with prefix/suffix trimming, half-match, Myers bisect, merge and semantic cleanup, plus Quill embed placeholder mapping; tested against upstream text and Unicode fixtures |
| Numeric cursor hint | `diff_at` | Tries edits before then after the old caret, following upstream cursor convention; otherwise falls back to `diff`; tested against upstream output |
| Old/new range cursor hint | `diff_with_cursor_info` | Supports caret hints and selected old-range replacement; also accepts explicit edit ranges as an extension; tested against upstream output |
| Line and operation iteration | `each_line`, `OpIterator`, visitors | Implemented with MoonBit signatures; `each_line` visits completed prefix lines before a non-insert |

The standard typed Quill Delta operations are implemented. **Exact parity for every JavaScript input is not claimed:** its permissive constructor accepts unknown operation fields and values outside MoonDelta's typed `Op` model. An unusual Unicode bisect may choose a different valid edit script because `StringView::to_owned` does not preserve isolated UTF-16 surrogates on every backend. The upstream test suite has not been reproduced in full. The current suite has 1547 MoonBit whitebox tests, including 131 plain-text and 186 Unicode text comparisons against fast-diff 1.3.0, 317 cursor comparisons, and randomized upstream Delta diff, compose, transform, and invert fixtures. The whitebox suite passes on Native, JavaScript, Wasm, and Wasm GC using `scripts/test-short-path.ps1`; all four compilation targets and the JavaScript selftest pass using `scripts/verify.ps1`.

Further parity work would adapt the remaining upstream fixtures and compare serialized outputs against Quill Delta 5.1 for additional attribute and embed combinations. The upstream implementation and format documentation are at [quilljs/delta](https://github.com/slab/delta) and [Quill Delta documentation](https://quilljs.com/docs/delta).
