
if [ (uname) -eq Darwin ]
  function nvm
    bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
  end

  set -x NVM_DIR ~/.nvm
  nvm use default --silent
end

export PATH="$HOME/Library/Android/sdk/tools:$HOME/Library/Android/sdk/platform-tools:$PATH"
