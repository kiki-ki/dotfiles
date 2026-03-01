# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Bootstrap

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init --apply kiki-ki
```

## Structure

| Path | Description |
|---|---|
| `dot_zshrc` | zsh config (sheldon, starship, fzf, mise, aliases) |
| `dot_gitconfig` | git config |
| `dot_config/Brewfile` | Homebrew bundle (macOS) |
| `dot_config/sheldon/plugins.toml` | zsh plugins |
| `dot_config/starship.toml` | prompt config |
| `dot_config/vscode/` | VSCode settings, keybindings, extensions list |
| `dot_config/ghostty/` | Ghostty terminal config |
| `scripts/` | Platform setup scripts (auto-run once via `.chezmoiscripts`) |

## Local overrides

`~/.zshrc.local` is sourced at the end of `.zshrc` and is not tracked in this repository.
