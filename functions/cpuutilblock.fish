# A function that outputs a cpu load bar compatible with the tmux status bar
# Supports low to full load and above.

function _current_load
	command cat /proc/loadavg | sed 's/^\([0-9][0-9]*\.[0-9][0-9]*\)[^0-9].*$/\1/g'
end

function cpuutilblock
  set -l current_load (_current_load)
	set -l num_cpus (command nproc)
	set -l ld (math -s 0 (math -s 2 "$current_load / $num_cpus * 10 + 0.5") / 1)
	set -l low "."
	set -l high "|"
	set -l color "green"
	if [ $ld -gt 3 ]
		set color "yellow"
		if [ $ld -gt 8 ]
			set color "red"
		end
	end
	while [ $ld -gt 10 ]
		set ld (math $ld - 10)
		set low $high
		if [ $high = "|" ]
			set high 1
		else
			set high (math $high + 1)
		end
	end
	echo -n "#[fg=$color]["
	repeatc $ld $high
	repeatc (math 10 - $ld) $low
	echo -n ']#[fg=default]'
end
