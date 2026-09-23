#!/bin/sh

if xcode-select -p >/dev/null 2>&1; then
  echo ">> Command line tools already installed"
else
  echo ">> Installing command line tools, click Install in the dialog"
  xcode-select --install
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi
