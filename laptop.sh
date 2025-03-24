#!/bin/bash

set -e

# Symlinks
(
  ln -sf "$PWD/asdf/asdfrc" "$HOME/.asdfrc"
  ln -sf "$PWD/asdf/tool-versions" "$HOME/.tool-versions"

  ln -sf "$PWD/git/gitconfig" "$HOME/.gitconfig"
  ln -sf "$PWD/git/gitignore" "$HOME/.gitignore"
  ln -sf "$PWD/git/gitmessage" "$HOME/.gitmessage"

  ln -sf "$PWD/ruby/default-gems" "$HOME/.default-gems"
  ln -sf "$PWD/ruby/gemrc" "$HOME/.gemrc"
  ln -sf "$PWD/ruby/rspec" "$HOME/.rspec"

  ln -sf "$PWD/shell/hushlogin" "$HOME/.hushlogin"
  ln -sf "$PWD/shell/zshrc" "$HOME/.zshrc"
)

# Homebrew
BREW="/opt/homebrew"

if [ ! -d "$BREW" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
brew "mas"
brew "parity"
brew "redis", restart_service: :changed
brew "stripe/stripe-cli/stripe"
brew "zsh"
brew "zsh-autosuggestions"

cask "1password"
cask "choosy"
cask "docker"
cask "firefox"
cask "github"
cask "google-chrome"
cask "imageoptim"
cask "iterm2"
cask "ngrok"
cask "notunes"
cask "postico"
cask "sketch"
cask "slack"
cask "transmit"
cask "visual-studio-code"
cask "zoom"

mas "DuckDuckGo Privacy Essentials", id: 1482920575
mas "Harvest", id: 506189836
mas "Hush", id: 1544743900
mas "Instapaper Save", id: 1481302432
mas "Lightweight PDF 2", id: 6737913061
mas "Magnet", id: 441258766
mas "Pixelmator Pro", id: 1289583905
mas "Sim Daltonism", id: 693112260
mas "Time Out", id: 402592703
mas "ToothFairy", id: 1191449274
mas "Vinegar", id: 1591303229
EOF

# Shell
if [ "$(command -v zsh)" != "$BREW/bin/zsh" ] ; then
  sudo chown -R "$(whoami)" "$BREW/share/zsh" "$BREW/share/zsh/site-functions"
  chmod u+w "$BREW/share/zsh" "$BREW/share/zsh/site-functions"
  shellpath="$(command -v zsh)"

  if ! grep "$shellpath" /etc/shells > /dev/null 2>&1 ; then
    sudo sh -c "echo $shellpath >> /etc/shells"
  fi

  chsh -s "$shellpath"
fi

# asdf
add_or_update_asdf_plugin() {
  local name="$1"
  local url="$2"

  if ! asdf plugin-list | grep -Fq "$name"; then
    asdf plugin-add "$name" "$url"
  else
    asdf plugin-update "$name"
  fi
}

# Ruby
add_or_update_asdf_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
asdf install ruby 2.4.2

# Node.js
add_or_update_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
asdf install nodejs 22.14.0
