---
type: reference
id: REF-W3-LAB6-SCENE-PACKET-DESIGN
title: Scene Packet Design (instructor draft)
week: 3
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-08]
roles: [common, sim]
references: []
deliverables: []
---

# Scene Packet Design (instructor draft)

> instructor case = Panda demo (Lab 3) + minimal_robot mock_hardware (Lab 4) を sample case として 8 field 全埋め。`simulation_bridge_draft_example.md` の short version。

## input 4 field

### scene_packet

mock_hardware 環境では検出オブジェクト 0、`{"image_url": null, "obstacles": [], "timestamp": <epoch>}`。実機 + camera 接続後は Realsense + ArUco fixture から `image_url` 設定、`obstacles` に検出物体 (id + 3D pose) を埋める。

### robot_state

minimal_robot 1-joint case: `{"joints": {"j1": <angle>}, "ee_pose": <FK 計算>, "battery": null}`。Panda demo case: 7 joint × `<angle>`、ee_pose は MoveIt 2 の FK 出力流用。

### candidate_set

SP3 では provisional `[]` (空 list)。実装後の典型例: `[{"id": "cand_001", "grasp_pose": [x,y,z,r,p,y], "score": 0.82}, ...]`。SP4-5 で Affordance schema と接続して埋める。

### action_intent

SP3 では provisional `null`。実装後の典型例: `{"selected_id": "cand_001", "approach_axis": "z", "speed_scale": 0.3}`。Q1 後半 で Selection Logic と接続。

## output 4 field

### observation

mock_hardware から `/joint_states` (実 sensor 画像なし)。`{"joint_states": {"j1": 0.0}, "image": null, "tf": [...]}`。Stretch (Sandbox Bridge Role Owner): Gazebo 拡張で camera 画像を `image` に追加。

### execution_result

mock では「すべて success」(物理が無いため fail しようがない): `{"status": "success"}`。実機では `{"status": "success" | "fail"}`。

### failure_reason

mock では常に `null`。実機では `enum`: `"collision" | "unreachable" | "timeout" | "safe_no_action"`。

### metrics

mock では `null`。実機では task-specific KPI: `{"success_rate": 0.85, "time_to_grasp_sec": 3.2, "collision_count": 0}`。

## WorldCPJ 本物 schema 確定への接続

- SP4 (Q1 終盤): trial sheet / episode_record 設計と並行して field 詳細化予定
- Q1 後半: Affordance schema 設計フェーズで `candidate_set` `action_intent` の正式 type を確定
- 本 draft は **provisional として位置づけ**、SP4 完了時に再 review 予定
