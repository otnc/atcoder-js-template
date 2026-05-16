#!/bin/sh
set -e

VERSION=$(cat .nvmrc)

# load nvm
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
elif command -v nvm > /dev/null 2>&1; then
  : # already available
else
  echo "nvm is not installed."
  echo "Install from: https://github.com/nvm-sh/nvm"
  exit 1
fi

# Save current version before switching
if command -v node > /dev/null 2>&1; then
  node --version | sed 's/^v//' > .nvm-prev
fi

# check if version is installed
if ! nvm ls "$VERSION" > /dev/null 2>&1; then
  echo "Node.js $VERSION is not installed. Installing..."
  nvm install "$VERSION"
fi

nvm use "$VERSION"
