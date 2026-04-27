# Lab 4b ヒント

## Codex 接続再確認

W1 Lab 0 で接続確認した workspace + GitHub connector がまだ有効か:

- ChatGPT Enterprise sign-in
- Codex タブ → workspace 確認
- GitHub connector が approved 状態
- 自 Sandbox repo にアクセス可能

## Codex GitHub connector が承認待ち

Lab 4b では Codex を直接使わず、prompt 5 項目を書いた上で **手書き** で `noop_logger.py` を作るルートも合格可。Sandbox PR Review Notes の「Codex prompt」欄に「Codex 利用なし、prompt 5 項目に従って手書き」と記録。

## Python syntax check

`python3 -m py_compile noop_logger.py` を使う (`bash -n` は bash 専用)。エラーがあれば対象行が表示される。

## mock_hardware 動作中は `/joint_states` 自動流入

Lab 4 launch が background で動いていれば `/joint_states` は自動的に流れる (controller_manager + joint_state_broadcaster が publish)。

**単体検証** (mock_hardware なしで noop_logger.py だけテスト) する場合のみ、別 terminal で:

```bash
timeout 5s ros2 topic pub --rate 1 /joint_states sensor_msgs/msg/JointState \
  '{header: {stamp: {sec: 0, nanosec: 0}, frame_id: "base_link"},
    name: ["j1"], position: [0.0], velocity: [0.0], effort: [0.0]}'
```

完全形 (header + name + position + velocity + effort) で安定。`--rate 1` (毎秒 1 回) を推奨 (`--once` は subscriber 起動前に 1 回だけ publish されて取りこぼし得る)。

## 禁止語含有時の対処

Codex 出力に禁止リスト違反が含まれていた場合:

1. 採用しない (commit しない)
2. Codex に「禁止リスト違反のため、IK/KDL/URDF parsing/trajectory/controller 操作/安全判断自動化 を含まないコードに再生成してください」と指示
3. Sandbox PR Review Notes の「採用しない提案」に記録 (どんな違反だったか、どう指示したか)
