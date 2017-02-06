function shorten_path
	if test (count $argv) -lt 3
		echo $argv[1] | sed -e "s#$HOME#~#g" | sed -e 's#\\(\\.\\?[^/]\\{1\\}\\)[^/]*/#\\1/#g'
	else
		echo $argv[1] | sed -e "s#$argv[2]#$argv[3]#g" | sed -e 's#\\(\\.\\?[^/]\\{1\\}\\)[^/]*/#\\1/#g'
	end
end
