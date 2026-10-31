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

[claude-settings.json](.chezmoitemplates/claude-settings.json) holds only the settings every machine shares. `chezmoi apply` merges it into `~/.claude/settings.json`:

- Its values win, and its lists, such as `permissions.allow`, replace the existing ones.
- Keys only in `~/.claude/settings.json` stay, such as a plugin installed with `/plugin` on one machine.
- A key deleted from claude-settings.json stays in `~/.claude/settings.json` until you remove it there.

To add a plugin to every machine, list it in `enabledPlugins` of claude-settings.json, then on each machine:

1. If the plugin comes from a marketplace in `extraKnownMarketplaces`, such as [kikit](https://github.com/kiki-ki/kikit), run `claude plugin marketplace add <owner>/<repo>`. The `claude plugin` CLI does not see the marketplace until then.
2. Run `chezmoi apply ~/.claude/settings.json`.
3. Run `/plugin install <plugin>@<marketplace>`.
