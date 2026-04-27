# Lab 2 合格チェック

- [ ] static_transform_publisher が3つ起動成功 (`ros2 node list` で見える)
- [ ] `tf2_echo map tool0` で 6-DOF transform が出力 (Translation, Rotation 行)
- [ ] `view_frames` でローカルにPDFが生成 (内容確認のみ、commitしない)
- [ ] `frame_inventory.md` に Mermaid code fence が含まれる
- [ ] `frame_inventory.md` に `base_link`, `camera_link`, `tool0` の3キーワードがすべて含まれる
- [ ] 表で各frameの親・用途・備考が書かれている
- [ ] Sandbox に commit/PR、`frames.pdf` `frames.gv` は含まれない (.gitignore で block)
