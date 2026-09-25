# CLAUDE.md

- This repo is managed by **chezmoi**. After editing source files, run `chezmoi apply <target>` for the files you changed. A bare `chezmoi apply` also reruns `.chezmoiscripts/run_once_after_setup_00.sh.tmpl` whenever anything under `dot_config/` changed, which runs brew and mise and can take a long time.
- `~/.zshrc.local` is sourced at the end of `.zshrc` for machine-local overrides and is intentionally not tracked here.
- Runtime versions are managed by **mise** (formerly asdf).
- Claude Code skills live in `dot_claude/skills/`. When adding, removing, or renaming a skill, update `dot_claude/skills/README.md`, which lists every skill by layer (`principle-`, `meta-`, `work-`) and where it came from.
