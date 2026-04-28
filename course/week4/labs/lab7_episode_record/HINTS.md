# Lab 7 HINTS

## SP1 bag の再利用方法

`sandbox_reference/week1/lab1/bag_info.txt` には以下の情報がある:
- Files / Bag size / Storage id → `log_summary` として要約
- Duration → `duration_sec` (秒数)
- Topic information → `recorded_topics` のリスト

新たに `ros2 bag record` する必要は **ない**。SP1 W1 Lab 1 で既に取得済。

## failure_reason taxonomy 解釈例

- `result: success` → `failure_reason: none` (固定)
- mock 環境での実行は通常 success → none となる
- もし turtlesim 起動に失敗していたら `result: failure` + `failure_reason: environment_or_setup_failure`
- 分類不能なら `unknown` 容認 (空欄 NG)

## mock 環境では result: success が多い前提

W1 turtlesim は mock 環境 (`environment_mode: mock`) かつ実機判定なし。`result: success` / `failure_reason: none` がデフォルト。

## bag commit 禁止 (軽量証跡のみ)

Course repo / Sandbox repo どちらでも raw bag (`*.db3`, `*.mcap`) を commit しない。`bag_info.txt` などの軽量証跡を `evidence_path` に格納するのみ。

## なぜ Q1-specific keys が `not_applicable` なのか

W1 turtlesim は **Phase 0 training episode** であり、Q1 縮小 Lv1 の 5 物体 × 3 trials の 1 trial ではない。Q1 trial と混同を避けるため、`q1_package_id` / `trial_sheet_id` / `object_id` は `not_applicable` または `training_*` で明示する。
