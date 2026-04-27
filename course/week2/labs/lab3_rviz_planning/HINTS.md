# Lab 3 ヒント

## demo が起動しない

- `ros-humble-moveit-resources-panda-moveit-config` がインストールされているか確認:
  ```bash
  dpkg -l | grep ros-humble-moveit-resources-panda
  ```
- `bash tools/verify_env.sh --week 2` で全 PASS を確認。

## Plan 失敗が出ない

- joint limit 外 pose が最易。手動で `panda_joint1 = +3.0` (limit `+2.8973`) など limit 超えを設定。
- `<random valid>` は valid な goal を選ぶので失敗しない。`<random>` (no valid) を試すと届かない pose が混ざる。
- collision object 追加は MoveIt RViz の `Scene Objects` タブ操作が必要で初学者には負担。joint limit 外を推奨。

## RViz Planning タブ位置

- 左パネルに Displays / MotionPlanning が表示されている。
- MotionPlanning > Planning タブ (大きいタブ)
- Joints タブ: 各 joint を slider で動かして goal を作る最易ルート

## GUI 取得困難時 (X11 forwarding / VNC が使えない)

- `move_group` の terminal log のみで `planning_evidence.md` を作成可能。
- 例: `ros2 service call /plan_kinematic_path moveit_msgs/srv/GetMotionPlan ...` で CLI から planning を呼ぶことも可能 (中級)
- screenshot は省略可能 (CHECKLIST 合格条件外)
