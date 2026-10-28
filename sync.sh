#!/bin/zsh
# sync.sh — commit & push config changes.
# .zshrc, .zprofile and .p10k.zsh are symlinked into this repo (see link.sh),
# so only IntelliJ needs copying. nvim lives in its own repo (LSpin/nvim-config).

cd "$(dirname "$0")"

INTELLIJ=$(ls -d "$HOME/Library/Application Support/JetBrains/IntelliJIdea"* 2>/dev/null | sort -V | tail -1)
if [[ -n "$INTELLIJ" ]]; then
  mkdir -p ./intellij/options ./intellij/keymaps
  cp "$INTELLIJ/options/editor-font.xml"  ./intellij/options/ 2>/dev/null
  cp "$INTELLIJ/options/console-font.xml" ./intellij/options/ 2>/dev/null
  cp "$INTELLIJ/options/ide.general.xml"  ./intellij/options/ 2>/dev/null
  cp "$INTELLIJ/keymaps/macOS copy.xml"   ./intellij/keymaps/ 2>/dev/null
fi

# Report Brewfile drift (installed but not listed / listed but not installed)
brew bundle cleanup --file=./Brewfile 2>/dev/null | sed -n '/^Would uninstall/,/^Would `brew cleanup`/p' | sed '$d'
brew bundle check --file=./Brewfile --verbose 2>/dev/null | grep '^→'

git add .
git diff --cached --quiet && echo "Nothing to sync." && exit 0
git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push
