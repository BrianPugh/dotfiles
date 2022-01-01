# Prompt and title
precmd () {print -Pn "\e]0;%~\a"}
export PROMPT="%m:%~$ "

# Navigation
alias ll='ls -alhG'
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m'

# yadm
alias ys='yadm status'
alias yd='yadm diff'
alias ya='yadm add'
alias yc='yadm commit -m'

# Misc
alias cat='bat'

# ARM Development
export GCC_PATH=/Applications/ARM/bin

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
export PYTHONSTARTUP="${HOME}/.startup.py"
export PATH="/Users/brianpugh/python_scripts:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Vim
alias vim='nvim'
