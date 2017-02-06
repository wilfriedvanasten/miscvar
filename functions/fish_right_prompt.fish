function fish_right_prompt
  if set -q VIRTUAL_ENV
    # Let's hope python won't break this way to read the version
    set -l python_version (python --version | sed -e 's/Python //g')
    set -l virtual_env_short (shorten_path $VIRTUAL_ENV)
    echo "$virtual_env_short@$python_version"
  end
end
