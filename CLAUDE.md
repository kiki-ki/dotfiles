# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

See README.md for repository overview and structure.

## Non-obvious conventions

- `~/.zshrc.local` is sourced at the end of `.zshrc` for machine-local overrides and is intentionally not tracked here.
- Runtime versions are managed by **mise** (formerly asdf).
- Commits follow Conventional Commits: `type(scope): summary`.
- This repo is managed by **chezmoi**. After editing source files, always run `chezmoi apply` to reflect changes to the actual dotfiles.
- Claude Code skills live in `dot_claude/skills/`. Their layer prefixes (`principle-`, `meta-`, `work-`) are described in `dot_claude/skills/README.md`, and skills derived from pstack are listed in `dot_claude/skills/NOTICE`.
