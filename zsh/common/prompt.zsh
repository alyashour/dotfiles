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

PROMPT='%{$(_exit_status_indicator)%}%{%F{cyan}%}%n@%m%{%f%}:%{%F{blue}%}%~%{%f%} $(_git_prompt_info)%{%k%}%{$ZSH_PROMPT_COLOR_GREY%}λ %{$ZSH_PROMPT_COLOR_NORMAL%} '

# Time (RPROMPT)
RPROMPT='%{%F{green}%}%@%{%f%}' # Displays current time in green on the right (12-hour format with AM/PM)
