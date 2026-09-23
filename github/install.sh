#!/bin/sh
echo
echo "> github/install.sh"

if gh auth status >/dev/null 2>&1; then
  echo ">> Already logged in to GitHub"
else
  echo ">> Logging in to GitHub, finish the login in your browser"
  gh auth login --hostname github.com --git-protocol https --web
fi

# Commits are signed with an SSH key stored in 1Password (see shell/gitconfig)
agent_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
signing_key=$(git config user.signingkey)

has_signing_key() {
  SSH_AUTH_SOCK="$agent_sock" ssh-add -L 2>/dev/null | grep -qF "$signing_key"
}

if has_signing_key; then
  echo ">> 1Password SSH agent has the commit signing key"
  exit 0
fi

open -a 1Password
echo ">> 1Password is opening. To turn on its SSH agent:"
echo ">>   1. Unlock 1Password if it's locked"
echo ">>   2. Go to 1Password > Settings > Developer"
echo ">>   3. Turn on \"Use the SSH agent\""
echo ">>   4. If asked how to display keys, choose \"Use Key Names\" (only public keys are saved to disk)"
echo ">> Waiting for the signing key to show up in the agent (Ctrl-C to skip)"
until has_signing_key; do sleep 3; done
echo ">> 1Password SSH agent has the commit signing key"
