---
type: reference
id: REF-W3-SIM-DECISION-TABLE-EXAMPLE
title: Simulator Decision Table 記入例 (instructor case)
week: 3
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-08]
roles: [common, sim]
references: []
deliverables: []
---

# Simulator Decision Table (記入例)

## 4 simulator × 4 軸 比較

| 軸 | Gazebo (Fortress) | MuJoCo | ManiSkill | Isaac Sim/Lab |
|---|---|---|---|---|
| rendering 忠実度 | 中 | 中 | 中-高 | **最高** |
| contact 物理 | 中 | **高精度** | 中-高 | 高 |
| parallel data 収集 | 弱 | 中 | **強** (parallel envs) | **最強** (large-scale RL) |
| ROS 2 統合 | **標準** (ros_gz_bridge) | 弱 (wrapper のみ) | 中 (community wrapper) | 中 (Isaac ROS) |

## 私の case と選択

- **私の case = Course 教材開発 + Q1 W3 SP3 教材**
- **選んだ simulator = Gazebo Fortress**
- **選んだ理由 = ROS 2 統合が標準、教育計画 §4.4 で Q1 標準として指定、install + GUI が他より軽量、SP4 (Logging) で `/clock` bridge が必要なため SP3 で Gazebo 経験を積んでおく**

## Phase 0 後の宿題 (Stretch goal)

- ManiSkill を Q1 後半 RL training 検討時に評価 (Sandbox Bridge Role Owner)
- Isaac は SP6+ で再評価 (NVIDIA stack 整備状況次第)
- MuJoCo は Q1 後半に物理精度比較が必要になった時に検討

---

| 記入者 | 記入日 |
|---|---|
| pasorobo (instructor) | 2026-04-28 |
