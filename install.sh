#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$HOME/.dotfiles_symlinks.log"

log() {
  echo "[dotfiles] $1"
}

export CHSH=no
export RUNZSH=no
export ZSH="$HOME/.oh-my-zsh"

# Install Oh My Zsh
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
  log "Installing Oh My Zsh..."
  RUNZSH=no  # prevent it from auto-launching
  CHSH=no    # don't auto-change shell
  export ZSH="$OH_MY_ZSH_DIR"

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  log "Oh My Zsh installed at $OH_MY_ZSH_DIR"
else
  log "Oh My Zsh already installed."
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

NEOVIM_VERSION="v0.8.0"
NEOVIM_TARBALL="nvim-linux64.tar.gz"
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/${NEOVIM_TARBALL}"

echo "[+] Downloading Neovim ${NEOVIM_VERSION}..."
curl -LO "$NEOVIM_URL"

echo "[+] Extracting Neovim..."
tar -xzf "$NEOVIM_TARBALL"

echo "[+] Moving Neovim to /opt/nvim..."
sudo mv nvim-linux64 /opt/nvim

echo "[+] Creating symlink to /usr/local/bin/nvim..."
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

echo "[✓] Neovim $(nvim --version | head -n1) installed!"

rm -f "$NEOVIM_TARBALL"
