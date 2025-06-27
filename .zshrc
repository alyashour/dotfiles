# Core Zsh settings (always at the top)
autoload -Uz compinit
compinit
setopt auto_cd
setopt extended_glob
setopt inc_append_history
setopt share_history
HISTSIZE=10000
SAVEHIST=10000

# Enable prompt substitution so command substitutions and function calls work in PS1
setopt PROMPT_SUBST

# Determine OS
case "$(uname -s)" in
    Darwin)
        OS_TYPE="macos"
        ;;
    Linux)
        OS_TYPE="linux"
        ;;
    CYGWIN*|MSYS*|MINGW*)
        OS_TYPE="windows" # For WSL/Git Bash/MSYS2 if you use them
        ;;
    *)
        OS_TYPE="unknown"
        ;;
esac

# Source common configuration files
# These files are located via the symlink created by setup.sh:
# ~/dotfiles/zsh/common/  ->  ~/.config/zsh/common/
if [[ -d "$HOME/.config/zsh/common" ]]; then
    for config_file in "$HOME/.config/zsh/common"/*.zsh; do
        if [[ -f "$config_file" ]]; then
            source "$config_file"
        fi
    done
fi

# Source OS-specific configuration files (if they exist)
# These files are located via the symlink created by setup.sh:
# ~/dotfiles/zsh/{macos,linux}/  ->  ~/.config/zsh/{macos,linux}/
if [[ -n "$OS_TYPE" && -d "$HOME/.config/zsh/$OS_TYPE" ]]; then
    for config_file in "$HOME/.config/zsh/$OS_TYPE"/*.zsh; do
        if [[ -f "$config_file" ]]; then
            source "$config_file"
        fi
    done
fi

# Load plugins (if any - this is a placeholder)
# If you decide to use a Zsh plugin manager, its setup might go here or in a dedicated plugins.zsh
# Example: source "$HOME/.config/zsh/plugins.zsh"
