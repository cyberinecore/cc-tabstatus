#!/bin/sh
root=$(cd "$(dirname "$0")/.." && pwd)
hook="$root/hooks/tabstatus.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fail=0

check() {
  name=$1
  if cmp -s "$tmp/out" "$tmp/expected"; then
    echo "ok   $name"
  else
    echo "FAIL $name"
    od -c "$tmp/out" | head -5
    fail=1
  fi
  : >"$tmp/out"
  : >"$tmp/expected"
}

: >"$tmp/out"

echo '{}' | env -u TMUX_PANE LC_TERMINAL=iTerm2 TABSTATUS_OUT="$tmp/out" "$hook" working
printf '\033]21337;status=Working;indicator=#5fafff;status-color=#5fafff;detail=\033\\' >"$tmp/expected"
check "plain pane: working"

echo '{}' | LC_TERMINAL=iTerm2 TMUX_PANE=%0 TABSTATUS_OUT="$tmp/out" "$hook" permission
printf '\033Ptmux;\033\033]21337;status=Waiting;indicator=#ff5f5f;status-color=#ff5f5f;detail=permission\033\033\\\033\\' >"$tmp/expected"
check "tmux pane: permission is DCS-wrapped"

echo '{}' | env -u TMUX_PANE LC_TERMINAL=iTerm2 TABSTATUS_OUT="$tmp/out" "$hook" "done"
printf '\033]21337;status=Waiting;indicator=#ffd75f;status-color=#ffd75f;detail=turn done\033\\' >"$tmp/expected"
check "plain pane: done"

echo '{}' | env -u TMUX_PANE LC_TERMINAL=iTerm2 TABSTATUS_OUT="$tmp/out" "$hook" clear
printf '\033]21337;status=;indicator=;status-color=;detail=\033\\' >"$tmp/expected"
check "plain pane: clear empties every field"

echo '{}' | env -u TMUX_PANE LC_TERMINAL=WezTerm TABSTATUS_OUT="$tmp/out" "$hook" working
check "non-iTerm terminal writes nothing"

echo '{}' | env -u TMUX_PANE LC_TERMINAL=iTerm2 TABSTATUS_OUT="$tmp/out" "$hook" bogus
check "unknown state writes nothing"

echo '{}' | env -u TMUX_PANE LC_TERMINAL=iTerm2 TABSTATUS_OUT="$tmp/missing-dir/out" "$hook" working
rc=$?
if [ "$rc" -eq 0 ]; then echo "ok   unwritable target exits 0"; else echo "FAIL unwritable target exit $rc"; fail=1; fi

for state in clear working permission "done" bogus; do
  for pane in '' %0; do
    echo '{}' | LC_TERMINAL=iTerm2 TMUX_PANE="$pane" TABSTATUS_OUT="$tmp/out" "$hook" "$state" >"$tmp/stdout" 2>"$tmp/stderr"
    if [ -s "$tmp/stdout" ] || [ -s "$tmp/stderr" ]; then
      echo "FAIL $state (pane '$pane') printed to stdout/stderr"
      fail=1
    else
      echo "ok   $state (pane '$pane') prints nothing to stdout/stderr"
    fi
    : >"$tmp/out"
  done
done

exit $fail
