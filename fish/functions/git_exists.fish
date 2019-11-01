function git_exists -d 'Checks if git is present'
  type git 2> /dev/null >/dev/null
end
