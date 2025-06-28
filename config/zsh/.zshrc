###########################################################################################
# OH-MY-ZSH
###########################################################################################

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="codespaces"

plugins=(git kubectl zsh-autosuggestions gcloud docker)

source $ZSH/oh-my-zsh.sh

DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true

# Get relative path
relative_path() {
    echo "${PWD/$1/}"
}

# Get current git branch
git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        # need to a run command to change color on demand
        # echo "%F{blue}(%{\e[38;5;214m%}$branch%F{blue})"
        echo "%F{blue}(%{\e[38;5;213m%}$branch%F{blue})"
    fi
}

# Define the prompt
PROMPT='%F{black}➜ %F{green}$(relative_path $SRC) %F{blue}$(git_branch)%f '

###########################################################################################
# DEVCONTAINER SHELL HISTORY
###########################################################################################

export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history

###########################################################################################
# GAM
###########################################################################################

if [ -n "$CODESPACES" ]; then
    export LOCALHOST_SRC=${SRC}
fi

###########################################################################################
# GAM
###########################################################################################

alias gam="/home/vscode/bin/gam/gam"

###########################################################################################
# PYENV
###########################################################################################

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

###########################################################################################
# BUN
###########################################################################################

export PATH=$PATH:/home/vscode/.npm-global/bin
export PATH=$PATH:/home/vscode/.deno/bin
export PATH=$PATH:/home/vscode/.local/bin
export PATH=$PATH:/home/vscode/go/bin

###########################################################################################
# ALIASES
###########################################################################################

alias home="cd ${SRC}"
alias dev="cd ${SRC}/dev"

###########################################################################################
# THE END
###########################################################################################
