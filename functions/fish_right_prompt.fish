function _do_prompt_git
  git_exists; and git_is_git_repo
end

function fish_right_prompt
  if set -q VIRTUAL_ENV
    # Let's hope python won't break this way to read the version
    set -l python_version (python --version | sed -e 's/Python //g')
    set -l virtual_env_short (shorten_path $VIRTUAL_ENV)
    set_color -b yellow
    set_color black
    echo -n "$virtual_env_short@$python_version"
    set_color normal
  end
  if _do_prompt_git
    set_color -b cyan
    set_color black
    echo -n (shorten_path (command dirname (command git rev-parse --show-toplevel)))
  end
  set_color normal
  echo ""
end
