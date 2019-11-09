function git_exists -d 'Checks if git is present'
  # Use command -s instead of type. which would also
  # work, but a builtin must work
  command -s git 2> /dev/null >/dev/null
end
