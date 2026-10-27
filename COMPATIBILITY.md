# Quill Delta 5.1 compatibility

MoonDelta implements the Quill Delta data model in MoonBit. The table below separates implemented behavior from remaining differences with the JavaScript package.

| Upstream area | MoonDelta entry point | State |
| --- | --- | --- |
| Insert, retain, delete, push, chop, concat | `Delta` builder methods | Implemented; canonical operations covered by tests |
| Construct from an operations array | `from_ops_raw` | Preserves typed operation order; does not store unknown JSON fields |
| JSON input and output | `parse_json`, `from_json`, `to_json` | Implemented with stricter input validation and normalization |
| Attribute maps | `attributes_*` | Implemented with structural JSON equality |
| Compose, invert, transform, transform position | `Delta` methods | Implemented; embed payload updates use an explicit `EmbedHandlers` registry |
| Diff | `diff` | Myers diff produces a correct change; a different valid edit sequence may be chosen |
| Numeric cursor hint | `diff_at` | Uses the edit position in the old document for one pure insertion or deletion; otherwise falls back to `diff` |
| Old/new range cursor hint | `diff_with_cursor_info` | Uses valid ranges when the outside content matches; otherwise falls back to `diff` |
| Line and operation iteration | `each_line`, `OpIterator`, visitors | Implemented with MoonBit signatures |

The port is **not yet exact behavioral parity** with the upstream JavaScript library. In particular, `fast-diff` cleanup and tie-breaking are not reproduced byte for byte, the permissive JavaScript constructor accepts values outside MoonDelta's typed `Op` model, and upstream's complete test suite has not been ported. The current suite has 47 MoonBit whitebox tests plus executable diff and transform matrices. Both Native and JavaScript tests pass locally using `scripts/test-short-path.ps1`; all four compilation targets pass `scripts/verify.ps1`.

The remaining work for an exact port is to adapt the upstream fixture suite, compare serialized outputs against Quill Delta 5.1 for the same inputs, and resolve documented differences case by case. The upstream implementation and format documentation are at [quilljs/delta](https://github.com/slab/delta) and [Quill Delta documentation](https://quilljs.com/docs/delta).
