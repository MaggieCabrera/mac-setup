#!/bin/sh
echo
echo "> iterm/install.sh"

echo ">> Load iTerm2 settings from $PWD/iterm"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$PWD/iterm"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo ">> Save iTerm2 settings changes back to the repo automatically"
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 1
