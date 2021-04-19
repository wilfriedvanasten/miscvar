# If necessary setup the SSH_AUTH_SOCK for the ssh-agent user unit
if systemctl --user is-active --quiet ssh-agent
  and test -z "$SSH_AUTH_SOCK"
  if test -z "$XDG_RUNTIME_DIR"
    echo 'Warning: no xdg runtime dir. Not setting SSH_AUTH_SOCK' > 2
  else
    set -xg SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
  end
end

# Use vim for git
set -xg VISUAL "vim"

set -xg PATH ~/.local/bin $PATH

# T(he )tmux session

if status --is-interactive
  # When in a sudo starting tmux is almost always unintended
  and not test "$SUDO_USER"
  if not tmux has -t "default" 2> /dev/null
    tmux new -d -s "default"
  end
  if test -z "$TMUX"
    set default_is_attached (string split ' ' (tmux ls -F '#{session_name} #{session_attached}' 2> /dev/null | grep "default"))[2]
    if test "$default_is_attached" = "0"
      exec tmux attach -t "default"
    end
  end
end
