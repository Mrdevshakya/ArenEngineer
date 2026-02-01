# Security Policy

If you believe you've found a security issue in Aren, please report it privately.

## Reporting

- Email: `steipete@gmail.com`
- What to include: reproduction steps, impact assessment, and (if possible) a minimal PoC.

## Bug Bounties

Aren is a labor of love. There is no bug bounty program and no budget for paid reports. Please still disclose responsibly so we can fix issues quickly.
The best way to help the project right now is by sending PRs.

## Out of Scope

- Public Internet Exposure
- Using Aren in ways that the docs recommend not to
- Prompt injection attacks

## Operational Guidance

For threat model + hardening guidance (including `aren security audit --deep` and `--fix`), see:

- `https://docs.aren.engineer/gateway/security`

### Web Interface Safety

Aren's web interface is intended for local use only. Do **not** bind it to the public internet; it is not hardened for public exposure.

## Runtime Requirements

### Node.js Version

Aren requires **Node.js 22.12.0 or later** (LTS). This version includes important security patches:

- CVE-2025-59466: async_hooks DoS vulnerability
- CVE-2026-21636: Permission model bypass vulnerability

Verify your Node.js version:

```bash
node --version  # Should be v22.12.0 or later
```

### Docker Security

When running Aren in Docker:

1. The official image runs as a non-root user (`node`) for reduced attack surface
2. Use `--read-only` flag when possible for additional filesystem protection
3. Limit container capabilities with `--cap-drop=ALL`

Example secure Docker run:

```bash
docker run --read-only --cap-drop=ALL \
  -v aren-data:/app/data \
  aren/aren:latest
```

## Security Scanning

This project uses `detect-secrets` for automated secret detection in CI/CD.
See `.detect-secrets.cfg` for configuration and `.secrets.baseline` for the baseline.

Run locally:

```bash
pip install detect-secrets==1.5.0
detect-secrets scan --baseline .secrets.baseline
```
