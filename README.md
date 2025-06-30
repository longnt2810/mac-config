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
- **Git**: Version control with interactive user configuration
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
# Download and run the script directly from GitHub
sh -c "$(curl -fsSL https://raw.githubusercontent.com/longnt2810/mac-config/main/setup.sh)"
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/longnt2810/mac-config.git
cd mac-config

# Make executable and run
chmod +x setup.sh
./setup.sh
```

### Before Running
1. **Backup Important Data**: The script modifies system settings
2. **Install Xcode Manually**: If you want Xcode in the Dock, install it from the Mac App Store first
3. **Review the Script**: The script will prompt for your Git information during execution

## Customization

### Personal Information
The script will interactively prompt for your Git configuration:
- Full name for Git commits
- Email address for Git and SSH key generation

No manual editing required - the script handles this automatically during execution.

### Applications
Modify the Homebrew installation section in the script to add/remove applications:
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
Add or remove development tools in the script:
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

## Project Structure

```
mac-config/
├── setup.sh          # Main setup script
├── README.md         # This file
└── LICENSE           # MIT License
```

## Security Features

- **FileVault**: Full disk encryption enabled
- **Firewall**: Application firewall enabled
- **SSH Keys**: Ed25519 keys with proper GitHub configuration
- **Secure Defaults**: System security settings optimized

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   # Ensure you have admin privileges
   sudo -v
   ```

2. **Homebrew Installation Fails**
   ```bash
   # Manual Homebrew installation
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Java Not Found**
   ```bash
   # Check available Java versions
   /usr/libexec/java_home -V
   
   # Set JAVA_HOME manually
   export JAVA_HOME=$(/usr/libexec/java_home -v 21)
   ```

4. **Oh My Zsh Issues**
   ```bash
   # Reinstall Oh My Zsh
   rm -rf ~/.oh-my-zsh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

### Logs and Debugging
The script uses `set -e` to exit on errors. Check the terminal output for specific error messages.

---

**Disclaimer**: This script modifies system settings and installs software. Always review the script before running and ensure you have backups of important data.
