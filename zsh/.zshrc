# Core Zsh settings (always at the top)

# Enable prompt substitution so command substitutions and function calls work in PS1
#setopt PROMPT_SUBST

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
if [[ -d "$HOME/.config/zsh/common" ]]; then
    for config_file in "$HOME/.config/zsh/common"/*.zsh; do
        if [[ -f "$config_file" ]]; then
            source "$config_file"
        fi
    done
fi

# Source OS-specific configuration files (if they exist)
if [[ -n "$OS_TYPE" && -d "$HOME/.config/zsh/$OS_TYPE" ]]; then
    for config_file in "$HOME/.config/zsh/$OS_TYPE"/*.zsh; do
        if [[ -f "$config_file" ]]; then
            source "$config_file"
        fi
    done
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  echo "DOTFILES WARN | Starship not installed"
fi

# Source local config files (not tracked by git)
if [ -d "${ZDOTDIR:-$HOME}/.zsh/local" ]; then
    for local_file in "${ZDOTDIR:-$HOME}/.zsh/local"/*.zsh; do
        [ -r "$local_file" ] && source "$local_file"
    done
fi
