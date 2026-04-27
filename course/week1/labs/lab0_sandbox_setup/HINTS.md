# Lab 0 ヒント

## SSH key

- GitHub clone でpassword promptが出る場合: SSH keyを設定 (`ssh-keygen -t ed25519`, `gh ssh-key add`)。
- HTTPS で進めても可だが、毎push でtoken入力。

## PR description が空だと落ちる

- `gh pr create` で `--body` を指定するか、UIで最低1行入れる。

## Codex GitHub connector が承認待ち

- workspace owner (admin) 側で承認が必要。Lab 0 は connector が無くても完遂可 (前提条件のみ確認、生成は不要)。

## branch 名に `/` を含めて良いか

- 良い。GitHub も Git も `/` を階層区切りとして扱う。`learner/<name>/wk1-sandbox-init` のような3階層は推奨。

## 自分のSandbox repoの命名

- `Sandbox_<name>` の `<name>` は英小文字のみ推奨 (CONVENTIONS.md §2.1 のロケール規約)。例: `Sandbox_alice`、`Sandbox_pasorobo`。
