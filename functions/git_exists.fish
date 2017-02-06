function git_exists -d 'Checks if git is present'
  type git ^/dev/null >/dev/null
end
