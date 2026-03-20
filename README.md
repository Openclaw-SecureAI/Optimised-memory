# Optimized Memory for OpenClaw

A small, shareable setup bundle for enabling **OpenClaw memory with QMD** in a way that is reproducible, testable, and easier to troubleshoot.

This repository packages the parts that matter:
- a tested install script
- a ready-to-adapt OpenClaw config snippet
- a verification script
- the main gotchas discovered during a real installation

## What this enables

This setup switches OpenClaw memory to the **QMD backend** so memory retrieval can use:
- BM25 / lexical search
- vector search
- reranking

It also enables:
- session transcript memory indexing (experimental)
- pre-compaction memory flush

## Why this repo exists

Setting:

```json5
memory: { backend: "qmd" }
```

is not enough on its own.

You also need:
- `unzip` available
- Bun installed
- QMD installed correctly
- the gateway restarted
- a real verification path

### Important real-world note

The GitHub Bun install path may produce a broken source-layout package.
In testing, the **published package** worked reliably.

Use:

```bash
bun install -g @tobilu/qmd
```

Do **not** default to:

```bash
bun install -g https://github.com/tobi/qmd
```

unless you have independently verified that route on your machine.

## Quick start

### 1. Clone the repo

```bash
git clone https://github.com/Openclaw-SecureAI/Optimised-memory.git optimized-memory
cd optimized-memory
```

### 2. Run the install script

```bash
bash scripts/install-qmd.sh
```

The script will:
- install `unzip` and `zip` if missing
- install Bun if missing
- install QMD from the published package
- verify `qmd --help`
- restart the OpenClaw gateway
- print gateway status

### 3. Apply the config snippet

Merge the example from:

```bash
openclaw.memory.qmd.example.json5
```

into your:

```bash
~/.openclaw/openclaw.json
```

Minimum important pieces:
- `memory.backend = "qmd"`
- `memory.qmd.includeDefaultMemory = true`
- a direct-chat-safe scope
- `agents.defaults.memorySearch.experimental.sessionMemory = true`
- `agents.defaults.compaction.memoryFlush.enabled = true`

### 4. Verify the installation

Run:

```bash
bash scripts/verify-qmd.sh
```

This checks:
- Bun exists
- QMD exists
- `qmd --help` works
- the gateway is running
- OpenClaw sees QMD in a direct/session memory context

## Configuration example

See:

```bash
openclaw.memory.qmd.example.json5
```

Highlights:
- direct chats allowed by default
- memory citations enabled
- default workspace memory files included
- moderate recall limits
- session transcript indexing enabled

## Scope behavior note

A bare CLI memory search can fail with something like:

```text
[memory] qmd search denied by scope (channel=unknown, chatType=unknown, session=<none>)
```

That does **not** necessarily mean QMD is broken.

It usually means:
- you tested outside a real session context
- your QMD scope expects a direct chat or known session

Real verification should happen in an actual OpenClaw direct chat or session context.

## Expected success signal

A successful real-session verification should return memory search output that includes something like:

```text
provider: "qmd"
model: "qmd"
```

That is the important proof that OpenClaw is using QMD rather than silently falling back.

## Repository contents

- `scripts/install-qmd.sh` — installs Bun + QMD and restarts the gateway
- `scripts/verify-qmd.sh` — verifies QMD, the gateway, and the OpenClaw path
- `openclaw.memory.qmd.example.json5` — ready-to-adapt config example
- `docs/troubleshooting.md` — known issues and fixes

## Platform notes

Tested target:
- Linux with the OpenClaw gateway running under the same user

Should also work with adaptation on:
- macOS

For Windows:
- prefer WSL2

## License

MIT
