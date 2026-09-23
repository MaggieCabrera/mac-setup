#!/bin/sh
echo
echo "> vscode/install.sh"

# Symlink VS Code settings from vscode/ into its user folder.
# Any existing real file is moved to <name>.backup first.
user_dir="$HOME/Library/Application Support/Code/User"
mkdir -p "$user_dir"

for name in settings.json keybindings.json snippets; do
  src="$PWD/vscode/$name"
  dest="$user_dir/$name"
  [ -e "$src" ] || continue

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo ">> Backing up $dest to $dest.backup"
    mv "$dest" "$dest.backup"
  fi

  echo ">> Linking $dest"
  ln -sfn "$src" "$dest"
done
