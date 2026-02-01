---
summary: "CLI reference for `aren onboard` (interactive onboarding wizard)"
read_when:
  - You want guided setup for gateway, workspace, auth, channels, and skills
title: "onboard"
---

# `aren onboard`

Interactive onboarding wizard (local or remote Gateway setup).

Related:

- Wizard guide: [Onboarding](/start/onboarding)

## Examples

```bash
aren onboard
aren onboard --flow quickstart
aren onboard --flow manual
aren onboard --mode remote --remote-url ws://gateway-host:18789
```

Flow notes:

- `quickstart`: minimal prompts, auto-generates a gateway token.
- `manual`: full prompts for port/bind/auth (alias of `advanced`).
- Fastest first chat: `aren dashboard` (Control UI, no channel setup).
