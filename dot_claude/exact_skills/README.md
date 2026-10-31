# skills

Claude Code のユーザースキル。chezmoi で `~/.claude/skills/` に反映される。

ここに置くのは、このマシンに入れたツールに依存するスキルだけにする。どの環境でも使う原則と作業の手順は、plugin の [kikit](https://github.com/kiki-ki/kikit) に置き、`kikit:` を付けて呼ぶ。

| スキル | 説明 |
|---|---|
| work-hunk-review | 起動中の hunk のセッションを操作し、差分の行にレビューのコメントや強調を付ける |
| work-herdr | herdr のペイン・タブ・ワークスペースを操作し、別のエージェントやコマンドを動かす |

## 出典

- work-hunk-review は、[hunk](https://github.com/modem-dev/hunk) がインストールと一緒に入れる `hunk-review` スキルへのシンボリックリンク（`hunk skill path` から張る）。hunk の CLI から生成されるので、写さずにリンクして hunk の更新に追従させる。hunk を更新したら `chezmoi apply ~/.claude/skills` でリンクを張り直す。
- work-herdr は、[herdr](https://github.com/herdrdev/herdr)（Apache-2.0、`v0.9.1`）の `skills/herdr/SKILL.md` をそのまま写したもの。ライセンス全文は [LICENSE-herdr](LICENSE-herdr)。herdr を更新したら、その版の `SKILL.md` で置き換える。
