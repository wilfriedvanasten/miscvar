function fish_right_prompt
  if test (pwd -L) != (pwd -P)
    if git_exists
      and git_is_git_repo
      echo -n "<"(shorten_path (pwd -P) (command git rev-parse --show-toplevel) ":")">"
    else
      echo -n "<"(shorten_path (pwd -P))">"
    end
  end
  if set -q VIRTUAL_ENV
    # Let's hope python won't break this way to read the version
    set -l python_version (python --version | sed -e 's/Python //g')
    set -l virtual_env_short (shorten_path $VIRTUAL_ENV)
    set_color -b yellow
    set_color black
    echo -n "$virtual_env_short@$python_version"
    set_color normal
  end
  set_color normal
  echo ""
end
