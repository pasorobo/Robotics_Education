# Lab 6 ヒント

## 8 field 埋め方例

各 field の記述粒度の目安:

| field | 記述粒度の目安 | 例 |
|-------|--------------|-----|
| `scene_packet` | world / 環境の snapshot を 1 文で | `"Gazebo Fortress, empty world, Panda arm at origin"` |
| `robot_state` | joint / pose / velocity を key-value で | `"joint_1: 0.0 rad, joint_2: -0.5 rad, ee_pos: [0.3, 0.0, 0.6]"` |
| `candidate_set` | planner が出した行動候補をリストで | `"[reach_target, home_pose, stop, emergency_stop]"` |
| `action_intent` | なぜその行動を選んだかの理由 | `"reach_target: goal が EE から 0.2m 以内のため"` |
| `observation` | センサ topic / 値を明記 | `"/joint_states: [...], /camera/image: 640x480"` |
| `execution_result` | success / fail + 変化した状態 | `"success: EE が goal 位置 [0.5, 0.0, 0.4] に到達"` |
| `failure_reason` | 失敗原因 (未発生なら `"N/A"`) | `"N/A"` または `"joint_2 velocity limit 超過"` |
| `metrics` | 単位付き数値 | `"exec_time: 3.2s, path_length: 0.45m"` |

## 自分の case が思いつかない時

以下のいずれかを使ってよい (Sim 実行不要、記憶・ログから記述 OK):

1. **SP1 turtlesim**: 最もシンプル。`/turtle1/pose` を `observation` に、`/turtle1/cmd_vel` を `action_intent` に対応付け。
2. **SP2 Panda demo**: MoveIt2 の `plan & execute` 1 cycle を 1 schema に対応付け。`candidate_set` は MoveIt2 が内部で生成するパス候補。
3. **SP2 minimal_robot**: URDF 自作 robot の joint 1 つを動かす最小例。`scene_packet` は `"RViz2, minimal_robot, joint_1 target=1.0 rad"` など。
4. **架空 case**: 実在しない robot でも可 (schema 設計練習が目的のため)。その場合は `scene_packet` に `"(hypothetical)"` と注記。

## WorldCPJ 本体 schema 確定タイミング

- 本 Lab (W3-Lab6) の schema は **provisional** (暫定設計)
- WorldCPJ 本体の schema は **SP4-5 / Q1 後半** で確定予定
- SP4 では本 Lab の provisional schema を見直し、実際の WorldCPJ format に align する
- 今は「8 field の意味を理解し、自分の case で埋められること」が目標であり、field 名や型が変わっても問題ない
