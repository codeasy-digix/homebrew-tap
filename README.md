# Codeasy Homebrew tap

```sh
brew install codeasy-digix/tap/codex-accounts
```

`codex-accounts` provides per-terminal ChatGPT account selection for the native
Codex CLI on macOS/Linux (ARM64 and x86_64), with shared local conversations.
The formula installs prebuilt binaries and the official pinned native Codex
package. There are no Python, Node.js, or Go runtime dependencies.
Homebrew installs tmux for concurrent conversation continuation.

For `codex account NAME`, add one line to your shell profile:

```sh
eval "$(codex-accounts shell-init zsh)"
```

Use `bash` instead of `zsh` for Bash. Without shell setup, run
`codex-accounts --account NAME` directly.

```sh
codex account NAME default # Set the machine default login; shared home stays ~/.codex
codex account default      # Return this terminal to the machine default
codex continue             # List quota-interrupted chats, then select one or all
codex continue --all       # Continue idle chats concurrently in named tmux sessions
```

Restart the GUI app after changing the machine default. Complete or stop jobs
using the previous default before switching. Other named terminal accounts keep
their selection. Previous default credentials/config are backed up privately.
Continuation jobs use the selected account and original working directories,
skip active conversations, and clear their own tmux sessions when finished.
The external `codex-accounts` program controls `codex continue`: listing and
selection need no login or model call. Only idle conversations with unresolved
quota errors appear in the list. Place shell-init after any older Codex shell
function, or use `codex-accounts continue` directly.

[Source, commands, storage and release instructions](https://github.com/codeasy-digix/codex-accounts)

This tap has no GUI or cross-device conversation synchronization package.
