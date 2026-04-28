# Lab 6b 合格チェック

- [ ] prompt 5 項目を `wk3/lab6b/codex_prompt_lab6b.md` に記述した
- [ ] Codex 出力 `bridge_stub.py` の diff を読んだ (禁止リスト + 追加禁止 違反なし確認)
- [ ] **`python3 bridge_stub.py example_scene_packet.json` が exit code 0 で正常終了**
- [ ] **input 4 field すべてについて `recv field=` log が出力される** (4 件確認)
- [ ] **`python3 -m py_compile bridge_stub.py` が syntax error なく通る**
- [ ] Sandbox PR Review Notes 6 行すべて記入 (W2 template 流用)
- [ ] **schema 整合性確認**: provisional schema の input 4 field (`scene_packet`, `robot_state`, `candidate_set`, `action_intent`) すべてが log に出ている、**output 4 field は本 stub では扱わない** (`simulation_bridge_draft.md` の設計対象、Lab 6 で完了済)
- [ ] **禁止リスト遵守を人間が確認**: bridge_stub.py に IK / URDF parsing / trajectory / controller / 安全判断自動化 / **実 simulator 起動 / 実 ros_gz_bridge 操作 / Affordance 自動判定** の **実コード** がないことを目視確認 (コメント言及や "Does not start simulator" 等の説明文は OK)
