# Preparation
1. Fork this repo
2. Update `brew/Brewfile` with your preferred apps
3. Replace your GH username in all files
4. Add your dotfiles to `shell/` without the leading dot (see [Dotfiles](#dotfiles))

# Setting up your machine

## Before you start
1. Sign in to the App Store (needed for Xcode and Slack)
2. Sign in to 1Password (needed for SSH keys and commit signing)

## Run the setup

On a new Mac, run:

```bash
bash <(curl -s https://raw.githubusercontent.com/MaggieCabrera/mac-setup/main/bootstrap.sh)
```

This clones the repo to `~/a8c/repos/mac-setup` (or updates it if it's already there) and runs `install.sh` from it. The repo has to stay there: your dotfiles and iTerm2 settings are linked to it.

If the repo is already cloned, run it from there instead:

```bash
cd ~/a8c/repos/mac-setup && sh install.sh
```

`install.sh` is safe to re-run. Casks whose app is already in `/Applications` (installed outside of brew) are skipped.

## What the setup does

1. Installs the command line tools (`xcode/install.sh`)
2. Installs Homebrew and everything in `brew/Brewfile` (`brew/install.sh`)
3. Links your dotfiles, installs oh-my-zsh and installs the latest node with nvm (`shell/install.sh`)
4. Links your VS Code settings (`vscode/install.sh`)
5. Points iTerm2 at the settings in this repo (`iterm/install.sh`)
6. Applies macOS settings: dock, trackpad, keyboard, Finder (`osx/install.sh`)
7. Logs you in to GitHub and checks that 1Password can sign your commits (`github/install.sh`)

## While it runs

- **Command line tools:** on a brand-new Mac, a dialog asks to install them. Click **Install**; the script waits until it's done.
- **Password:** you'll be asked for your Mac password a few times (installing Homebrew, some apps).
- **Homebrew:** press Return when the Homebrew installer asks to continue.
- **GitHub:** your browser opens to log in to GitHub. Copy the code the terminal shows into the browser.
- **1Password SSH agent:** if it's off, 1Password opens. Unlock it, go to **Settings → Developer**, turn on **Use the SSH agent**, and choose **Use Key Names** if it asks how to display keys. The script continues on its own. Your commit signing key lives in 1Password, so this is what makes `git commit` work.

## Manual steps afterwards

Do these by hand:

1. **Rename the Mac** (optional): System Settings → General → About → Name. The setup doesn't depend on the name, so do this whenever you like.
2. **Log out and back in** to apply the macOS settings.
3. **SSH keys** (only for servers outside 1Password): copy `~/.ssh/config` and any keys you need from the old machine, then run `chmod 600 ~/.ssh/id_*`. Skip the AutoProxxy files (`a8c-*.config`, `autoproxxy*`); AutoProxxy regenerates them. Not needed for GitHub.
4. **iStat Menus:** install it (Setapp), restore the backup, then hide the macOS time and battery icons.
5. **Repos:** run `sh repos/clone.sh` to clone your repos.

# Dotfiles

`shell/install.sh` symlinks these files from `shell/` into your home folder, if they exist:

| Repo file | Linked to |
|---|---|
| `shell/zshrc` | `~/.zshrc` |
| `shell/zprofile` | `~/.zprofile` |
| `shell/zshenv` | `~/.zshenv` |
| `shell/gitconfig` | `~/.gitconfig` |
| `shell/gitignore_global` | `~/.gitignore_global` |

Existing files are moved to `~/.<name>.backup` before linking. Because they're symlinks, editing `~/.zshrc` edits the file in the repo, so commit your changes.

This repo is public, so never commit secrets (API keys, tokens) or private hostnames to these files.

# VS Code

`vscode/install.sh` links `vscode/settings.json` (and `keybindings.json` or `snippets/`, if you add them) into `~/Library/Application Support/Code/User`. Extensions are listed in `brew/Brewfile` as `vscode "publisher.extension"` lines and installed by `brew bundle`.

Don't turn on VS Code Settings Sync as well; it would overwrite the linked files.

# iTerm2

`iterm/install.sh` tells iTerm2 to load its settings from `iterm/com.googlecode.iterm2.plist` and to save changes back there automatically. Commit the file after changing settings.

The settings contain nothing specific to one Mac, so the same file works on every machine. Quit iTerm2 before running the script for the first time, or it overwrites the change when it quits.

# Updating the codebase over time

## Brew packages
```bash
rm -f brew/Brewfile && brew bundle dump --file=brew/Brewfile
```

# After installing

## MySQL

MySQL is installed without a root password and only allows connections from localhost.

```bash
mysql_secure_installation   # set a root password
brew services start mysql   # start now and at login
mysql -u root               # connect
```

A `/etc/my.cnf` or `/etc/mysql/my.cnf` from another install may interfere with the Homebrew server starting up.

## PHP

```bash
brew services start php     # start php-fpm now and at login
```

`php.ini` and `php-fpm.ini` are in `/opt/homebrew/etc/php/<version>/`.

## Docker plugins

For Docker to find the Homebrew `buildx` and `compose` plugins, add this to `~/.docker/config.json`:

```json
"cliPluginsExtraDirs": [
    "/opt/homebrew/lib/docker/cli-plugins"
]
```

## Python

Homebrew's Python 3.11 is at `/opt/homebrew/bin/python3.11`. Use `pyenv` to install and switch between other versions.
