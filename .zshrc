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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting macos)
source $ZSH/oh-my-zsh.sh

# =============================================================================
# PATH
# =============================================================================
export PATH=$PATH:/usr/local/bin

# =============================================================================
# ENVIRONMENT
# =============================================================================
export EDITOR='nvim'

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

# =============================================================================
# FUNCTIONS
# =============================================================================
mkcd() { mkdir -p "$1" && cd "$1"; }

# =============================================================================
# TOOLS
# =============================================================================
eval "$(zoxide init zsh)"
eval $(thefuck --alias)
source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
source "$(brew --prefix)/opt/fzf/shell/completion.zsh"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# =============================================================================
# SCREENSAVER
# =============================================================================
TMOUT=60
TRAPALRM() { cmatrix -s -C magenta; }

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
