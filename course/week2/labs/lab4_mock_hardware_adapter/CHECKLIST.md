# Lab 4 合格チェック

- [ ] colcon build 成功 (`Summary: 1 package finished`)
- [ ] launch 起動成功 (controller_spawn.log に `controller_manager` 起動ログ)
- [ ] `joint_state_broadcaster` active (`ros2 control list_controllers` で確認)
- [ ] `controllers_list.txt` を Sandbox に commit (`active` 表示含む)
- [ ] `/joint_states` non-empty (5 秒分 echo log)
- [ ] **Robot Readiness Mini Report 全 7 行記入** (空欄 NG。`safety state` は「未確認 / SP4 で評価予定 / 実機接続なし」可)
- [ ] `next gate` 欄に「URDF + IK mock adapter を別 PR で検討」と記載
