function fold_string
  set -l fold_replace $argv[1]
  set -l fold_length $argv[2]
  if [ (expr length + $argv[3]) -le $fold_length ]
    # If the string fits in the fold length no folding is necessary
    echo $argv[3]
  else
    set -l prefix_length (math -s 0 $fold_length - (expr length + $fold_replace))
    set -l prefix (expr substr $argv[3] 1 $prefix_length)
    echo -n $prefix
    echo $fold_replace
  end
end
