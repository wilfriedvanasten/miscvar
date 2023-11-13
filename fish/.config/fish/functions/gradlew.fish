function gradlew
  set -l start $PWD
  while git_exists
    and git_is_git_repo
    if test -x "./gradlew"
      "./gradlew" $argv
      return $status
    else
      cd ..
    end
  end
  echo >&2 Error: No gradlewrapper or repository
  cd $start
end
