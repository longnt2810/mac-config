# macOS Development Environment Setup Script

A comprehensive automation script to set up a new MacBook for development work. This script installs and configures essential development tools, applications, and system preferences for a productive development environment.

## Features

### System Setup
- **macOS Updates**: Automatically installs the latest system updates
- **Security**: Enables FileVault disk encryption and firewall
- **System Preferences**: Configures trackpad, Finder, and battery display settings

### Development Tools
- **Xcode Command Line Tools**: Essential for macOS development
- **Homebrew**: Package manager for macOS
- **Git**: Version control with pre-configured user settings
- **SSH Keys**: Automatic generation and GitHub configuration

### Programming Languages & Tools
- **Java 21**: Latest LTS version with OpenJDK
- **Node.js**: Via NVM for version management
- **Python**: Via Miniconda for environment management
- **Docker**: Containerization platform

### Applications
- **Browsers**: Google Chrome and Microsoft Edge
- **Code Editor**: Visual Studio Code
- **Terminal**: iTerm2 with enhanced features
- **Media Player**: VLC

### Terminal Enhancement
- **Oh My Zsh**: Enhanced shell experience
- **Powerlevel10k**: Beautiful and functional terminal theme
- **Plugins**: 
  - zsh-completions
  - zsh-autosuggestions
  - zsh-syntax-highlighting

### Dock Configuration
- Customizes Dock with essential development applications
- Disables recent applications
- Adds Xcode, Chrome, and Edge (if available)

## Prerequisites

- macOS (tested on macOS Sonoma and later)
- Administrator privileges
- Internet connection
- Apple ID (for some installations)

## Installation

### Quick Start
```bash
# Download and run the script
sh -c "$(curl -fsSL <your-script-url>)"
```

### Manual Installation
```bash
# Clone or download the script
git clone <repository-url>
cd mac-config

# Make executable and run
chmod +x setup.sh
./setup.sh
```

### Before Running
1. **Backup Important Data**: The script modifies system settings
2. **Install Xcode Manually**: If you want Xcode in the Dock, install it from the Mac App Store first
3. **Review the Script**: Customize personal information (name, email, etc.)

## Customization

### Personal Information
Edit these lines in the script:
```bash
# Git configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"

# SSH key generation
ssh-keygen -t ed25519 -C "your.email@company.com"
```

### Applications
Modify the Homebrew installation section to add/remove applications:
```bash
brew install --cask \
  google-chrome \
  microsoft-edge \
  visual-studio-code \
  iterm2 \
  vlc \
  docker
  # Add your preferred applications here
```

### Development Tools
Add or remove development tools:
```bash
brew install \
  git \
  nvm \
  miniconda \
  openjdk@21
  # Add other tools as needed
```

## Post-Installation Steps

After running the script, complete these manual steps:

1. **GitHub SSH Key**: Copy the displayed SSH public key to GitHub
   - Go to GitHub Settings > SSH and GPG Keys > New SSH Key
   - Paste the key and save

2. **Powerlevel10k Configuration**: Run the theme configuration
   ```bash
   p10k configure
   ```

3. **Node.js Setup**: Install your preferred Node.js version
   ```bash
   nvm install 18  # or your preferred version
   nvm use 18
   nvm alias default 18
   ```

4. **Python Environment**: Create your Python environment
   ```bash
   conda create -n myenv python=3.11
   conda activate myenv
   ```

5. **Verify Installations**:
   ```bash
   java -version
   node --version
   python --version
   git --version
   ```
