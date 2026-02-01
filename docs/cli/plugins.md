---
summary: "CLI reference for `aren plugins` (list, install, enable/disable, doctor)"
read_when:
  - You want to install or manage in-process Gateway plugins
  - You want to debug plugin load failures
title: "plugins"
---

# `aren plugins`

Manage Gateway plugins/extensions (loaded in-process).

Related:

- Plugin system: [Plugins](/plugin)
- Plugin manifest + schema: [Plugin manifest](/plugins/manifest)
- Security hardening: [Security](/gateway/security)

## Commands

```bash
aren plugins list
aren plugins info <id>
aren plugins enable <id>
aren plugins disable <id>
aren plugins doctor
aren plugins update <id>
aren plugins update --all
```

Bundled plugins ship with Aren but start disabled. Use `plugins enable` to
activate them.

All plugins must ship a `aren.plugin.json` file with an inline JSON Schema
(`configSchema`, even if empty). Missing/invalid manifests or schemas prevent
the plugin from loading and fail config validation.

### Install

```bash
aren plugins install <path-or-spec>
```

Security note: treat plugin installs like running code. Prefer pinned versions.

Supported archives: `.zip`, `.tgz`, `.tar.gz`, `.tar`.

Use `--link` to avoid copying a local directory (adds to `plugins.load.paths`):

```bash
aren plugins install -l ./my-plugin
```

### Update

```bash
aren plugins update <id>
aren plugins update --all
aren plugins update <id> --dry-run
```

Updates only apply to plugins installed from npm (tracked in `plugins.installs`).
