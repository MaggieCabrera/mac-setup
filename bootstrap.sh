repo_url=https://github.com/MaggieCabrera/mac-setup.git
repo_dir=~/a8c/repos/mac-setup

set -e

# git comes with the command line tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo ">> Installing command line tools, click Install in the dialog"
  xcode-select --install
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

if [ -d "$repo_dir/.git" ]; then
  echo ">> Updating $repo_dir"
  git -C "$repo_dir" pull
else
  echo ">> Cloning $repo_url to $repo_dir"
  mkdir -p "$(dirname "$repo_dir")"
  git clone "$repo_url" "$repo_dir"
fi

cd "$repo_dir"
sh install.sh
