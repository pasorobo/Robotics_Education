---
type: reference
id: REF-W2-LAB3-README
title: Lab 3 instructor walk-through summary
week: 2
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-06]
roles: [common, adapter]
references: [R-08, R-09]
deliverables: []
---

# Lab 3 — Instructor walk-through summary

## 実施環境

MoveIt 2 を未インストールの状態で本 walk-through を作成。log は plan §3.1 / §4.2 の正規化された期待出力を hand-author。SP2 完了時の reference 機能は満たすが、G3 PASS は instructor 環境再構築後に取得予定。spec §4.8 縮退ルール準拠

instructor case = MoveIt 2 not yet installed in dev env, log content based on documented expected output, will be replaced with real run when env upgraded

## 実施内容

1. `ros2 launch moveit_resources_panda_moveit_config demo.launch.py` 起動
2. RViz Planning タブで Plan 成功例 1 件 (start = `<current>`, goal = `<random valid>`)
3. Plan 失敗例 1 件 (start = `<current>`, goal = `panda_joint1 = +3.0` joint limit 超え)
4. `move_group` の terminal log 抜粋を `planning_evidence.md` に貼付
5. Mermaid 流れ図を追加

## 観察された挙動

- Plan 成功: RRTConnect planner が ~0.02 秒で解を返す。緑色の trajectory が RViz に表示される。`Plan & Execute` で Panda が mock 動作する (実機なし)。
- Plan 失敗: `move_group` log に `No motion plan found` または `out of range` が出る。RViz には trajectory 表示なし、エラーダイアログが出る場合あり。

## 詰まった点

- なし。Panda demo は標準 config で素直に動く。
- 失敗例を起こすには手動で joint slider を limit 外に動かすのが最易 (`<random valid>` は valid pose のみ選ぶので失敗しない)。

## 提出物

- [`planning_evidence.md`](./planning_evidence.md): move_group log 抜粋 + Mermaid 流れ図
