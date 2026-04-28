# Lab 6b ヒント

## bridge_stub.py は finite script

bridge_stub.py は **常駐 ROS node ではない**。`python3 bridge_stub.py example_scene_packet.json` で 1 回実行し JSON 1 ファイル分の log を出力して終了する設計。timeout 不要、Ctrl-C 不要。

Codex が `rclpy` import や `KeyboardInterrupt` 処理を含むコードを生成した場合 → **不要なため採用しない** (Notes 「採用しない提案」に記録)。

## Python syntax check

`python3 -m py_compile bridge_stub.py` を使う (`bash -n` は bash 専用)。エラーがあれば対象行が表示される。

## JSON file load の最小実装

```python
import json
with open(sys.argv[1]) as f:
    data = json.load(f)
for field, value in data.items():
    type_name = type(value).__name__
    print(f"recv field={field} type={type_name} value={value}")
```

## schema 整合性チェックの観点

本 stub は **input 4 field のみ** を JSON load して INFO log 出力する設計。output 4 field (`observation`, `execution_result`, `failure_reason`, `metrics`) は `simulation_bridge_draft.md` 設計演習 (Lab 6) で扱う対象であり、本 stub の実行対象外。

Codex が output 4 field も処理するコードを生成した場合 → **不要として採用しない** (Lab 6 と Lab 6b の責務分離)。

## 禁止語含有時の対処 (Lab 4b 流用 + 追加)

- IK / KDL / URDF parsing / trajectory / controller / 安全判断自動化 (Lab 4b 流用) → 採用拒否、Notes 記録
- **追加禁止 (Lab 6b 固有)**:
  - `subprocess.run(["gz", "sim", ...])` 等で実 simulator 起動 → 採用拒否 (本 stub は JSON load のみ、simulator 不要)
  - `subprocess.run(["ros2", "run", "ros_gz_bridge", ...])` で bridge 起動 → 採用拒否
  - `if score > threshold: select(...)` 等の Affordance 自動判定 → 採用拒否 (人間判断が必要)

採用しない場合は Codex に「禁止リスト違反のため再生成」と指示し、Sandbox PR Review Notes に「採用しない提案」として記録。
