function fold_string
  set -l fold_replace $argv[1]
  set -l fold_length $argv[2]
  if [ (string length "$argv[3]") -le $fold_length ]
    # If the string fits in the fold length no folding is necessary
    echo $argv[3]
  else
    set -l prefix_length (math -s 0 $fold_length - (string length "$fold_replace"))
    set -l prefix (string sub -s 1 -l $prefix_length $argv[3])
    echo -n $prefix
    echo $fold_replace
  end
end
