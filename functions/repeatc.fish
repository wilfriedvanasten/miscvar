function repeatc
  if test " " != "$argv[2]"
	  echo -n (seq $argv[1])  | sed "s/[0-9][0-9]*/$argv[2]/g"  | tr -d ' '
  else
    # To allow space as a character first use a pseudo character
    # to maintain the seq-tr relationship
	  echo -n (seq $argv[1])  | sed "s/[0-9][0-9]*/*/g"  | tr -d ' ' | sed "s/\\*/ /g"
  end
end
