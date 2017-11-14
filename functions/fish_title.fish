function _ssh_find_config_value
 ssh -G $argv[2..-1] | grep -ie "^$argv[1] " | sed "s/^$argv[1] \(.*\)/\1/I"
end

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
      set ssh_user (_ssh_find_config_value "User" $args[2..-1])
      set ssh_host (_ssh_find_config_value "Hostname" $args[2..-1] | cut -d '.' -f 1)
      if test (count $args -eq 2)
        set title "$ssh_user@$ssh_host"
      else
        set title "$argv"
      end
    case '*'
      set title "$_"
  end
  echo $title
end
