###########################################################################################
# OH-MY-ZSH
###########################################################################################

export ZSH=$HOME/.oh-my-zsh

# Use INIT_ZSH_THEME environment variable if set, otherwise default to codespaces
if [[ -n "$INIT_ZSH_THEME" ]]; then
    ZSH_THEME="$INIT_ZSH_THEME"
else
    ZSH_THEME="codespaces"
fi

# Use INIT_ZSH_PLUGINS environment variable if set, otherwise no plugins
if [[ -n "$INIT_ZSH_PLUGINS" ]]; then
    plugins=(${=INIT_ZSH_PLUGINS})
else
    # No plugins if INIT_ZSH_PLUGINS is not set
    plugins=()
fi

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
# EXPORTS
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
alias config="cursor /home/vscode/"
alias rr="run routine"

###########################################################################################
# THE END
###########################################################################################
