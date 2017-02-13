# This script outputs a relative bar of the used memory compared to the complete memory in
# a format that fits into the tmux status line. It uses free's +/- caches lines to achieve
# this and uses bc to calculate the percentage

function memblock
  read -z meminfo  < /proc/meminfo
  set -l total (echo "$meminfo" | grep -e "^MemTotal:" | sed 's#^[^0-9]*\([0-9][0-9]*\)[^0-9]*$#\1#g')
  set -l available (echo "$meminfo" | grep -e "^MemAvailable:" | sed 's#^[^0-9]*\([0-9][0-9]*\)[^0-9]*$#\1#g')
  if test -z $available
    set -l free (echo "$meminfo" | grep -e "^MemFree:" | sed 's#^[^0-9]*\([0-9][0-9]*\)[^0-9]*$#\1#g')
    set -l buffers (echo "$meminfo" | grep -e "^Buffers:" | sed 's#^[^0-9]*\([0-9][0-9]*\)[^0-9]*$#\1#g')
    set -l cached (echo "$meminfo" | grep -e '^Cached:' | sed 's#^[^0-9]*\([0-9][0-9]*\)[^0-9]*$#\1#g')
    set available (math "$free + $buffers + $cached")
  end
  set -l raw_perc (math -s2 "(($total-$available)/$total)*10")
  set -l perc (math -s0 "(($raw_perc + 0.5)/1)")
  set -l color "green"
  set -l normal 3
  set -l problem 8
  if [ $perc -gt $normal ]
    set color "yellow"
    if [ $perc -gt $problem ]
      set color "red"
    end
  end
  echo -n "#[fg=$color]["
  repeatc $perc '|'
  repeatc (math 10 - $perc) '.'
  echo -n ']#[fg=default]'
end
