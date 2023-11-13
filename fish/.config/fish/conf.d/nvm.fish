if [ -f ~/.nvm/nvm.sh ]
  function nvm
    if test -n "$argv[1]"
      bash -c ". ~/.nvm/nvm.sh && nvm install $argv[1] && nvm use $argv[1] && exec fish"
    else
      bash -c ". ~/.nvm/nvm.sh && nvm use && exec fish"
    end
  end
end
