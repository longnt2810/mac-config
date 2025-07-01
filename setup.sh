#!/bin/bash

# Script to set up a new MacBook (2025) for Long Nguyen
# Run with: sh -c "$(curl -fsSL <your-script-url>)"
# Ensure you review and customize this script before running
# Note: Install Xcode manually before running if you want it in the Dock

# Exit on error
set -e

echo "Starting MacBook setup..."

# Check for admin privileges
if ! sudo -v; then
  echo "This script requires admin privileges. Please run with sudo or ensure you have admin access."
  exit 1
fi

# 1. Update macOS to the latest version
echo "Checking for macOS updates..."
echo "Note: This will install updates but not restart automatically."
softwareupdate --install --all
echo "Updates installed. Please restart manually when convenient."

# 2. Install Xcode Command Line Tools
echo "Installing Xcode Command Line Tools..."
if ! xcode-select --print-path &>/dev/null; then
  xcode-select --install
  echo "Waiting for Xcode Command Line Tools installation to complete..."
  while ! xcode-select --print-path &>/dev/null; do
    sleep 5
  done
  sudo xcodebuild -license accept
else
  echo "Xcode Command Line Tools already installed."
fi

# 3. Install Homebrew (Package Manager)
echo "Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed."
fi

# 4. Install Essential Apps and Tools via Homebrew
echo "Installing essential apps and tools..."
brew install --cask \
  google-chrome \     # Browser
  microsoft-edge \    # Browser
  visual-studio-code \ # Code editor
  iterm2 \            # Terminal
  vlc \               # Media player
  docker              # Containerization

brew install \
  git \               # Version control
  nvm \               # Node Version Manager
  miniconda \         # Lightweight Conda for Python version management
  openjdk@21          # Java 21

# 5. Configure Java
echo "Configuring Java 21..."
java_home=$(/usr/libexec/java_home -v 21 2>/dev/null || echo "")
if [ -n "$java_home" ]; then
  echo "export JAVA_HOME=$java_home" >> ~/.zshrc
  echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.zshrc
  export JAVA_HOME=$java_home
  export PATH=$JAVA_HOME/bin:$PATH
  echo "Java 21 configured successfully."
else
  echo "Warning: Java 21 home not found. You may need to set JAVA_HOME manually."
fi

# 6. Configure macOS Preferences
echo "Configuring macOS preferences..."

# Enable FileVault for disk encryption
sudo fdesetup enable

# Enable Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Show all filename extensions in Finder by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Use column view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle Clmv

# Set trackpad sensitivity to maximum
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -int 2

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Show battery percentage in menu bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# 7. Remove pre-installed applications
echo "Removing pre-installed applications..."

# Function to safely remove applications
remove_app() {
  app_name=$1
  app_path="/Applications/$app_name.app"
  
  if [ -d "$app_path" ]; then
    echo "Removing $app_name..."
    # Check if we can use sudo to remove the app
    if sudo rm -rf "$app_path" 2>/dev/null; then
      echo "$app_name removed successfully."
    else
      echo "Could not remove $app_name. It may be protected by System Integrity Protection."
      echo "Attempting to hide $app_name instead..."
      # If we can't remove it, try to hide it
      sudo chflags hidden "$app_path" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "$app_name hidden successfully."
      else
        echo "Could not hide $app_name. It will remain visible in Applications folder."
      fi
    fi
  else
    echo "$app_name not found or already removed."
  fi
}

# Ask user which apps to remove
echo "The following pre-installed applications can be removed:"
echo "1. GarageBand (music creation studio)"
echo "2. iMovie (video editing software)"
echo "3. Keynote (presentation software)"
echo "4. Numbers (spreadsheet software)"
echo "5. Pages (word processing software)"
echo "6. Chess (game)"
echo "7. All of the above"
echo "8. None (skip)"

read -p "Enter your choice (1-8): " app_choice

case $app_choice in
  1)
    remove_app "GarageBand"
    ;;
  2)
    remove_app "iMovie"
    ;;
  3)
    remove_app "Keynote"
    ;;
  4)
    remove_app "Numbers"
    ;;
  5)
    remove_app "Pages"
    ;;
  6)
    remove_app "Chess"
    ;;
  7)
    remove_app "GarageBand"
    remove_app "iMovie"
    remove_app "Keynote"
    remove_app "Numbers"
    remove_app "Pages"
    remove_app "Chess"
    ;;
  8)
    echo "Skipping application removal."
    ;;
  *)
    echo "Invalid choice. Skipping application removal."
    ;;
