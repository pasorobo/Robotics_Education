# Lab 5 ヒント

## gz install 失敗

- apt source `packages.osrfoundation.org` 確認
- SP1 setup `course/00_setup/gazebo_fortress_setup.md` を再実行
- sudo 不可ならば version 確認のみで合格可 (CHECKLIST mandatory 項目 1 + 縮退)

## `gz` vs `ign` コマンド名差異

Fortress 過渡期、両方 fallback 可。Course の `tools/verify_env.sh --week 3` の `check_either gz ign` で判定。Lab 5 README/CHECKLIST/HINTS でも両系統明記。

## X11 forwarding 困難時

- `gz sim --headless-rendering shapes.sdf` (または `ign gazebo --headless-rendering`)
- 最悪、version 確認のみで合格可

## bridge YAML の `ros_topic_name` と `gz_topic_name` mapping ルール

- gz transport の topic 名は world / model / link / joint の hierarchical naming
- 例: `/world/default/model/panda/joint_state`
- ROS 2 側は flat naming で OK (`/joint_states`)
- topic 名の lower/upper case は厳密

## Stretch hands-on の robot model 拡張

SP6+ または Sandbox Bridge Role Owner で扱う。`<gazebo>` URDF extension で SP2 minimal_robot.urdf を拡張する必要あり。SP3 ベースラインからは外す。

## `/clock` が流れない (Stretch 実行時)

Gazebo は起動直後 **paused 状態** で `/clock` が進まない場合がある:

- GUI 利用時: 画面下部の **Play ボタン** を押して simulation を開始
- CLI で auto-run: `gz sim -r shapes.sdf` または `ign gazebo -r shapes.sdf` (`-r` flag)
- 上記でも `/clock` real-run が困難な環境: **learner baseline は version + YAML 写経まで** で合格、`/clock` real-run は instructor sandbox_reference 側で取得 (`sandbox_reference/week3/lab5/bridge_run.log` に instructor 実走結果あり)
