# CLAUDE.md

以下に記載のルールを遵守すること。

## Coding

- 作業時に作成するブランチ名は `kiki-ki/` prefix とすること (例: `kiki-ki/add-hoge-page`)
- コードをなぞるだけのコメントを書かない。コメントは「なぜ」を説明するためだけに書き、記載は必要十分な量にする

## Commit

- Conventional Commits に従う: `type(scope): summary (簡潔に)`
- secret や credential を絶対にコミットしない

## Pull Request / Issue

- PR は必ず draft で作成する (`gh pr create --draft`)
- `gh` で issue や PR を作るとき、ユーザーや team へのメンションをしない (`@username`、`@org/team` を含めない)
  - 本文中にハンドル名を書く必要がある場合はバッククォートで囲むか言い換える
- PR 本文のルール
  - 以下のセクションのみを記載すること
    - 背景: なぜこの変更が必要か (issue リンク, 箇条書き)
    - 修正内容: 何を変えたか (箇条書き)
    - テスト: 動作確認の方法または実行したテスト (箇条書き)
  - その他のルール
    - タイトルは Conventional Commits の形式に従うこと `type(scope): summary (簡潔に)`
    - 各セクションは簡潔に必要十分な記載とすること。diff の内容を本文で再掲しない
    - 絵文字や太文字等、不要な装飾は避けること。その後編集しやすい形式で記載する
