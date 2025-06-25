#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$HOME/.dotfiles_symlinks.log"

log() {
  echo "[dotfiles] $1"
}

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Neovim (>= 0.8) if needed
if ! command -v nvim >/dev/null || [ "$(nvim --version | head -n1 | awk '{print $2}')" \< "0.8" ]; then
  echo "Installing Neovim >= 0.8..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  tar -xzf nvim-linux64.tar.gz
  sudo mv nvim-linux64 /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
fi


link_file() {
  local src="$1"
  local dest="$2"

  # Backup existing non-symlink files
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    log "Backing up $dest → $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -sf "$src" "$dest"
  echo "$dest" >> "$LOG_FILE"
  log "Linked: $dest → $src"
}

install_symlinks() {
  log "Linking dotfiles..."
  > "$LOG_FILE"  # reset the log

  # Link top-level dotfiles
  link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
  # link_file "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
}

uninstall_symlinks() {
  log "Unlinking dotfiles..."
  if [[ ! -f "$LOG_FILE" ]]; then
    log "No log file found — nothing to undo."
    return
  fi

  while read -r dest; do
    if [[ -L "$dest" ]]; then
      rm "$dest"
      log "Removed symlink: $dest"
    else
      log "Skipped non-symlink: $dest"
    fi
  done < "$LOG_FILE"

  rm -f "$LOG_FILE"
  log "Done."
}

case "${1:-install}" in
  install)
    install_symlinks
    ;;
  uninstall)
    uninstall_symlinks
    ;;
  *)
    echo "Usage: ./install.sh [install|uninstall]"
    ;;
esac

# installing tmux plugins

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ ! -d "$TPM_DIR" ]]; then
  echo "Cloning TPM into $TPM_DIR..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already installed at $TPM_DIR"
fi

chmod +x "$TPM_DIR/tpm"

if pgrep -x tmux >/dev/null; then
  echo "Reloading tmux config and installing plugins..."
  tmux source-file ~/.tmux.conf
  echo "Inside tmux, press prefix + I to install plugins."
else
  echo "Tmux is not running. Please start tmux and press prefix + I to install plugins."
fi
