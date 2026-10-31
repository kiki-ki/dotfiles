# dotfiles

kiki-ki's dotfiles for macOS and Ubuntu, managed with [chezmoi](https://www.chezmoi.io/).

## Bootstrap

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init --apply kiki-ki
```

## Updating

Apply only the files you changed, e.g. `chezmoi apply ~/.zshrc`. A bare `chezmoi apply` after any change under `dot_config/` reruns the setup script (brew and mise), which can take a long time.

Add CLI tools used on both OSes to [mise](dot_config/mise/config.toml), and macOS-only ones to the [Brewfile](dot_config/Brewfile).

## Machine-local settings

Read if present and not tracked here:

- `~/.zshrc.local`: sourced at the end of `.zshrc`
- `~/.gitconfig_shared`: included from `.gitconfig`

## Claude Code settings

[claude-settings.json](.chezmoitemplates/claude-settings.json) holds only what every machine shares. On apply, it is merged into `~/.claude/settings.json`: its values win, its lists replace the existing ones, and keys only in `~/.claude/settings.json` stay. So a plugin installed with `/plugin` on one machine stays on that machine. A key deleted from claude-settings.json also stays until you remove it from `~/.claude/settings.json`.

To add a plugin to every machine, list it in `enabledPlugins` of claude-settings.json, apply, and run `/plugin install` once on each machine.

A plugin from a marketplace in `extraKnownMarketplaces`, such as [kikit](https://github.com/kiki-ki/kikit), also needs `claude plugin marketplace add <owner>/<repo>` once per machine before the install, because the `claude plugin` CLI does not see the declared marketplace until then. That command drops `autoUpdate` from `~/.claude/settings.json`, and the next `chezmoi apply ~/.claude/settings.json` restores it.
