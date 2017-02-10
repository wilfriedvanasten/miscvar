function fish_title
	set -l title "$_ "(shorten_path (pwd))
  printf "\033k$title\033\\"
end
