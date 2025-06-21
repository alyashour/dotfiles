#!/bin/bash

# Symlinks
declare -A SYMLINKS=(
	".zshrc"	"$HOME/.zshrc"
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
if ! command -v git $> /dev/null; then
	print_error "Git is not installed. Please install git before running this script"
fi

# Create symlinks
echo "Creating symlinks"
for source_file in "${!SYMLINKS[@]}"; do
	destination_symlink="${SYMLINKS[$source_file]}"

	# parent dir
	mkdir -p "$(dirname "$destination_symlink")"

	if [ -e "$destination_symlink" ] || [ -L "$destination_symlink" ]; then 
		if [ -L "$destination_symlink" ] && [ "$readlink "$destination_symlink")" = "$(pwd)/$source_file" ]; then
			print_success "Symlink for '$source_file' already exists and is correct."
		else
			# Backup existing symlink
			print_warning "Existing file or symlink found at '$destination_symlink'. Backing up..."
			mv "$destination_symlink" "${destination_symlink}.bak" || print_warning "Failed to backup existing file. Skipping symlink for '$source_file'."
			ln -s "./$source_file" "$destination_symlink" && print_success "Symlinked '$source_file' to '$destination_symlink'." || print_error "Failed to create symlink for '$source_file'."
		fi
	else
		ln -s "./$source_file" "$destination_symlink" && print_success "Symlinked '$source_file' to '$destination_symlink'." || print_error "Failed to create symlink for '$source_file'."
	fi
done

# Apply .zshrc
echo "Sourcing ~/.zshrc to apply changes for current session..."
source "$HOME/.zshrc"

print_success "Dotfiles setup complete!"
echo "Remember to restart your terminal to apply all changes."
