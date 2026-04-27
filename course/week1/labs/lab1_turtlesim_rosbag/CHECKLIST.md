# Lab 1 合格チェック

- [ ] `ros2 topic echo /turtle1/cmd_vel` で teleop の入力に応じて値が出る
- [ ] `ros2 bag record` で `/turtle1/cmd_vel` `/turtle1/pose` を含む bag が生成
- [ ] `ros2 bag play` で turtlesim が同じ動きをする
- [ ] `bag_info.txt` に `Duration:` または `Topic information:` が含まれる (非空)
- [ ] `rosbag_metadata.yaml` に `topics_with_message_count:` が含まれる
- [ ] `terminal_5min.log` が 1 KB 以上、Step 1〜Step 8のコマンドが含まれる
- [ ] 自Sandboxで上記 3 ファイルのみを commit、`.db3`/`.mcap`/`rosbag2_*/` は含まれない
- [ ] PRを作成しレビューを依頼 (受けるレビュアーは Lab 4b 以降の本格運用までは任意)
