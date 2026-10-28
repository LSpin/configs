# =============================================================================
# SPLASH SCREEN
# =============================================================================
cat << 'SPLASH'
  *       .    *     .       *
    .   /\_____/\       *
       /  ^   ^  \   .
  *   ( ==  v  == )      meow. from orbit.
    .  )         (       meow. no gravity, no bugs.
  *   (  |     |  )  .   meow. the void fears me.
       \_|_____|_/
    .   ~~(O)~~    *   .
  *           .       *

SPLASH

# =============================================================================
# POWERLEVEL10K - must stay at the top
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# OH MY ZSH
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"
plugins=(git macos zsh-syntax-highlighting fzf docker)
source $ZSH/oh-my-zsh.sh

# =============================================================================
# PATH
# =============================================================================
export PATH=$PATH:/usr/local/bin

# =============================================================================
# ENVIRONMENT
# =============================================================================
export EDITOR='nvim'
export JAVA_HOME=$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# secrets / machine-specific exports live here (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# =============================================================================
# HISTORY
# =============================================================================
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

# =============================================================================
# NAVIGATION
# =============================================================================
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# =============================================================================
# ALIASES
# =============================================================================
# git
alias ga='git add'
alias gs='git status'
alias gpl='git pull'
alias gpsh='git push'

# modern replacements
alias ls='eza --icons'
alias cat='bat'
alias find='fd'

# gh copilot
alias ghcs='gh copilot suggest'
alias ghce='gh copilot explain'

# brew
alias buu='brew update && brew upgrade'

# =============================================================================
# FUNCTIONS
# =============================================================================
mkcd() { mkdir -p "$1" && cd "$1"; }

# =============================================================================
# TOOLS
# =============================================================================
eval "$(zoxide init zsh)"
eval $(thefuck --alias)
command -v mise &>/dev/null && eval "$(mise activate zsh)"
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
source "$(brew --prefix)/opt/fzf/shell/completion.zsh"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# =============================================================================
# SCREENSAVER
# =============================================================================
TMOUT=120
TRAPALRM() { cmatrix -s -C magenta; }

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
