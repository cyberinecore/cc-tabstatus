# Privacy policy

Cyberine Tab Status is a Claude Code plugin that runs only on your computer. This policy covers the plugin as published from https://github.com/cyberinecore/cc-tabstatus.

## What it collects

Nothing. The plugin has no telemetry, makes no network requests, and sends no data to its author, to Anthropic, or to anyone else.

## What it reads locally

- The JSON that Claude Code passes to each hook on standard input. The plugin reads it to the end and discards it without parsing, so the prompt text and file paths it may contain are never looked at, stored or forwarded.
- The environment variables `LC_TERMINAL` (to run only in iTerm2), `TMUX_PANE` (to find the tmux pane) and `TABSTATUS_OUT` (a test override for the output path).
- The terminal device of the session: inside tmux from `tmux display-message`, otherwise from `ps` for the hook's parent processes.

It never reads your conversation transcript, Claude's memory, chat history or summaries.

## What it writes locally, and for how long

One short iTerm2 escape sequence (OSC 21337) per hook, written to the session's own terminal. iTerm2 shows it as the tab's status until the next one replaces it; the plugin keeps no files and no state of its own.

## Children

Cyberine Tab Status is a developer tool and is not directed at children under 18.

## Contact

Questions or concerns: open an issue at https://github.com/cyberinecore/cc-tabstatus/issues or email xinchao@nghia-pham.com. Security reports: see `SECURITY.md`.

## Changes

Changes to this policy are published in this file in the repository, with the history kept by git.
