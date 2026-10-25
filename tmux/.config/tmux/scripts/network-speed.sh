#!/bin/sh

set -eu

state_dir="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
state_file="${state_dir%/}/tmux-network-speed-${UID:-$(id -u)}"

read_counters() {
  case "$(uname -s)" in
    Linux)
      awk '
        NR > 2 {
          sub(":", "", $1)
        }
        NR > 2 && $1 != "lo" {
          received += $2
          transmitted += $10
        }
        END { printf "%.0f %.0f\n", received, transmitted }
      ' /proc/net/dev
      ;;
    Darwin)
      netstat -ibn | awk '
        NR > 1 && $1 !~ /^(lo|utun|awdl|llw|bridge|gif|stf)/ &&
        $7 ~ /^[0-9]+$/ && $10 ~ /^[0-9]+$/ {
          if ($7 > received[$1]) received[$1] = $7
          if ($10 > transmitted[$1]) transmitted[$1] = $10
        }
        END {
          for (interface in received) rx += received[interface]
          for (interface in transmitted) tx += transmitted[interface]
          printf "%.0f %.0f\n", rx, tx
        }
      '
      ;;
    *)
      return 1
      ;;
  esac
}

format_rate() {
  awk -v bytes="$1" 'BEGIN {
    if (bytes >= 1073741824) printf "%.1fG", bytes / 1073741824
    else if (bytes >= 1048576) printf "%.1fM", bytes / 1048576
    else if (bytes >= 1024) printf "%.1fK", bytes / 1024
    else printf "%.0fB", bytes
  }'
}

now=$(date +%s)
if ! counters=$(read_counters); then
  printf '↓ -- ↑ --'
  exit 0
fi
set -- $counters
received=$1
transmitted=$2

if [ -r "$state_file" ]; then
  read -r previous_time previous_received previous_transmitted < "$state_file" || true
else
  previous_time=
fi

printf '%s %s %s\n' "$now" "$received" "$transmitted" > "$state_file"

if [ -z "${previous_time:-}" ] || [ "$now" -le "$previous_time" ]; then
  printf '↓ -- ↑ --'
  exit 0
fi

elapsed=$((now - previous_time))
received_rate=$(((received - previous_received) / elapsed))
transmitted_rate=$(((transmitted - previous_transmitted) / elapsed))
[ "$received_rate" -ge 0 ] || received_rate=0
[ "$transmitted_rate" -ge 0 ] || transmitted_rate=0

printf '↓ %s/s ↑ %s/s' "$(format_rate "$received_rate")" "$(format_rate "$transmitted_rate")"
