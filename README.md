# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

### Automatic Setup (Recommended) 🚀

**One-liner - Complete automatic setup:**

```bash
# Using curl (macOS / modern Linux)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nakatakai/dotfiles/main/init.sh)"

# Using wget (Ubuntu / minimal Linux)
bash -c "$(wget -qO- https://raw.githubusercontent.com/nakatakai/dotfiles/main/init.sh)"
```

This will automatically:

1. Install chezmoi
2. Clone and apply dotfiles
3. Run platform-specific setup scripts
4. Install all packages and tools

### Interactive Setup (Alternative)

If you prefer to confirm each step:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nakatakai/dotfiles/main/setup.sh)"
```

### Manual Setup

Using chezmoi directly:

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Apply dotfiles
chezmoi init --apply nakatakai

# Run platform-specific install script
~/.local/share/chezmoi/install/macos.sh     # macOS
~/.local/share/chezmoi/install/ubuntu.sh    # Ubuntu/Linux
```

## Files Structure

- `init.sh` - Quick automatic setup (no prompts)
- `setup.sh` - Interactive setup with confirmations
- `install/macos.sh` - macOS package installation
- `install/ubuntu.sh` - Ubuntu/Linux package installation
- `scripts/init_vscode.sh` - VSCode configuration

## Daily Usage

```bash
# Add a new dotfile
chezmoi add ~/.newconfig

# Edit a dotfile
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Update from Git repository
chezmoi update
```

## Requirements

- **macOS**: curl (pre-installed)
- **Linux**: curl or wget
