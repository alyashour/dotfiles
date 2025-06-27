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
        # Using the color variables defined in prompt.zsh
        echo "${ZSH_PROMPT_COLOR_YELLOW}(${branch_name}${status_indicator})${ZSH_PROMPT_COLOR_NORMAL}"
    else
        echo "" # No Git info if not in a repository
    fi
}

# Define the exit status indicator function
# Displays a red X if the last command failed (exit code != 0)
_exit_status_indicator() {
    if [[ $? -ne 0 ]]; then
        # Using the color variables defined in prompt.zsh
        echo "${ZSH_PROMPT_COLOR_RED}X${ZSH_PROMPT_COLOR_NORMAL} " # Red X for non-zero exit status
    else
        echo ""
    fi
}
