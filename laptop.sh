#!/bin/bash

set -e

# Symlinks
(
  ln -sf "$PWD/shell/hushlogin" "$HOME/.hushlogin"
)

# Homebrew
BREW="/opt/homebrew"

if [ ! -d "$BREW" ]; then
  sudo mkdir -p "$BREW"
  sudo chflags norestricted "$BREW"
  sudo chown -R "$LOGNAME:admin" "$BREW"
  /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

export PATH="$BREW/bin:$PATH"

brew analytics off
brew update-reset

brew bundle --file=- <<EOF
tap "heroku/brew"
tap "homebrew/cask-versions"
tap "homebrew/services"
tap "thoughtbot/formulae"

brew "asdf"
brew "gh"
brew "git"
brew "gitsh"
brew "heroku"
brew "imagemagick"
brew "libpq"
brew "mas"
brew "parity"
brew "postgres", restart_service: :changed
brew "redis", restart_service: :changed
brew "zsh"

cask "1password"
cask "firefox"
cask "github"
cask "google-chrome"
cask "imageoptim"
cask "iterm2"
cask "ngrok"
cask "sketch"
cask "slack"
cask "spotify"
cask "transmit"
cask "visual-studio-code"
cask "zoom"

mas "Better", id: 1121192229
mas "Contrast", id: 1254981365
mas "Darkroom", id: 953286746
mas "Deliveries", id: 290986013
mas "DuckDuckGo Privacy Essentials", id: 1482920575
mas "Gifox", id: 1461845568
mas "Hush", id: 1544743900
mas "Instapaper Save", id: 1481302432
mas "Magnet", id: 441258766
mas "Notability", id: 360593530
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "Pixelmator Pro", id: 1289583905
mas "Sim Daltonism", id: 693112260
mas "Speedify", id: 999025824
mas "Time Out", id: 402592703
mas "Tweetbot", id: 1384080005
mas "Vinegar", id: 1591303229
mas "Xcode", id: 497799835
EOF
