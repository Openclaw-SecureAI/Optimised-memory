# Troubleshooting

## Problem: `qmd` binary exists but fails with `Module not found`

Likely cause:
- QMD was installed from the GitHub Bun URL and produced a source-layout package without the built `dist/` CLI entrypoint.

Fix:
- remove the broken install
- install the published package instead:

```bash
bun install -g @tobilu/qmd
```

## Problem: `bun` install fails with `unzip is required`

Cause:
- Bun installer requires `unzip`

Fix:

```bash
sudo apt-get update && sudo apt-get install -y unzip zip
```

## Problem: memory search says scope denied

Example:

```text
[memory] qmd search denied by scope (channel=unknown, chatType=unknown, session=<none>)
```

Meaning:
- you tested outside a real session/direct-chat context
- QMD scope is doing its job

Fix:
- test from an actual OpenClaw direct chat/session
- or adjust `memory.qmd.scope`

## Problem: memory still works but you are not sure QMD is active

Important:
- OpenClaw may fall back to builtin memory if QMD fails
- so “memory works” is not enough proof

Verify using a real session memory search and confirm:

```text
provider: "qmd"
model: "qmd"
```

## Problem: gateway restart did not fix anything

Restart only reloads runtime.
It does not install missing dependencies.

You still need:
- Bun installed
- QMD installed
- `qmd` on PATH
