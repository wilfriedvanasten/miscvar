# A function to check if the current directory
# is or is part of a git repo
function git_is_git_repo
  _git_status 2> /dev/null > /dev/null
end
