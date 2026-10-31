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
- `~/.config/chezmoi/chezmoi.toml`: template data for this machine

```toml
# ~/.config/chezmoi/chezmoi.toml
[data.claude.enabledPlugins]
    # Merged into enabledPlugins of ~/.claude/settings.json; false disables a shared plugin here
    "datadog@claude-plugins-official" = true
    "pyright-lsp@claude-plugins-official" = false
```

To add a Claude Code plugin, list it in `enabledPlugins` of [claude-settings.json](.chezmoitemplates/claude-settings.json) or in the chezmoi config above, apply, and run `/plugin install` once on each machine. A plugin installed with `/plugin` alone also stays, but is not tracked here.

On apply, each key in claude-settings.json replaces the one in `~/.claude/settings.json`, except `enabledPlugins` and `extraKnownMarketplaces`, which are merged with what `/plugin` wrote. To turn off a shared plugin, set it to `false` rather than deleting it. A key deleted from claude-settings.json stays in `~/.claude/settings.json` until you remove it there.

A plugin from a marketplace in `extraKnownMarketplaces`, such as [kikit](https://github.com/kiki-ki/kikit), also needs `claude plugin marketplace add <owner>/<repo>` once per machine before the install, because the `claude plugin` CLI does not see the declared marketplace until then. That command drops `autoUpdate` from `~/.claude/settings.json`, and the next `chezmoi apply ~/.claude/settings.json` restores it.
