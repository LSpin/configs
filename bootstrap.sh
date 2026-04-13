#!/bin/zsh
# bootstrap.sh — fresh machine setup from github.com/LSpin/configs

set -e

CONFIGS_REPO="https://github.com/LSpin/configs.git"
CONFIGS_DIR="$HOME/configs"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
info()    { print -P "%F{cyan}➜ $1%f"; }
success() { print -P "%F{green}✔ $1%f"; }
warn()    { print -P "%F{yellow}⚠ $1%f"; }

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------
info "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  success "Homebrew already installed"
fi

# -----------------------------------------------------------------------------
# CLI tools
# -----------------------------------------------------------------------------
info "Installing CLI tools..."
brew install \
  git gh \
  neovim neovim-remote \
  fzf eza bat fd ripgrep \
  zoxide git-delta lazygit \
  btop cmatrix \
  thefuck tldr \
  node python@3.13 \
  asdf wget

$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# -----------------------------------------------------------------------------
# Apps
# -----------------------------------------------------------------------------
info "Installing apps..."
brew install --cask \
  iterm2 \
  visual-studio-code \
  alfred \
  alt-tab \
  google-chrome \
  discord \
  spotify \
  font-cascadia-code-nf

# -----------------------------------------------------------------------------
# Oh My Zsh
# -----------------------------------------------------------------------------
info "Checking Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  success "Oh My Zsh already installed"
fi

# -----------------------------------------------------------------------------
# Zsh plugins
# -----------------------------------------------------------------------------
info "Installing zsh plugins..."
brew install zsh-autosuggestions zsh-syntax-highlighting

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  success "Powerlevel10k already installed"
fi

# -----------------------------------------------------------------------------
# Configs
# -----------------------------------------------------------------------------
info "Pulling configs from GitHub..."
if [[ ! -d "$CONFIGS_DIR" ]]; then
  git clone "$CONFIGS_REPO" "$CONFIGS_DIR"
else
  git -C "$CONFIGS_DIR" pull
fi

info "Linking configs..."
cp "$CONFIGS_DIR/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config"
cp -r "$CONFIGS_DIR/nvim" "$HOME/.config/nvim"

# -----------------------------------------------------------------------------
# Font: Cascadia Code NF
# -----------------------------------------------------------------------------
info "Configuring Cascadia Code NF as default font..."

# VS Code — editor + integrated terminal
python3 - <<'PYEOF'
import json, os

path = os.path.expanduser("~/Library/Application Support/Code/User/settings.json")
os.makedirs(os.path.dirname(path), exist_ok=True)
settings = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            settings = json.load(f)
    except (json.JSONDecodeError, OSError):
        pass
settings["editor.fontFamily"] = "CascadiaCode NF"
settings["terminal.integrated.fontFamily"] = "CascadiaCode NF"
with open(path, "w") as f:
    json.dump(settings, f, indent=2)
PYEOF

# iTerm2 — set font on every profile in the plist
python3 - <<'PYEOF'
import plistlib, os, subprocess

plist = os.path.expanduser("~/Library/Preferences/com.googlecode.iterm2.plist")
font  = "CascadiaCodeNF-Regular 18"

if os.path.exists(plist):
    subprocess.run(["plutil", "-convert", "xml1", plist], check=True)
    with open(plist, "rb") as f:
        prefs = plistlib.load(f)
    for profile in prefs.get("New Bookmarks", []):
        profile["Normal Font"]    = font
        profile["Non Ascii Font"] = font
    with open(plist, "wb") as f:
        plistlib.dump(prefs, f, fmt=plistlib.FMT_XML)
PYEOF

success "Font configured (VS Code, iTerm2)"

# -----------------------------------------------------------------------------
# Git delta
# -----------------------------------------------------------------------------
info "Configuring git delta..."
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.side-by-side true

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
success "Done! Open a new terminal or run: source ~/.zshrc"
warn "Run 'p10k configure' to set up your prompt."
