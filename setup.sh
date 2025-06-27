#!/usr/bin/env bash

# Check Bash Version
if [[ -z "${BASH_VERSINFO[0]}" || "${BASH_VERSINFO[0]}" -lt 4 ]]; then
	# Print error message
	echo -e "Error: This script requires Bash version 4.0 or newer." >&2
	echo -e "	You are currently running Bash ${BASH_VERSION%%.*}." >&2
	echo -e "	Please update Bash (using pacman, brew, apt, or dnf)." >&2
	exit 1
fi	

# Symlinks
declare -A SYMLINKS=(
	"zsh/.zshrc"		"$HOME/.zshrc"       # Main .zshrc symlink
	"zsh"			"$HOME/.config/zsh"  # Symlink the entire zsh config directory
	"nvim"			"$HOME/.config/nvim" # Neovim config
)

# Helper funcs
print_success() {
	# prints in green
	echo -e "\033[0;32m✓ $1\033[0m"
}

print_warning() {
	# prints in yellow
	echo -e "\033[0;33m! $1\033[0m"
}

print_error() {
	# prints in red
	echo -e "\033[0;31m✗ $1\033[0m" >&2
	exit 1
}

# Start Spawning symlinks...
echo "Starting dotfiles setup..."

# Check if Git is installed
echo "Ensuring git is installed..."
if ! command -v git &> /dev/null; then
	print_error "Git is not installed. Please install git before running this script"
fi

# Check if zsh is installed
echo "Ensuring zsh is installed..."
if ! command -v zsh &> /dev/null; then
	print_error "Zsh is not installed. Please install zsh before running this script"
fi

# Create symlinks
echo "Creating symlinks"
for source_path in "${!SYMLINKS[@]}"; do
	destination_symlink="${SYMLINKS[$source_path]}"
    absolute_source_path="$(pwd)/$source_path" # Get absolute path of source

	# parent dir for the destination symlink
	mkdir -p "$(dirname "$destination_symlink")"

	if [ -e "$destination_symlink" ] || [ -L "$destination_symlink" ]; then
		# Check if it's a symlink and if it points to the correct location
		if [ -L "$destination_symlink" ] && [ "$(readlink "$destination_symlink")" = "$absolute_source_path" ]; then
			print_success "Symlink for '$source_path' already exists and is correct."
		else
			# Backup existing file or symlink
			print_warning "Existing file or symlink found at '$destination_symlink'. Backing up to '${destination_symlink}.bak'..."
			if mv "$destination_symlink" "${destination_symlink}.bak"; then
				print_success "Backed up '$destination_symlink'."
				ln -s "$absolute_source_path" "$destination_symlink" && print_success "Symlinked '$source_path' to '$destination_symlink'." || print_error "Failed to create symlink for '$source_path'."
			else
				print_warning "Failed to backup existing file. Skipping symlink for '$source_path'."
			fi
		fi
	else
		# Create new symlink
		ln -s "$absolute_source_path" "$destination_symlink" && print_success "Symlinked '$source_path' to '$destination_symlink'." || print_error "Failed to create symlink for '$source_path'."
	fi
done

# Apply .zshrc
echo "Sourcing ~/.zshrc to apply changes for current session..."
source "$HOME/.zshrc"

print_success "Dotfiles setup complete!"
echo "Remember to restart your terminal to apply all changes."
