# Lab 5 合格チェック

## mandatory (4 項目)

- [ ] Gazebo CLI version 取得 (`gz sim --version` **または** `ign gazebo --version`)
- [ ] Gazebo GUI 起動 (`gz sim shapes.sdf` **または** `ign gazebo shapes.sdf`、X11 困難時は `--headless-rendering` または version 確認のみで合格可)
- [ ] `bridge_config.yaml` を Sandbox に commit (教材雛形の `/clock` mandatory 部分を写経、`/joint_states` 概念例コメントアウト併記)
- [ ] `/joint_states` bridge は **概念例として理解** (実行は Stretch、joint を持つ robot model が必要)

## Stretch (3 項目、Sandbox Bridge Role Owner)

- [ ] joint を持つ robot model (例: SP2 minimal_robot を `<gazebo>` extension 拡張) を Gazebo で起動
- [ ] 実 `ros_gz_bridge` で `/clock` + (拡張なら) `/joint_states` mapping
- [ ] `ros2 topic list` で両 ROS topic 確認、`bridge_run.log` + `bridge_topic_list.txt` を Sandbox commit
