#!/bin/sh

# Trackpad
echo ">> Setup trackpad speed parameters"
defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3

# Mouse
echo ">> Setup mouse scroll parameters"
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -int 1

# Keyboard
echo ">> Setup keyboard speed parameters"
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2
