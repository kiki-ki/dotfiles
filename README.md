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

- Each key in it replaces the same key in `~/.claude/settings.json`, including everything nested under it.
- `enabledPlugins` and `extraKnownMarketplaces` are the exceptions: they are merged, so plugins and marketplaces added with `/plugin` on one machine stay.
- Top-level keys that are not in claude-settings.json stay. A key deleted from claude-settings.json therefore stays in `~/.claude/settings.json` until you remove it there.

To add a plugin to every machine, list it in `enabledPlugins` of claude-settings.json, then on each machine:

1. If the plugin comes from a marketplace in `extraKnownMarketplaces`, such as [kikit](https://github.com/kiki-ki/kikit), run `claude plugin marketplace add <owner>/<repo>`. The `claude plugin` CLI does not see the marketplace until then.
2. Run `chezmoi apply ~/.claude/settings.json`.
3. Run `/plugin install <plugin>@<marketplace>`.

The `textlint` that kikit's technical-writing skill runs is installed from [package.json](dot_local/share/textlint/package.json) into `~/.local/share/textlint` with pnpm and linked to `~/.local/bin/textlint`. Keep its versions in line with [kikit's package.json](https://github.com/kiki-ki/kikit/blob/main/package.json).
