function rdot --description "Resolves the current working directory and changes to the realpath. This will not create a new history item as of 2019-11-09"
  echo -n (cd (pwd -P))
end
