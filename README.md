# Cyberine Tab Status

A Claude Code plugin that shows each session's state on its iTerm2 tab and in iTerm2's Session Status tool, so with many tabs and split panes you can see at a glance which session needs you.

| When | Status | Color |
|---|---|---|
| You send a prompt, or Claude finishes a tool call | Working | blue |
| Claude asks for a permission or an answer | Waiting (permission) | red |
| Claude finishes its turn | Waiting (turn done) | yellow |
| Session starts or ends | cleared | |

A tab with several panes shows the most urgent status among them. The Session Status tool (View > Toolbelt > Session Status) lists every pane on its own row, waiting ones first; click a row to jump to it. The tool is per window: it lists only the panes of the window it is shown in. A window with a single tab has no tab bar, so there the toolbelt is the only place the status shows.

## Requirements

- iTerm2 3.7 or newer (Session Status, OSC 21337).
- Inside tmux: `set -g allow-passthrough all` in `tmux.conf` (`on` only reaches panes that are currently visible).
- Anywhere other than iTerm2 (`LC_TERMINAL` is not `iTerm2`) the plugin does nothing.

## Install

```
claude plugin marketplace add /path/to/cc-tabstatus
claude plugin install cyberine-tabstatus@cyberine-tabstatus
```

Or for one session: `claude --plugin-dir /path/to/cc-tabstatus`.

## How it works

Each hook runs `hooks/tabstatus.sh <state>`, which writes an OSC 21337 sequence to the session's terminal. Inside tmux it resolves the pane tty from `$TMUX_PANE` and wraps the sequence in a tmux DCS passthrough, so the status lands on the right pane even though every tmux pane shares the same frozen `ITERM_SESSION_ID`. Outside tmux, hook processes have no controlling terminal, so it walks up the parent processes to the first one that has a tty (the `claude` process) and writes there.

## Tests

```
./tests/tabstatus.test.sh
```

## License

MIT