esac

# 8. Configure Dock
echo "Configuring Dock..."
# Disable Recent Applications in Dock
defaults write com.apple.dock show-recents -bool false

# Clear existing Dock apps
defaults delete com.apple.dock persistent-apps 2>/dev/null || true

# Add Xcode, Microsoft Edge, and Google Chrome to Dock
defaults write com.apple.dock persistent-apps -array \
  "$(if [ -d "/Applications/Xcode.app" ]; then printf '{ "tile-type" = "app-tile"; "tile-data" = { "file-data" = { "_CFURLString" = "file:///Applications/Xcode.app/"; "_CFURLStringType" = 15; }; }; }'; fi)" \
  "$(printf '{ "tile-type" = "app-tile"; "tile-data" = { "file-data" = { "_CFURLString" = "file:///Applications/Microsoft Edge.app/"; "_CFURLStringType" = 15; }; }; }' )" \
  "$(printf '{ "tile-type" = "app-tile"; "tile-data" = { "file-data" = { "_CFURLString" = "file:///Applications/Google Chrome.app/"; "_CFURLStringType" = 15; }; }; }' )"

# Restart Dock to apply changes
killall Dock

# 9. Install Oh My Zsh for enhanced terminal experience
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed."
fi

# 10. Install Powerlevel10k for Oh My Zsh
echo "Installing Powerlevel10k theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
  echo "source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
else
  echo "Powerlevel10k already installed."
fi

# 11. Install Oh My Zsh Plugins
echo "Installing Oh My Zsh plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# zsh-completions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
  git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
else
  echo "zsh-completions already installed."
fi

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
else
  echo "zsh-autosuggestions already installed."
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
else
  echo "zsh-syntax-highlighting already installed."
fi

# Enable plugins in .zshrc
echo "Enabling Oh My Zsh plugins..."
if ! grep -q "zsh-completions" ~/.zshrc; then
  # Check if plugins line exists
  if grep -q "^plugins=(" ~/.zshrc; then
    # Add plugins to existing line
    sed -i '' 's/^plugins=(/plugins=(zsh-completions zsh-autosuggestions zsh-syntax-highlighting /' ~/.zshrc
  else
    # Add plugins line if it doesn't exist
    echo 'plugins=(zsh-completions zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
  fi
fi

# 12. Set up Git with basic configuration
echo "Configuring Git..."

# Prompt for Git user information
echo "Please enter your Git configuration:"
read -p "Enter your full name: " git_name
read -p "Enter your email address: " git_email

# Validate input
if [ -z "$git_name" ] || [ -z "$git_email" ]; then
  echo "Error: Name and email are required for Git configuration."
  exit 1
fi

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global core.editor "code --wait"

echo "Git configured with:"
echo "  Name: $git_name"
echo "  Email: $git_email"

# 13. Set up SSH for GitHub
echo "Setting up SSH for GitHub..."
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N ""
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  echo "Host github.com
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
  echo "Copy the following SSH public key to GitHub (Settings > SSH and GPG Keys > New SSH Key):"
  cat ~/.ssh/id_ed25519.pub
else
  echo "SSH key already exists."
fi

# 14. Set up NVM (Node Version Manager)
echo "Configuring NVM..."
mkdir -p ~/.nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"' >> ~/.zshrc
echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"' >> ~/.zshrc

# 15. Set up Miniconda
echo "Configuring Miniconda..."
if [ -d "$HOME/miniconda3" ]; then
  echo "Initializing Miniconda..."
  ~/miniconda3/bin/conda init zsh
else
  echo "Miniconda directory not found. Please ensure Miniconda is installed correctly."
fi

# 16. Reload zsh configuration
echo "Reloading zsh configuration..."
source ~/.zshrc

echo "MacBook setup complete! Please review installed apps and configurations."
echo "Next steps: Add your SSH key to GitHub, run 'p10k configure' to set up Powerlevel10k, and install desired Node/Python versions using 'nvm install <version>' and 'conda create -n <env> python=<version>'."
echo "Java 21 is installed. Verify with 'java -version'. Install Xcode manually from the Mac App Store to ensure it appears in the Dock."