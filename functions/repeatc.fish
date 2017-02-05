function repeatc
	echo -n (seq $argv[1])  | sed "s/[0-9][0-9]*/\\$argv[2]/g"  | tr -d ' '
end
