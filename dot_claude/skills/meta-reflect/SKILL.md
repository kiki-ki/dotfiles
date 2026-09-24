---
name: meta-reflect
description: "今のセッションのトランスクリプトを 3 体のレビュアーで並行に読み、残す価値のある学びを抽出して、既存スキルへの具体的な修正（または仕組みでの担保）に振り分ける。ユーザーが「reflect」「振り返って」と言ったときに使う。"
disable-model-invocation: true
---

# meta-reflect

今の会話から長持ちする学びを掘り出し、スキルの修正に振り分ける。

## いつ使うか

ユーザーが「reflect」「/meta-reflect」「振り返って」と言ったとき。会話が些細・本題と無関係・既存スキルに正しく従っただけで済んでいる場合は飛ばす。一度きりのことは学びではない。

## 手順

### 1. 今のトランスクリプトを特定する

ファンアウトの前に、親が自分のトランスクリプトを見つける。場所は `~/.claude/projects/<作業ディレクトリの / を - に置き換えたもの>/`。本体は `<session-id>.jsonl`、サブエージェントは `<session-id>/subagents/*.jsonl`。

```bash
ls -t ~/.claude/projects/<encoded-cwd>/*.jsonl | head -5
```

今のプロジェクトのディレクトリ以外は見ない。`~/.claude/projects/*/` をまとめて glob すると、無関係なプロジェクトの会話を読むことになる。候補ごとに冒頭数行を読み、この会話の最初のユーザー発言が含まれているものを採る。見つからなければ、セッションの要約を簡潔に書いて代わりに渡す。

### 2. レビュアー 3 体を並行に起動する

1 つのメッセージで Agent ツールを 3 回呼ぶ（general-purpose、`model: sonnet`）。レビュアーはトランスクリプトを読んで抽出する役なので軽めのモデルでよい。

| 観点 | プロンプト |
|---|---|
| 判断 | [references/judgment-reviewer.md](references/judgment-reviewer.md) |
| ツール | [references/tooling-reviewer.md](references/tooling-reviewer.md) |
| 逆張り | [references/divergent-reviewer.md](references/divergent-reviewer.md) |

各テンプレートはそのまま渡し、指定箇所にトランスクリプトのパスか要約を差し込む。

### 3. 統合する

Agent ツールを 1 回呼ぶ（general-purpose、`model: opus`）。取捨選択と振り分けは判断の仕事なので上位モデルに任せる。[references/synthesizer.md](references/synthesizer.md) をそのまま使い、各レビュアーの出力全文を指定箇所に埋め込む。統合役は Accepted / Rejected / Backlog の一覧を返す。

### 4. 仕組みで担保できないか確かめる

文章のスキル修正にする前に、[principle-encode-lessons-in-structure](../principle-encode-lessons-in-structure/SKILL.md) を読み、Accepted の各項目について、次のどれかで担保できないかを一度検討する。

- lint ルールや型
- Claude Code の hook（settings.json の hooks）
- スクリプト
- 権限設定（settings.json の permissions の allow / deny）

担保できるものは Accepted から Backlog に移し、どの仕組みで担保するかを書く。

### 5. 適用する

Accepted を適用する前に、統合役の Accepted / Rejected / Backlog の全文をユーザーに見せ、明示的な承認を待つ。ユーザーは適用する項目を選び、振り分け先を変えることもある。スキルの変更は以後のすべてのセッションに効くので、勝手に適用しない。

承認された項目は、Routing の指示どおりに処理する:

- 既存スキルへの小さな修正（1 行の追加、文の引き締め、古い事実の訂正）: 親が直接編集する
- 既存スキルへの大きな修正（新しい節、表の追加、およそ 10 行超）や `tune description:`: skill-creator スキルが使えればそれで下書き・試行・改善のループを回す。なければ親が編集し、変更後の SKILL.md を読み直す
- `new skill: <kebab-name>`: 同上。形をその場の思いつきで作らない。名前は [README.md](../README.md) の prefix の規約に従う

編集先のスキルが chezmoi 管理（`chezmoi source-path <path>` が通る）なら、`~/.claude/skills` ではなく source 側を編集し、`chezmoi apply` で反映する。

Backlog はユーザーに報告する。仕組みの実装まで進めるかはユーザーが決める。

### 6. ユーザーへの要約

前置きなしの短い一覧:

- 適用した修正: `<skill path>` と変更点を 1 行ずつ
- 新しく作ったスキル: `<skill path>` を 1 行ずつ（まれ）
- Backlog: パターンと、担保に使う仕組みを 1 行ずつ
- 捨てたもの: 却下した学びと、統合役が挙げた理由を 1 行ずつ
