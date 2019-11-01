function shorten_path
  set -l prefix $HOME
  set -l replacement "~"
  if test (count $argv) -gt 2
    set prefix $argv[2]
    set replacement $argv[3]
  end
  string replace -r "^$HOME(/|\$)" "~$1" | sed -e 's#\\(\\.\\?[^/]\\{1\\}\\)[^/]*/#\\1/#g'
end
