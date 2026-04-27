---
type: reference
id: REF-W2-LAB4-README
title: Lab 4 instructor walk-through summary (hand-authored, ros2_control 未インストール環境)
week: 2
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-06]
roles: [common, adapter]
references: [R-11, R-12]
deliverables: []
---

# Lab 4 — Instructor walk-through summary

## 実施環境

- Ubuntu 22.04 + ROS 2 Humble (SP1 で確認済)
- **ros2_control + ros2_controllers は未インストール状態**で本 walk-through を作成 (instructor 環境で sudo 不可のため apt install 未実行)
- log content は plan §3.4 / §4.3 の正規化された期待出力を hand-author
- spec §4.8 縮退ルール準拠。SP2 完了時の reference 機能 (G4 patterns) は満たすが、G3 PASS は instructor 環境再構築後に取得予定
- 学習者は本 README + 教材 `course/week2/labs/lab4_mock_hardware_adapter/README.md` の手順に従い real run することで本格証跡を作成可能

## 想定実施手順

1. Lab 4 README の 5 ファイル (package.xml / CMakeLists.txt / urdf / yaml / launch.py) を `~/lab4_ws/src/minimal_robot_bringup/` に写経
2. `cd ~/lab4_ws && colcon build --packages-select minimal_robot_bringup`
3. `source install/setup.bash && ros2 launch minimal_robot_bringup minimal_lab4.launch.py > controller_spawn.log 2>&1 &`
4. `sleep 5 && ros2 control list_controllers > controllers_list.txt`
5. `timeout 5s ros2 topic echo /joint_states > joint_states_echo.log 2>&1 || true`
6. `kill $LAUNCH_PID 2>/dev/null || true`

## 観察される挙動 (real run 時の期待)

- controller_manager が 100 Hz で update
- mock_components/GenericSystem が configure → activate
- joint_state_broadcaster が先に spawn (~1 秒)、forward_position_controller が後 (~2 秒、event_handler 経由)
- /joint_states が 100 Hz で publish (5 秒分 = 約 500 件)

## 詰まった点 (hand-author 段階で想定)

- なし。実装はシンプル。

## 提出物

- [`controller_spawn.log`](./controller_spawn.log) (hand-authored realistic log)
- [`controllers_list.txt`](./controllers_list.txt) (hand-authored with `active`)
- [`joint_states_echo.log`](./joint_states_echo.log) (hand-authored with `position:` `name:`)
