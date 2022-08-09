if [ -f ~/.nvm/nvm.sh ]
  function nvm
    bash -c ". ~/.nvm/nvm.sh && nvm install $argv[1] && nvm use $argv[1] && exec fish"
  end
end
