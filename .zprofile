#export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
#export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# Prompt and title
precmd () {print -Pn "\e]0;%~\a"}
export PROMPT="%~$ "

# Search
alias grep='grep --exclude-dir=".venv" --exclude-dir=".git"'

# Navigation
alias ls='ls --color'
alias ll='ls -alhG'
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Git
alias g='git'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m'
function gtouch {
  touch $1
  git add --intent-to-add $1
}

# yadm
alias ys='yadm status'
alias yd='yadm diff'
alias ya='yadm add'
alias yc='yadm commit -m'

# Misc
alias cat='bat'
alias sudo='sudo '

# Python
export PYTEST_ADDOPTS='--pdbcls=IPython.terminal.debugger:Pdb'
alias p='poetry run python -m pytest -s -x --pdb'
alias pdb='poetry run python -m ipdb -c "c"'

# ARM Development
export GCC_PATH=/opt/homebrew/bin/

# Python
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PYTHONSTARTUP="${HOME}/.startup.py"
export PATH="$HOME/python_scripts:$PATH"
export PYTHONBREAKPOINT=ipdb.set_trace

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

# Kill all unattached tmux sessions.
alias tmux-clean="tmux ls | grep -v attached | awk -F: '{print \$1}' | xargs -I{} tmux kill-session -t {}"

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

# QMK
export QMK_HOME='~/projects/qmk_firmware'

# PngCrush
# Function to pngcrush all PNG files in the current directory
pngcrush_all() {
  if command -v pngcrush >/dev/null; then
    for file in ./*.png; do
      if [ -f "$file" ]; then
        pngcrush -ow -brute "$file"
        echo "Compressed: $file"
      fi
    done
  else
    echo "Error: pngcrush is not installed. Please install it and try again."
  fi
}

function cumulative_size() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: cumulative_size <folder_path> <extension>"
    return 1
  fi

  folder_path="$1"
  extension="$2"

  if [[ ! -d "$folder_path" ]]; then
    echo "Error: '$folder_path' is not a valid directory"
    return 1
  fi

  total_size=0

  while IFS= read -r -d '' file; do
    file_size=$(stat -f%z "$file")
    total_size=$((total_size + file_size))
  done < <(find "$folder_path" -type f -iname "*.${extension}" -print0)

  formatted_size=$(printf "%'.f" "$total_size")
  echo "Cumulative size of all .${extension} files in '${folder_path}': ${formatted_size} bytes"
}

export PATH=/opt/openocd-git/bin:$PATH

fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit
