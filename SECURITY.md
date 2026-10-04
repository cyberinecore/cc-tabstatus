# Security policy

Cyberine Tab Status writes an escape sequence to the terminal of each Claude Code session, so a way to make it write anything other than its fixed OSC 21337 status sequence, write to a terminal or file other than the session's own, read the contents of the hook input, or run a command it does not ship with is a security bug.

## Reporting

Report privately through GitHub's "Report a vulnerability" button on https://github.com/cyberinecore/cc-tabstatus/security, or by email to xinchao@nghia-pham.com. Please include the plugin version, the Claude Code, iTerm2 and tmux versions, the steps that trigger it, what happened and what you expected. Do not open a public issue for an unfixed vulnerability.

## Scope

In scope: output that contains text taken from the hook input, the prompt, a file name or any other variable data; a write to a device other than the session's terminal or tmux pane when `TABSTATUS_OUT` is unset; any network request; and any program run beyond `cat`, `tr`, `ps` and `tmux display-message`.

Out of scope: what iTerm2 or tmux do with a valid OSC 21337 sequence, the `allow-passthrough` setting of your tmux server, and a `TABSTATUS_OUT` path you set yourself.
