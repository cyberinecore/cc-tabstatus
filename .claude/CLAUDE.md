# CLAUDE.md

Guidance for Claude Code working in this repository.

## What this repo is

`cyberine-tabstatus` (display name Cyberine Tab Status): a Claude Code plugin whose command hooks set the iTerm2 Session Status (OSC 21337) of each session's tab, inside tmux too. The repo root is both the plugin and a single-plugin marketplace (`.claude-plugin/marketplace.json`, `source: "./"`), published as `cyberinecore/cc-tabstatus`.

## Commands

- Tests: `./tests/tabstatus.test.sh` (byte-level output, silence on stdout and stderr).
- Lint: `shellcheck -S warning hooks/tabstatus.sh tests/tabstatus.test.sh`.
- Validate: `claude plugin validate . --strict` and `claude plugin validate .claude-plugin/plugin.json --strict`. This file sits in `.claude/` because a root `CLAUDE.md` makes strict validation fail.
- Live check: `echo '{}' | ./hooks/tabstatus.sh permission` from a pane in iTerm2, then `clear`.

## Constraints

- Hooks print nothing on stdout or stderr, for every state, inside and outside tmux: the owner wants no message at session start. A test enforces it.
- The hook input is read and discarded, never parsed: the directory policy forbids reading chat, and `UserPromptSubmit` input carries the prompt.
- No network, no files written, no programs beyond `cat`, `tr`, `ps` and `tmux display-message` (`SECURITY.md` scope).
- `.gitignore` names no other tool's credential file, because the directory scanner reads such lines as the plugin using a credential; those ignores live in `.git/info/exclude`.
- Outside tmux, Claude Code runs hooks without a controlling terminal, so the hook walks up parent processes to the first tty; `ps` prints `??` on macOS and `?` on Linux for none.
- Bump `version` in `.claude-plugin/plugin.json` and add a dated `CHANGELOG.md` entry on every release.
