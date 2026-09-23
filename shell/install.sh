#!/bin/sh
echo
echo "> Setting up shell"

# Symlink dotfiles from shell/ into ~ (shell/zshrc -> ~/.zshrc).
# Any existing real file is moved to ~/.<name>.backup first.
for name in zshrc zprofile zshenv gitconfig gitignore_global; do
  src="$PWD/shell/$name"
  dest="$HOME/.$name"
  [ -f "$src" ] || continue

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo ">> Backing up $dest to $dest.backup"
    mv "$dest" "$dest.backup"
  fi

  echo ">> Linking $dest"
  ln -sf "$src" "$dest"
done

if [ ! -d ~/.oh-my-zsh ]; then
  echo ">> Installing oh-my-zsh"
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi

echo ">> Create nvm working directory"
mkdir -p ~/.nvm

if [ -s /opt/homebrew/opt/nvm/nvm.sh ]; then
  echo ">> Installing latest node with nvm"
  NVM_DIR="$HOME/.nvm" bash -c '. /opt/homebrew/opt/nvm/nvm.sh && nvm install node'
fi
