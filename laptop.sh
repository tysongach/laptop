#!/bin/bash

set -e

# Symlinks
(
  ln -sf "$PWD/asdf/asdfrc" "$HOME/.asdfrc"
  ln -sf "$PWD/asdf/tool-versions" "$HOME/.tool-versions"

  ln -sf "$PWD/git/gitconfig" "$HOME/.gitconfig"
  ln -sf "$PWD/git/gitignore" "$HOME/.gitignore"
  ln -sf "$PWD/git/gitmessage" "$HOME/.gitmessage"

  ln -sf "$PWD/ruby/gemrc" "$HOME/.gemrc"
  ln -sf "$PWD/ruby/rspec" "$HOME/.rspec"

  ln -sf "$PWD/shell/hushlogin" "$HOME/.hushlogin"
  ln -sf "$PWD/shell/zshrc" "$HOME/.zshrc"
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

# Shell
update_shell() {
  sudo chown -R "$(whoami)" "$BREW/share/zsh" "$BREW/share/zsh/site-functions"
  chmod u+w "$BREW/share/zsh" "$BREW/share/zsh/site-functions"
  shellpath="$(command -v zsh)"

  if ! grep "$shellpath" /etc/shells > /dev/null 2>&1 ; then
    sudo sh -c "echo $shellpath >> /etc/shells"
  fi

  chsh -s "$shellpath"
}

case "$SHELL" in
  */zsh)
    if [ "$(command -v zsh)" != "$BREW/bin/zsh" ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

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
asdf install ruby 2.7.4

# Node.js
add_or_update_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
asdf install nodejs 16.13.1
