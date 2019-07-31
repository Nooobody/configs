
apt-get update && apt-get upgrade
apt-get install vim git build-essential curl fish tmux fzf silversearcher-ag

chsh -s /usr/bin/fish
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash  

fisher https://github.com/amio/fish-theme-eden

rm ~/.vimrc
ln -s ./.vimrc ~/.vimrc
echo ".vimrc installed!"

rm ~/.tmux.conf
ln -s ./.tmux.conf ~/.tmux.conf
echo ".tmux.conf installed!"

rm -rf ~/.config/fish
ln -s ./fish ~/.config/fish
echo "Fish installed!"
