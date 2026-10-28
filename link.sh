#!/bin/zsh
# link.sh — symlink dotfiles from this repo into $HOME.
# Anything already in the way is moved to ~/.dotfiles-backup/<timestamp>/.

set -e

CONFIGS_DIR="${0:A:h}"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$CONFIGS_DIR/$1" dest="$2"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    print -P "%F{green}✔ $dest already linked%f"
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
    print -P "%F{yellow}⚠ moved existing $dest → $BACKUP_DIR/%f"
  fi
  mkdir -p "${dest:h}"
  ln -s "$src" "$dest"
  print -P "%F{green}✔ $dest → $src%f"
}

link .zshrc    "$HOME/.zshrc"
link .zprofile "$HOME/.zprofile"
link .p10k.zsh "$HOME/.p10k.zsh"

if [[ -f "$BACKUP_DIR/.zshrc" && ! -f "$HOME/.zshrc.local" ]]; then
  print -P "%F{yellow}⚠ Old .zshrc backed up — move any secrets/machine-specific exports into ~/.zshrc.local (not tracked)%f"
fi
