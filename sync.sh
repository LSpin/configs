#!/bin/zsh

cp ~/.zshrc ./.zshrc
rsync -a --exclude='.git' ~/.config/nvim/ ./nvim/

INTELLIJ="$HOME/Library/Application Support/JetBrains/IntelliJIdea2025.3"
cp "$INTELLIJ/options/editor-font.xml"  ./intellij/options/
cp "$INTELLIJ/options/console-font.xml" ./intellij/options/
cp "$INTELLIJ/options/ide.general.xml"  ./intellij/options/
cp "$INTELLIJ/keymaps/macOS copy.xml"   ./intellij/keymaps/

git add .
git diff --cached --quiet && echo "Nothing to sync." && exit 0
git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push
