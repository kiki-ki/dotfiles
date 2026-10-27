# dotfiles

kiki-ki's dotfiles for macOS and Ubuntu, managed with [chezmoi](https://www.chezmoi.io/).

## Bootstrap

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init --apply kiki-ki
```

## Updating

Apply only the files you changed, e.g. `chezmoi apply ~/.zshrc`. A bare `chezmoi apply` after any change under `dot_config/` reruns the setup script (brew and mise), which can take a long time.

Add CLI tools used on both OSes to [mise](dot_config/mise/config.toml), and macOS-only ones to the [Brewfile](dot_config/Brewfile).

Claude Code plugins are listed in [.chezmoidata/claude.yaml](.chezmoidata/claude.yaml) and written to `~/.claude/settings.json` on apply, which overwrites plugins added with `/plugin`. `common` plugins are always enabled; `work` or `personal` ones only when `DOTFILES_MACHINE` is set to that value, e.g. exported in `~/.zshrc.local`. Listing a plugin enables it but does not install it, so run `/plugin install` once on each machine.

## Machine-local settings

Read if present and not tracked here:

- `~/.zshrc.local`: sourced at the end of `.zshrc`
- `~/.gitconfig_shared`: included from `.gitconfig`
