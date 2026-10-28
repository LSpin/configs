#!/bin/zsh
# bootstrap.sh — fresh machine setup from github.com/LSpin/configs
# Safe to re-run.

set -e

CONFIGS_REPO="https://github.com/LSpin/configs.git"
CONFIGS_DIR="$HOME/configs"
NVIM_REPO="LSpin/nvim-config"
NVIM_DIR="$HOME/.config/nvim"
NERD_FONT="CourierPrimeCodeNerdFont-Regular"

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
if [[ ! -x /opt/homebrew/bin/brew ]]; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  success "Homebrew already installed"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# -----------------------------------------------------------------------------
# Configs repo
# -----------------------------------------------------------------------------
info "Pulling configs from GitHub..."
if [[ ! -d "$CONFIGS_DIR" ]]; then
  git clone "$CONFIGS_REPO" "$CONFIGS_DIR"
else
  git -C "$CONFIGS_DIR" pull
fi

# -----------------------------------------------------------------------------
# Packages, apps & fonts (Brewfile)
# -----------------------------------------------------------------------------
info "Installing Brewfile..."
brew bundle --file="$CONFIGS_DIR/Brewfile" || warn "Some Brewfile entries failed — see output above"

# -----------------------------------------------------------------------------
# Oh My Zsh
# -----------------------------------------------------------------------------
info "Checking Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  success "Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  info "Installing zsh-syntax-highlighting (OMZ plugin)..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  success "zsh-syntax-highlighting already installed"
fi

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  success "Powerlevel10k already installed"
fi

# -----------------------------------------------------------------------------
# Dotfiles (.zshrc, .zprofile, .p10k.zsh) — symlinked into the repo
# -----------------------------------------------------------------------------
info "Linking configs..."
"$CONFIGS_DIR/link.sh"

# Neovim — separate private repo (github.com/LSpin/nvim-config)
info "Setting up Neovim config..."
if [[ -d "$NVIM_DIR/.git" ]]; then
  git -C "$NVIM_DIR" pull
elif [[ -e "$NVIM_DIR" ]]; then
  warn "$NVIM_DIR exists but isn't a git repo — skipping (move it aside and re-run)"
else
  gh auth status &>/dev/null || gh auth login
  gh auth setup-git
  gh repo clone "$NVIM_REPO" "$NVIM_DIR"
fi

# IntelliJ — find whichever version dir exists (created on first launch)
INTELLIJ_DIR=$(ls -d "$HOME/Library/Application Support/JetBrains/IntelliJIdea"* 2>/dev/null | sort -V | tail -1)
if [[ -n "$INTELLIJ_DIR" ]]; then
  mkdir -p "$INTELLIJ_DIR/options" "$INTELLIJ_DIR/keymaps"
  cp "$CONFIGS_DIR/intellij/options/"*.xml "$INTELLIJ_DIR/options/"
  cp "$CONFIGS_DIR/intellij/keymaps/"*.xml "$INTELLIJ_DIR/keymaps/"
  success "IntelliJ config applied → $INTELLIJ_DIR"
else
  warn "IntelliJ config dir not found — launch IntelliJ once, then re-run bootstrap"
fi

# -----------------------------------------------------------------------------
# Font: Courier Prime Code (Nerd Font patched)
# -----------------------------------------------------------------------------
if [[ -f "$HOME/Library/Fonts/$NERD_FONT.ttf" ]]; then
  success "Courier Prime Code Nerd Font already installed"
else
  info "Patching and installing Courier Prime Code Nerd Font..."
  FONT_TMP=$(mktemp -d)
  curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip -o "$FONT_TMP/FontPatcher.zip"
  unzip -oq "$FONT_TMP/FontPatcher.zip" -d "$FONT_TMP/FontPatcher"
  fontforge -script "$FONT_TMP/FontPatcher/font-patcher" \
    "$HOME/Library/Fonts/Courier Prime Code.ttf" \
    --complete \
    --outputdir "$FONT_TMP/patched/"
  cp "$FONT_TMP/patched/$NERD_FONT.ttf" "$HOME/Library/Fonts/"
  rm -rf "$FONT_TMP"
  success "Courier Prime Code Nerd Font installed"
fi

# VS Code — editor + integrated terminal
NERD_FONT="$NERD_FONT" python3 - <<'PYEOF'
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
settings["editor.fontFamily"] = os.environ["NERD_FONT"]
settings["terminal.integrated.fontFamily"] = os.environ["NERD_FONT"]
with open(path, "w") as f:
    json.dump(settings, f, indent=2)
PYEOF

# iTerm2 — dynamic profile (inherits from "Default", overrides the font) set as default
ITERM_PROFILES="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$ITERM_PROFILES"
cp "$CONFIGS_DIR/iterm2/configs.json" "$ITERM_PROFILES/configs.json"
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "lspin-configs-profile"

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
# Java (OpenJDK 21)
# -----------------------------------------------------------------------------
info "Configuring Java..."
JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
if [[ -d "$JAVA_HOME" ]]; then
  sudo ln -sfn "$(brew --prefix openjdk@21)/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-21.jdk
  success "OpenJDK 21 linked"
else
  warn "OpenJDK 21 not found at expected path"
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
success "Done! Open a new terminal or run: source ~/.zshrc"
warn "Put secrets / machine-specific exports in ~/.zshrc.local (not tracked)."
warn "Docker: run 'colima start' to get a container engine."
