# Changelog

All notable changes to Cyberine Tab Status. Versions follow `version` in `.claude-plugin/plugin.json`.

## [0.1.0] - 2026-10-05

- First release: command hooks that set the iTerm2 Session Status (OSC 21337) of each Claude Code session's tab: Working (blue) on prompt submit and after each tool call, Waiting with detail `permission` (red) on a permission or elicitation prompt, Waiting with detail `turn done` (yellow) when the turn ends, cleared on session start and end.
- Inside tmux the sequence goes to the pane's own tty through DCS passthrough, so each pane gets its own status although every pane shares one `ITERM_SESSION_ID`; needs `allow-passthrough all`.
- Outside tmux the hook walks up its parent processes to the first one with a controlling terminal, because Claude Code runs hooks without one.
- Silent everywhere: no output on standard output or standard error, nothing added to the transcript, and nothing at all outside iTerm2.
