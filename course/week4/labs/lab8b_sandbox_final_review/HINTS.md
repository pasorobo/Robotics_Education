# Lab 8b HINTS

## sandbox W1-W4 自己レビューの観点例

- 環境: 何が install しにくかったか (sudo の制約 / version 衝突 / network)
- template: どの field が空欄になりがちだったか / どの field が冗長だったか
- 失敗 pattern: ros2 topic がない / Gazebo 起動失敗 / Codex 出力が禁止リストに触れた
- Q1 移行: safety_checklist の reviewer 確定 / SOP approval / pilot trial の運用

## Codex 補助 prompt 例 (累積 Notes pattern 抽出限定)

```
以下は私の Sandbox PR Review Notes (W2 + W3 計 3 件) です。
共通 pattern を 3 行で抽出してください。
- pattern 1: ...
- pattern 2: ...
- pattern 3: ...

注意: pattern 抽出のみ。implementation / scope decision / safety
judgment は出力しないでください。
```

## Codex 接続不可時は手書き完結可

「帰省中で Codex CLI にアクセスできない」「ChatGPT しか使えない」などの場合、Codex 利用なしで Lab 8b を完了してよい。`Codex-suggested patterns: N/A` を明示すれば合格。

## Q1 移行教訓の表現例

- 「safety_checklist の `safety_owner: TBD` は Q1 W1 開始前に必ず決定すること」
- 「trial_sheet の `episode_id: TBD` は executed への遷移時に concrete な episode_record を作成し参照すること」
- 「Q1 Package の `q1_execution_mode: TBD` は Q1 W1 pre-start gate で `mock` / `sim` / `real` のどれかに確定すること」
