---
summary: "CLI reference for `aren agents` (list/add/delete/set identity)"
read_when:
  - You want multiple isolated agents (workspaces + routing + auth)
title: "agents"
---

# `aren agents`

Manage isolated agents (workspaces + auth + routing).

Related:

- Multi-agent routing: [Multi-Agent Routing](/concepts/multi-agent)
- Agent workspace: [Agent workspace](/concepts/agent-workspace)

## Examples

```bash
aren agents list
aren agents add work --workspace ~/.aren/workspace-work
aren agents set-identity --workspace ~/.aren/workspace --from-identity
aren agents set-identity --agent main --avatar avatars/aren.png
aren agents delete work
```

## Identity files

Each agent workspace can include an `IDENTITY.md` at the workspace root:

- Example path: `~/.aren/workspace/IDENTITY.md`
- `set-identity --from-identity` reads from the workspace root (or an explicit `--identity-file`)

Avatar paths resolve relative to the workspace root.

## Set identity

`set-identity` writes fields into `agents.list[].identity`:

- `name`
- `theme`
- `emoji`
- `avatar` (workspace-relative path, http(s) URL, or data URI)

Load from `IDENTITY.md`:

```bash
aren agents set-identity --workspace ~/.aren/workspace --from-identity
```

Override fields explicitly:

```bash
aren agents set-identity --agent main --name "Aren" --emoji "🦞" --avatar avatars/aren.png
```

Config sample:

```json5
{
  agents: {
    list: [
      {
        id: "main",
        identity: {
          name: "Aren",
          theme: "space lobster",
          emoji: "🦞",
          avatar: "avatars/aren.png",
        },
      },
    ],
  },
}
```
