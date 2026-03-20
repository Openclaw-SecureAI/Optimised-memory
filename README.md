# Optimised memory

A small shareable setup bundle for enabling **OpenClaw memory with QMD** in a way that is actually easy to reproduce.

This repo packages the parts that matter:
- a tested install script
- a ready-to-paste OpenClaw config snippet
- a verification script/checklist
- the key gotchas discovered during a real install

## What this enables

This setup switches OpenClaw memory to the **QMD backend** so memory retrieval can use:
- BM25 / lexical search
- vector search
- reranking

It also enables:
- session transcript memory indexing (experimental)
- pre-compaction memory flush

## Why this repo exists

Just setting:

```json5
memory: { backend: "qmd" }
```

is not enough.

You also need:
- `unzip` available
- Bun installed
- QMD installed correctly
- the gateway restarted
- a proper verification path

Important real-world note:
- the GitHub Bun install path may produce a broken source-layout package
- the **published package** worked reliably in testing

Use:

```bash
bun install -g @tobilu/qmd
```

Do **not** default to:

```bash
bun install -g https://github.com/tobi/qmd
```

unless you have independently verified that route on your machine.

## Quick install

### 1. Clone repo

```bash
git clone https://github.com/Openclaw-SecureAI/Optimised-memory.git
cd Optimised-memory
```

### 2. Run install script

```bash
bash scripts/install-qmd.sh
```

This script will:
- install `unzip` and `zip` if missing
- install Bun if missing
- install QMD from the published package
- verify `qmd --help`
- restart the OpenClaw gateway
- print gateway status

### 3. Apply config snippet

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

### 4. Verify

Run:

```bash
bash scripts/verify-qmd.sh
```

This checks:
- Bun exists
- QMD exists
- `qmd --help` works
- gateway is running
- OpenClaw sees QMD in a direct/session memory context

## Config example

See:

```bash
openclaw.memory.qmd.example.json5
```

Highlights:
- direct chats allowed by default
- memory citations on
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
- and your QMD scope expects a direct chat / known session

So the real verification should happen in an actual OpenClaw direct chat or session context.

## Expected success signal

A successful real-session verification should show memory search returning something like:

```text
provider: "qmd"
model: "qmd"
```

That is the important proof that OpenClaw is actually using QMD and not silently falling back.

## Files

- `scripts/install-qmd.sh` — install Bun + QMD + restart gateway
- `scripts/verify-qmd.sh` — verify QMD + gateway + OpenClaw path
- `openclaw.memory.qmd.example.json5` — ready-to-adapt config example
- `docs/troubleshooting.md` — known issues and fixes

## Platform notes

Tested target:
- Linux with OpenClaw gateway running under the same user

Should also work with adaptation on:
- macOS

For Windows:
- prefer WSL2

## License

MIT
