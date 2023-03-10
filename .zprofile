# Prompt and title
precmd () {print -Pn "\e]0;%~\a"}
export PROMPT="%m:%~$ "

# Search
alias grep='grep --exclude-dir=".venv" --exclude-dir=".git"'

# Navigation
alias ls='ls --color'
alias ll='ls -alhG'
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m'
function gtouch {
  touch $1
  git add $1
}

# yadm
alias ys='yadm status'
alias yd='yadm diff'
alias ya='yadm add'
alias yc='yadm commit -m'

# Misc
alias cat='bat'
alias sudo='sudo '

# ARM Development
export GCC_PATH=/Applications/ARM/bin

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
export PYTHONSTARTUP="${HOME}/.startup.py"
export PATH="$HOME/python_scripts:$PATH"

# Vim
alias vim='nvim'
export EDITOR=nvim
export SYSTEMD_EDITOR="$EDITOR"
export FCEDIT="$EDITOR"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"


# Secrets
test -f ~/.zsecrets && source ~/.zsecrets

# System specific stuff
test -f ~/.zsystem && source ~/.zsystem

# Kitty nonsense
#alias ssh="kitty +kitten ssh"

# python applications
export PATH="$HOME/.local/bin:$PATH"

if [[ `uname` == "Darwin" ]]; then
  # MacOS
  eval "$(/opt/homebrew/bin/brew shellenv)"
  alias brew='arch -arm64 brew'
else
  # debian
  export PATH=$PATH:/snap/bin
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# misc keybindings
bindkey "\E[1~" beginning-of-line
bindkey "\E[4~" end-of-line
bindkey "\E[H" beginning-of-line
bindkey "\E[F" end-of-line
bindkey "\E[3~" delete-char
bindkey "^[OF" end-of-line
bindkey "^[OH" beginning-of-line


# Pushes to the remote that the PR was created from
# Useful for open source projects that allows maintainers to edit
# Requires "brew install jq"
# Requires "brew install github/gh/gh"
function pr_push {
  ORG_AND_REPO=$(git remote get-url origin | sed -E 's/^.*github.com[:\/]?([^\/]*)\/(.*)\.git$/\1\/\2/')
  REMOTE_URL=$(curl https://api.github.com/repos/$ORG_AND_REPO/pulls/${1:?"The PR number must be specified"} | jq .head.repo.ssh_url | tr -d '"')
  BRANCH=$(git rev-parse --abbrev-ref HEAD)

  echo "Going to execute: git push $REMOTE_URL $BRANCH"

  $(git push $REMOTE_URL $BRANCH)
}

# Push equivalent of https://cli.github.com/manual/gh_pr_checkout
# gh pr push <pr_number>
gh() {
  if [ "$1" = "pr" ] && [ "$2" = "push" ]; then
    pr_push $3
  else
    command gh "$@"
  fi
}
