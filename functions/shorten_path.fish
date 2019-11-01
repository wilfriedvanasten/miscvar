function shorten_path
  set -l prefix $HOME
  set -l replacement "~"
  if test (count $argv) -gt 2
    set prefix $argv[2]
    set replacement $argv[3]
  end
  set -l partial_result (string replace -r "^$prefix(/|\$)" "$replacement\$1" $argv[1])
  string replace -ra '(\\.?[^/]{1})[^/]*/' '$1/' $partial_result
end
