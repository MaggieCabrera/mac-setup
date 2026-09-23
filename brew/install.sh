#!/bin/sh

echo
echo "> brew/install.sh"
which brew >/dev/null
if test $? -ne 0; then
  echo ">> Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo ">> Brew already installed"
fi

echo ">> Switching off analytics"
brew analytics off

echo ">> Remove any apps not on the Brewfile"
brew bundle cleanup --file=brew/Brewfile --force

echo ">> Checking for apps installed outside of brew"
skip_casks=""
for cask in $(brew bundle list --cask --file=brew/Brewfile); do
  brew list --cask "$cask" >/dev/null 2>&1 && continue
  app=$(brew info --cask "$cask" | sed -n 's/ (App)$//p' | head -1)
  if [ -n "$app" ] && [ -d "/Applications/$app" ]; then
    echo ">> Skipping $cask, /Applications/$app already exists"
    skip_casks="$skip_casks $cask"
  fi
done

echo ">> Installing brew and cask apps"
HOMEBREW_BUNDLE_CASK_SKIP="$skip_casks" brew bundle --file=brew/Brewfile