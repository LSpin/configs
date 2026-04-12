#!/bin/zsh

cp ~/.zshrc ./.zshrc
rsync -a --exclude='.git' ~/.config/nvim/ ./nvim/

git add .
git diff --cached --quiet && echo "Nothing to sync." && exit 0
git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push
