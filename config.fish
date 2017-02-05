# Make sure ssh-agent can be reached
set -xg SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# Use vim for git
set -xg VISUAL "vim"

# T(he )tmux session
alias ttmux "tmux attach-session; or tmux"
