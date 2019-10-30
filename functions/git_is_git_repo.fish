# A function to check if the current directory
# is or is part of a git repo
function git_is_git_repo
  command git status 2> /dev/null > /dev/null
end
