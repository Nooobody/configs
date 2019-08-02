
if [ (uname) -eq Darwin ]
  function nvm
    bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
  end

  set -x NVM_DIR ~/.nvm
  nvm use default --silent
end

[ -s "$NVM_DIR/nvm.sh" ]; and \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ]; and \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

set -gx PATH ~/.local/bin $PATH
set -x LC_ALL en_US.UTF-8
set -x DOCKER_HOST tcp://localhost:2375
