# NVIM aliases
alias vi=nvim
alias vim=nvim

# VCPKG
VCPKG_ROOT="$HOME/vcpkg"
PATH=$VCPKG_ROOT:$PATH

# Enable prompt substitution so command substitutions and function calls work in PS1
setopt PROMPT_SUBST

# Define colors for easier use
# %{%F{color}%} sets foreground color
# %{%B{color}%} sets background color
# %{%f%} resets foreground
# %{%b%} resets background
# %{%k%} resets all colors
# %{%B%} sets bold
# %{%b%} resets bold
# %{%U%} sets underline
# %{%u%} resets underline

# Color definitions
ZSH_PROMPT_COLOR_NORMAL="%{%f%}"
ZSH_PROMPT_COLOR_GREEN="%{%F{green}%}"
ZSH_PROMPT_COLOR_YELLOW="%{%F{yellow}%}"
ZSH_PROMPT_COLOR_RED="%{%F{red}%}"
ZSH_PROMPT_COLOR_BLUE="%{%F{blue}%}"
ZSH_PROMPT_COLOR_CYAN="%{%F{cyan}%}"
ZSH_PROMPT_COLOR_MAGENTA="%{%F{magenta}%}"
ZSH_PROMPT_COLOR_WHITE="%{%F{white}%}"
ZSH_PROMPT_COLOR_GREY="%{%F{242}%}" # A nice dark grey

# Define the Git prompt function
# This function checks if you are in a Git repository and displays the branch
# and an indicator if there are uncommitted changes.
_git_prompt_info() {
    # Check if we are in a Git repository
    # git rev-parse --is-inside-work-tree outputs "true" or "false"
    # and redirects stderr to /dev/null to suppress warnings if not in a repo
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Get the current branch name (or commit hash for detached HEAD)
        local branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ "$branch_name" == "HEAD" ]]; then
            branch_name=$(git describe --always --tags --dirty --abbrev=7 2>/dev/null)
        fi

        # Check for uncommitted changes
        local status_indicator=""
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            status_indicator="*" # Asterisk if there are uncommitted changes
        fi

        # Return the formatted Git info
        echo "${ZSH_PROMPT_COLOR_YELLOW}(${branch_name}${status_indicator})${ZSH_PROMPT_COLOR_NORMAL}"
    else
        echo "" # No Git info if not in a repository
    fi
}

# Define the exit status indicator function
# Displays a red X if the last command failed (exit code != 0)
_exit_status_indicator() {
    if [[ $? -ne 0 ]]; then
        echo "${ZSH_PROMPT_COLOR_RED}X${ZSH_PROMPT_COLOR_NORMAL} " # Red X for non-zero exit status
    else
        echo ""
    fi
}

# Configure the primary prompt (PS1)
# Elements:
#   _exit_status_indicator: Shows an 'X' if the last command failed
#   %{%F{cyan}%}%n@%m: Cyan username@hostname
#   %{%f%}: Reset color
#   :%{%F{blue}%}%~: Blue current directory (shortened with ~)
#   %{%f%}: Reset color
#   %(!.#.$): If root show #, else show $
#   $(_git_prompt_info): Call the git info function
#   %b : Resets bold (added for safety, but %{%f%b%} includes it)
#   %k : Resets all formatting (colors, bold, etc.)

PROMPT='
%{$(_exit_status_indicator)%}%{%F{cyan}%}%n@%m%{%f%}:%{%F{blue}%}%~%{%f%}$(_git_prompt_info)%{%k%}
%{$ZSH_PROMPT_COLOR_GREY%}λ %{$ZSH_PROMPT_COLOR_NORMAL%} '

# Time (RPROMPT)
RPROMPT='%{%F{green}%}%@%{%f%}' # Displays current time in green on the right (12-hour format with AM/PM)

