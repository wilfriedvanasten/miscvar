function is_user_root
  set -l uid (id -u $USER)
  test $uid -eq 0
end
