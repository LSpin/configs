#!/bin/zsh

cd "$(dirname "$0")"

cp ~/.zshrc ./.zshrc
rsync -a --exclude='.git' ~/.config/nvim/ ./nvim/

INTELLIJ="$HOME/Library/Application Support/JetBrains/IntelliJIdea2025.3"
if [[ -d "$INTELLIJ" ]]; then
  mkdir -p ./intellij/options ./intellij/keymaps
  cp "$INTELLIJ/options/editor-font.xml"  ./intellij/options/ 2>/dev/null
  cp "$INTELLIJ/options/console-font.xml" ./intellij/options/ 2>/dev/null
  cp "$INTELLIJ/options/ide.general.xml"  ./intellij/options/ 2>/dev/null
  cp "$INTELLIJ/keymaps/macOS copy.xml"   ./intellij/keymaps/ 2>/dev/null
fi

git add .
git diff --cached --quiet && echo "Nothing to sync." && exit 0
git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push
