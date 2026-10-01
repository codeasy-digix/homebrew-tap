# Codeasy Homebrew tap

```sh
brew install codeasy-digix/tap/codex-accounts
```

`codex-accounts` provides per-terminal ChatGPT account selection for the native
Codex CLI on macOS/Linux (ARM64 and x86_64), with shared local conversations.
The formula installs prebuilt binaries and the official pinned native Codex
package. There are no Python, Node.js, or Go runtime dependencies.

For `codex account NAME`, add one line to your shell profile:

```sh
eval "$(codex-accounts shell-init zsh)"
```

Use `bash` instead of `zsh` for Bash. Without shell setup, run
`codex-accounts --account NAME` directly.

[Source, commands, storage and release instructions](https://github.com/codeasy-digix/codex-accounts)

This tap has no GUI or cross-device conversation synchronization package.
