# skills

Claude Code のユーザースキル。chezmoi で `~/.claude/skills/` に反映される。

スキルは「原則 → メタスキル → 作業スキル」の層で管理し、層は名前の prefix で表す。1 スキル 1 責務。必要になったものだけを足す。

pstack 由来のスキルは [NOTICE](NOTICE) と [LICENSE-pstack](LICENSE-pstack) を参照。pstack 由来のスキルはいずれも `disable-model-invocation: true` で、原則は `~/.claude/CLAUDE.md` の索引から読み、メタスキルと作業スキルは `/<name>` で呼ぶ。

## principle-*: 原則

| スキル | 説明 |
|---|---|
| principle-laziness-protocol | 先に消し、問題を解く最小の変更に寄せる |
| principle-prove-it-works | 完了と言う前に、代理指標ではなく本物で確かめ、結果を示す |
| principle-fix-root-causes | 症状ではなく根本原因で直す |
| principle-sequence-verifiable-units | 作業とコミットを、検証できる小さな単位の列にする |
| principle-encode-lessons-in-structure | 繰り返す指示を lint・hook・スクリプトなどの仕組みにする |
| principle-foundational-thinking | ロジックの前にデータ構造と足場を決め、ドメインを構造に埋め込む |
| principle-minimize-reader-load | 読み手が辿るレイヤーと保持する状態を減らす |
| principle-build-the-lever | 手作業の代わりに、作業をする・証明する道具を作る |
| principle-guard-the-context-window | 大量の出力はサブエージェントに回し、要約だけを持つ |

## meta-*: メタスキル（スキルを作る・直す）

| スキル | 説明 |
|---|---|
| meta-reflect | セッションから学びを抽出し、仕組み・スキル・CLAUDE.md への修正に振り分ける |
| meta-create-verification | プロジェクト専用の検証スキル `.claude/skills/verify-<app>/` を生成する |
| meta-maintain-verification | 検証スキルの地図を点検し、古くなった地図だけを直す |

## work-*: 作業スキル

| スキル | 説明 |
|---|---|
| work-no-comments | コードをなぞるだけのコメントを、書いた本人とは別の目で判定して取り除く |
| work-create-github-issue | 着手する人に文脈を引き渡す GitHub issue を起票する |

