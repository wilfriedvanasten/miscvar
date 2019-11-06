function _ssh_find_config_value
 ssh -G $argv[2..-1] | grep -ie "^$argv[1] " | sed "s/^$argv[1] \(.*\)/\1/I"
end

function _tokenize_command
  commandline -r $argv[1]
  commandline -o
  commandline -r ""
end

function fish_title
  set -l title ""
  switch $_
    case fish
      set title (prompt_pwd)
    case ssh
      set -l args (_tokenize_command $argv[1])
      set ssh_user (_ssh_find_config_value "User" $args[2..-1])
      set ssh_host (_ssh_find_config_value "Hostname" $args[2..-1] | cut -d '.' -f 1)
      if test (count $args -eq 2)
        set title "$ssh_user@$ssh_host"
      else
        set title "$argv"
      end
    case sudo
      set -l c (_tokenize_command $argv[1])
      argparse -s "A/askpass" "b/background" "B/bell"\
                  "C/close-from=" "E/preserve-env=?"\
                  "e/edit" "g/group" "H/set-home"\
                  "h/help" "i/login"\
                  "K/remove-timestamp" "k/reset-timestamp"\
                  "l/list" "n/non-interactive"\
                  "P/preserve-groups" "p/prompt="\
                  "S/stdin" "s/shell" "T/command-timeout"\
                  "U/other-user=" "u/user" "V/version" -- $c[2..-1]
      if test "$status" -eq "0"
        and test "$argv"
        set title "# $argv"
      else
        # Fallback to just showing sudo
        set title "$_"
    end
    case '*'
      set title "$_"
  end
  set -l relative_shell_level $SHLVL
  test "$TMUX"
    and test "$TMUX_SHLVL"
    and set relative_shell_level (math $SHLVL - $TMUX_SHLVL)
  test "$relative_shell_level" -gt "1"
    and set title "$title "(string repeat -n (math $relative_shell_level - 1) '<')
  if test "$SSH_CONNECTION"
    and not test "$TMUX"
    set title "$title - $USER@"(hostname)
  end
  if is_user_root
    set title "# $title"
  end
  echo $title
end
