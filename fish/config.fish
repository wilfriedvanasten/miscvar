# Make sure ssh-agent can be reached
set -xg SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# Use vim for git
set -xg VISUAL "vim"

set -xg PATH ~/.local/bin $PATH

# T(he )tmux session

if status --is-interactive
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
