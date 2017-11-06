function fold_string
  set -l fold_replace $argv[1]
  set -l fold_length $argv[2]
  if [ (string length $argv[3]) -le $fold_length ]
    echo $argv[3]
  else
    set -l prefix_length (math $fold_length - (string length $fold_replace))
    set -l prefix (string sub -l $prefix_length $argv[3])
    echo -n $prefix
    echo $fold_replace
  end
end
