function fish_title
  set -l title ""
  switch $_
    case fish
      set title (prompt_pwd)
    case vim
      set -l args (string split " " $argv)
      if test (count $args -gt 1)
        set title "$_ "(shorten_path $args[2])
      else
        set title "$_ *"
      end
    case ssh
      set -l args (string split " " $argv)
      if test (count $args -eq 2)
        set title (echo $args[2] | cut -d '.' -f 1)
      else
        set title "$argv"
      end
    case '*'
    set title "$argv"
  end
  printf "\033k$title\033\\"
end
