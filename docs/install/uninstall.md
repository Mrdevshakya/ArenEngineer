---
summary: "Uninstall Aren completely (CLI, service, state, workspace)"
read_when:
  - You want to remove Aren from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `aren` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
aren uninstall
```

Non-interactive (automation / npx):

```bash
aren uninstall --all --yes --non-interactive
npx -y aren uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
aren gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
aren gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${AREN_STATE_DIR:-$HOME/.aren}"
```

If you set `AREN_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.aren/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g aren
pnpm remove -g aren
bun remove -g aren
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/Aren.app
```

Notes:

- If you used profiles (`--profile` / `AREN_PROFILE`), repeat step 3 for each state dir (defaults are `~/.aren-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `aren` is missing.

### macOS (launchd)

Default label is `bot.molt.gateway` (or `bot.molt.<profile>`; legacy `com.aren.*` may still exist):

```bash
launchctl bootout gui/$UID/bot.molt.gateway
rm -f ~/Library/LaunchAgents/bot.molt.gateway.plist
```

If you used a profile, replace the label and plist name with `bot.molt.<profile>`. Remove any legacy `com.aren.*` plists if present.

### Linux (systemd user unit)

Default unit name is `aren-gateway.service` (or `aren-gateway-<profile>.service`):

```bash
systemctl --user disable --now aren-gateway.service
rm -f ~/.config/systemd/user/aren-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `Aren Gateway` (or `Aren Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "Aren Gateway"
Remove-Item -Force "$env:USERPROFILE\.aren\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.aren-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://aren.engineer/install.sh` or `install.ps1`, the CLI was installed with `npm install -g aren@latest`.
Remove it with `npm rm -g aren` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `aren ...` / `bun run aren ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
