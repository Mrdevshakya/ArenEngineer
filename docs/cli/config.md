---
summary: "CLI reference for `aren config` (get/set/unset config values)"
read_when:
  - You want to read or edit config non-interactively
title: "config"
---

# `aren config`

Config helpers: get/set/unset values by path. Run without a subcommand to open
the configure wizard (same as `aren configure`).

## Examples

```bash
aren config get browser.executablePath
aren config set browser.executablePath "/usr/bin/google-chrome"
aren config set agents.defaults.heartbeat.every "2h"
aren config set agents.list[0].tools.exec.node "node-id-or-name"
aren config unset tools.web.search.apiKey
```

## Paths

Paths use dot or bracket notation:

```bash
aren config get agents.defaults.workspace
aren config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
aren config get agents.list
aren config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--json` to require JSON5 parsing.

```bash
aren config set agents.defaults.heartbeat.every "0m"
aren config set gateway.port 19001 --json
aren config set channels.whatsapp.groups '["*"]' --json
```

Restart the gateway after edits.
