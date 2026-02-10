# Package.swift ↔ artifacts/ Verification Summary

**Date:** 2025-02-10

## Artifacts folder contents (57 xcframeworks)

All entries under `artifacts/` were listed and compared with `Package.swift` binary targets and target dependencies.

## Change applied

| Item | Before | After | Reason |
|------|--------|--------|--------|
| **Promises** | Target/dependency name: `promises` | `Promises` | Matches artifact folder `Promises.xcframework` |
| | Path: `artifacts/promises.xcframework` | `artifacts/Promises.xcframework` | Path must match actual folder name |

## Verification

- **57** xcframework folders in `artifacts/` — all have a matching `.binaryTarget` in `Package.swift`.
- **1** mismatch was found and fixed: `promises` → `Promises` (name and path).
- No artifact folders were removed from or added to `Package.swift`; only the Promises naming/path was corrected.

## Quick check

To confirm artifact paths resolve:

```bash
for f in artifacts/*.xcframework; do basename "$f" .xcframework; done | sort
```

Compare with binary target names in `Package.swift` (case-sensitive). All should match.
