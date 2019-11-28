# A function that outputs a cpu load bar compatible with the tmux status bar
# Supports low to full load and above.

function _current_load
  command cat /proc/loadavg | sed 's/^\([0-9][0-9]*\.[0-9][0-9]*\)[^0-9].*$/\1/g'
end

function cpuutilblock
  set -l current_load (_current_load)
  set -l num_cpus (command nproc)
  set -l ld (math -s 0 (math -s 2 "$current_load / $num_cpus * 100 + 0.5") / 1)
  set -l color "green"
  if test "$ld" -gt 30
    set color "yellow"
    if test $ld -gt 80
      set color "red"
    end
  end
  set -l blocks '▁' '▂' '▃' '▄' '▅' '▆' '▇' '█'
  echo -n "#[fg=$color]"
  set -l block 8
  if test "$perc" -lt 100
    set block (math (math -s0 "(($ld / (100 / 7) + 0.5)/1)") + 1)
  end
  echo -n '▕'
  echo -n $blocks[$block]
  echo -n '▏'
  if test "$ld" -gt 100
    printf $ld
  else
    printf "%2s%%" $ld
  end
  echo -n '#[fg=default]'
end
