---
type: template
id: W2-T-ROBOT-READINESS
title: Robot Readiness Mini Report (template)
week: 2
duration_min: 15
prerequisites: [W2-Lab4]
worldcpj_ct: [CT-06, CT-09]
roles: [common, adapter, calibration, safety]
references: [R-11, R-13, R-15, R-30]
deliverables: []
---

# Robot Readiness Mini Report

> このテンプレートを自 Sandbox にコピーし、Lab 4 完了時に **全 7 行を記入** してください。
>
> **空欄 NG / 未確認なら「未確認」と書く**。mock 環境では多くの行が「未確認 / SP4-5 で評価予定 / 実機接続なし」になりますが、それを **明示する** ことが本テンプレの目的です。

| 項目 | 記入内容 |
|---|---|
| robot_id | `<UR7e / CRX / CobotMagic / Kachaka / Panda demo / minimal_robot / その他>` |
| adapter stage | `<no-op / mock_hardware / URDF+IK mock / URSim / real のうち到達した最高段階>` |
| ROS interface | `<driver / controller / topic / action / service の主な interface 列挙>` |
| calibration state | `<intrinsic / extrinsic / hand-eye / fixture それぞれ 完了 / 未確認 / SP5 で評価予定>` |
| safety state | `<emergency stop / safeguard / protective / safe no-action / operator confirmation の確認状態。mock 環境では「未確認 / SP4 で評価予定 / 実機接続なし」可>` |
| logging state | `<rosbag2 topics / episode_record / trial sheet の有無、wk*/lab*/ に commit 済み証跡>` |
| next gate | `<G1 offline/sim evidence / G2 minimal real-robot trial / Phase 0 後の宿題 (例: URDF+IK mock adapter を別 PR で検討)>` |

## 自由記述

### 詰まった点

TBD

### 次に試したいこと

TBD

### Phase 0 後の宿題 (Stretch goal)

TBD (例: URDF + IK mock adapter を別 PR で実装、URSim 接続、camera_calibration ハンズオン)

---

| 記入者 | 記入日 |
|---|---|
| `<name>` | `YYYY-MM-DD` |
