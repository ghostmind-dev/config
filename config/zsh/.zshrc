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
# SHELL INITIALIZATION
###########################################################################################

# Function to load and expand environment variables from .env files
load_env_files() {
    local current_dir="$(pwd)"
    local env_base="$current_dir/.env.base"
    local env_local="$current_dir/.env.local"
    
    # Check if either .env file exists
    if [[ -f "$env_base" ]] || [[ -f "$env_local" ]]; then
        # Create a temporary file to process all variables together
        local temp_env=$(mktemp)
        local has_project=false
        
        # Load .env.base first (if exists)
        if [[ -f "$env_base" ]]; then
            # Remove comments and empty lines, then add to temp file
            grep -E '^[^#]*=' "$env_base" >> "$temp_env" 2>/dev/null
            # Check if PROJECT is already defined
            if grep -q '^PROJECT=' "$env_base" 2>/dev/null; then
                has_project=true
            fi
        fi
        
        # Load .env.local second (if exists) - this allows local to override base
        if [[ -f "$env_local" ]]; then
            # Remove comments and empty lines, then add to temp file
            grep -E '^[^#]*=' "$env_local" >> "$temp_env" 2>/dev/null
            # Check if PROJECT is already defined
            if grep -q '^PROJECT=' "$env_local" 2>/dev/null; then
                has_project=true
            fi
        fi
        
        # Load APP from current folder's meta.json
        local current_meta="$current_dir/meta.json"
        if [[ -f "$current_meta" ]]; then
            local app_name=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$current_meta" 2>/dev/null | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
            if [[ -n "$app_name" ]]; then
                echo "APP=$app_name" >> "$temp_env"
            fi
        fi
        
        # Load PROJECT from SRC folder's meta.json (only if not already set)
        if [[ "$has_project" == false ]] && [[ -n "$SRC" ]]; then
            local src_meta="$SRC/meta.json"
            if [[ -f "$src_meta" ]]; then
                local project_name=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$src_meta" 2>/dev/null | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
                if [[ -n "$project_name" ]]; then
                    echo "PROJECT=$project_name" >> "$temp_env"
                fi
            fi
        fi
        
        # Use dotenv-cli with expansion if available
        if command -v dotenv >/dev/null 2>&1; then
            
            # Get list of our variable names first
            local our_vars=()
            while IFS='=' read -r key value; do
                if [[ -n "$key" ]] && [[ -n "$value" ]]; then
                    our_vars+=("$key")
                fi
            done < "$temp_env"
            
            # Create a combined .env file for dotenv-cli
            local combined_env=$(mktemp)
            cp "$temp_env" "$combined_env"
            
            # Use dotenv-cli to expand variables and capture only our variables
            local success=false
            local loaded_count=0
            for var_name in "${our_vars[@]}"; do
                local expanded_value=$(dotenv -e "$combined_env" -x -- sh -c "echo \$$var_name" 2>/dev/null || echo "")
                if [[ -n "$expanded_value" ]]; then
                    export "$var_name"="$expanded_value"
                    loaded_count=$((loaded_count + 1))
                    success=true
                fi
            done
            
            
            if [[ "$success" == false ]]; then
                # Fallback to simple expansion
                local fallback_count=0
                while IFS='=' read -r key value; do
                    if [[ -n "$key" ]] && [[ -n "$value" ]]; then
                        # Remove quotes if present
                        clean_value=$(echo "$value" | sed 's/^["'\'']//' | sed 's/["'\'']$//')
                        
                        # Simple variable expansion
                        expanded_value=$(eval "echo \"$clean_value\"" 2>/dev/null || echo "$clean_value")
                        export "$key"="$expanded_value"
                        fallback_count=$((fallback_count + 1))
                    fi
                done < "$temp_env"
            fi
            
            rm "$combined_env"
        else
            # Fallback to simple expansion
            local manual_count=0
            while IFS='=' read -r key value; do
                if [[ -n "$key" ]] && [[ -n "$value" ]]; then
                    # Remove quotes if present
                    clean_value=$(echo "$value" | sed 's/^["'\'']//' | sed 's/["'\'']$//')
                    
                    # Simple variable expansion
                    expanded_value=$(eval "echo \"$clean_value\"" 2>/dev/null || echo "$clean_value")
                    export "$key"="$expanded_value"
                    manual_count=$((manual_count + 1))
                fi
            done < "$temp_env"
        fi
        
        # Clean up temp file
        rm "$temp_env"
    
 
    fi
}

# Load environment variables when shell starts
load_env_files

###########################################################################################
# THE END
###########################################################################################
