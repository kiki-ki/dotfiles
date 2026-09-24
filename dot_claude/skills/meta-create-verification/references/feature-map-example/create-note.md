# ノートを作る

ユーザーはブラウザか CLI からタイトル付きのノートを保存し、書きかけの下書きを取り消し、保存したノートを別の画面から確かめられる。

## Sub-features

- `create-open` はブラウザの各入口から空のエディタを開く。
- `create-save` はタイトルと本文を永続化する。
- `create-cancel` はブラウザで書きかけの下書きを破棄する。
- `create-cli` は端末から同じ形のノートを作る。

## How to get to it (user POV)

- ブラウザのツールバーで `New note` ボタンを選ぶ。
- 編集可能なフィールドの外にフォーカスがある状態で、ブラウザで `n` を押す。
- 端末で `notes create --title <title> --body <body>` を実行する。

## Driving it with control-notes

Preconditions:

- Notes が `http://127.0.0.1:4173` で正常に動いている。
- `Release checklist` というタイトルのノートがない。
- `control-notes doctor` が、期待する URL と使い捨てのデータディレクトリを報告する。

- **エディタを開く。** `New note` を選ぶ。`control-notes browser click --role button --name "New note"` を実行する。`Note editor` という名前のフォームが現れ、`Title` のテキストボックスにフォーカスがある。
- **内容を入れる。** タイトルと本文を入力する。`control-notes browser fill --role textbox --name "Title" --value "Release checklist"` と `control-notes browser fill --role textbox --name "Body" --value "Tag and publish"` を実行する。`Save note` ボタンが有効になる。
- **保存する。** `Save note` を選ぶ。`control-notes browser click --role button --name "Save note"` を実行する。`Note saved` という status が現れ、見出しが `Release checklist` になる。
- **永続化を確かめる。** ノート一覧に戻ってノートを開き直す。`control-notes browser click --role link --name "All notes"` と `control-notes browser click --role link --name "Release checklist"` を実行する。エディタに保存した 2 つの値が出る。
- **下書きを取り消す。** 新しいノートを開き、`Discard me` と入力して `Cancel` を選ぶ。`control-notes browser click --role button --name "New note"`、`control-notes browser fill --role textbox --name "Title" --value "Discard me"`、`control-notes browser click --role button --name "Cancel"` を実行する。ノート一覧に戻り、`Discard me` のリンクがない。
- **CLI の入口。** 2 つ目のノートを作る。`control-notes cli -- notes create --title "CLI note" --body "Created from terminal" --format json` を実行する。終了コードが `0` で、stdout に新しいノートの ID とタイトルが含まれる。
- **証明。** `All notes` から保存した 2 つのノートを開き直す。`control-notes browser snapshot --aria --path artifacts/create-note/list.aria.txt` と `control-notes browser screenshot --path artifacts/create-note/list.png` を実行する。成果物に `Release checklist` と `CLI note` が写っている。

## Gotchas

- テキストボックスにフォーカスがあるときに `n` を押すと、新しいエディタが開かずに文字が入力される。
- タイトルは保存時に trim される。下書きの入力値ではなく、描画されたタイトルを確かめる。
- 保存の status だけでは証明にならない。一覧からノートを開き直す。
- 後片付けで `Release checklist` と `CLI note` を消す。ただし証拠は残す。
