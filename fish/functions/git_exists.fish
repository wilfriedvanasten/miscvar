function git_exists -d 'Checks if git is present'
  # Use which instead of type. We always use command to execute
  # git and this is much, much cheaper
  which git 2> /dev/null >/dev/null
end
