---
summary: "CLI reference for `aren reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `aren reset`

Reset local config/state (keeps the CLI installed).

```bash
aren reset
aren reset --dry-run
aren reset --scope config+creds+sessions --yes --non-interactive
```
