#!/bin/sh
case "$1" in
  working)    body='status=Working;indicator=#5fafff;status-color=#5fafff;detail=' ;;
  permission) body='status=Waiting;indicator=#ff5f5f;status-color=#ff5f5f;detail=permission' ;;
  done)       body='status=Waiting;indicator=#ffd75f;status-color=#ffd75f;detail=turn done' ;;
  clear)      body='status=;indicator=;status-color=;detail=' ;;
  *)          exit 0 ;;
esac
cat >/dev/null 2>&1
[ "$LC_TERMINAL" = "iTerm2" ] || exit 0

if [ -n "$TMUX_PANE" ]; then
  out=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
  seq=$(printf '\033Ptmux;\033\033]21337;%s\033\033\\\033\\' "$body")
else
  out=''
  pid=$$
  while [ -n "$pid" ] && [ "$pid" -gt 1 ]; do
    read -r ppid tty <<EOF
$(ps -o ppid=,tty= -p "$pid" 2>/dev/null)
EOF
    case "$tty" in
      ''|'?'|'??') pid=$ppid ;;
      *) out="/dev/$tty"; break ;;
    esac
  done
  seq=$(printf '\033]21337;%s\033\\' "$body")
fi

[ -n "$TABSTATUS_OUT" ] && out="$TABSTATUS_OUT"
[ -n "$out" ] || exit 0
printf '%s' "$seq" 2>/dev/null >>"$out"
exit 0
