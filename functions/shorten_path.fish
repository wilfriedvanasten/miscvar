function shorten_path
	echo $argv[1] | sed -e "s#$HOME#~#g" | sed -e 's#\\(\\.\\?[^/]\\{1\\}\\)[^/]*/#\\1/#g'
end
