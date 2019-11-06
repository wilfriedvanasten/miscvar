# This script outputs a relative bar of the used memory compared to the complete memory in
# a format that fits into the tmux status line. It uses free's +/- caches lines to achieve
# this and uses bc to calculate the percentage

function _read_meminfo
  for line in (cat /proc/meminfo)
    echo $line
  end
end

function memblock
  set -l meminfo (_read_meminfo)
  set -l total (string match -r '^MemTotal:[^0-9]*([0-9][0-9]*)' $meminfo)[2]
  set -l available (string match -r '^MemAvailable:[^0-9]*([0-9][0-9]*)' $meminfo)[2]
  if test -z $available
    set -l free (string match -r '^MemFree:[^0-9]*([0-9][0-9]*)' $meminfo)[2]
    set -l buffers (string match -r '^Buffers:[^0-9]*([0-9][0-9]*)' $meminfo)[2]
    set -l cached (string match -r '^Cached:[^0-9]*([0-9][0-9]*)' $meminfo)[2]
    set available (math "$free + $buffers + $cached")
  end
  set -l raw_perc (math -s2 "(($total-$available)/$total)*100")
  set -l perc (math -s0 "(($raw_perc + 0.5)/1)")
  set -l color "green"
  set -l normal 30
  set -l problem 80
  if [ $perc -gt $normal ]
    set color "yellow"
    if [ $perc -gt $problem ]
      set color "red"
    end
  end
  set -l blocks '▁' '▂' '▃' '▄' '▅' '▆' '▇' '█'
  echo -n "#[fg=$color]"
  if not use_simple_glyph
    set -l block (math (math -s0 "(($perc / (100 / 7) + 0.5)/1)") + 1)
    echo -n '▕'
    echo -n $blocks[$block]
    echo -n '▏'
  end
  echo -n "$perc%"
  echo -n '#[fg=default]'
end
