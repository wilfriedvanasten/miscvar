function gradlew
  set -l dir '.'
  while git_exists
    and git_is_git_repo
    if test -x "$dir/gradlew"
      "$dir/gradlew" $argv
      return $status
    else
      set dir "../$dir"
    end
  end
  echo >&2 Error: No gradlewrapper or repository
end
