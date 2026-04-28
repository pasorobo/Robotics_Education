---
type: reference
id: REF-W3-LAB6B-README
title: Lab 6b instructor walk-through summary (Codex no-op Bridge Stub)
week: 3
duration_min: 0
prerequisites: [W3-L6]
worldcpj_ct: [CT-08]
roles: [common, sim]
references: []
deliverables: [codex_prompt_lab6b.md, example_scene_packet.json, bridge_stub.py, execution_log.txt]
---

# Lab 6b — Instructor walk-through summary

## 10-key reference

| # | key | 内容 |
|---|-----|------|
| 1 | Lab ID | W3-L6B |
| 2 | 目的 | Scene Packet input 4 field の bridge stub を Python で実装し REAL run する |
| 3 | 前提 | Lab 6 の provisional schema 設計 (8 field) が完了していること |
| 4 | Sim 要否 | **不要** — finite script、Gazebo / ros_gz_bridge 起動不要 |
| 5 | 言語 | Python 3.10+、stdlib のみ (json / sys / logging) |
| 6 | 入力 | `example_scene_packet.json` (input 4 field: scene_packet / robot_state / candidate_set / action_intent) |
| 7 | 出力 | `execution_log.txt` (recv field= 4 件 + exit=0) |
| 8 | 禁止 | subprocess / os.system / KDL / controller_manager / rospy / rclpy |
| 9 | SP3 G3 | partial でも本 Lab は完全 REAL run 可能 (Sim G3 依存なし) |
| 10 | 次ステップ | SP4 で Affordance schema と接続、candidate_set / action_intent を本実装へ |

## 実施環境

- Sim 環境**不要** (finite script のため)
- Python 3.10 + json + sys 標準ライブラリのみ使用
- 所要時間: 約 30 分 (JSON 設計 10 分、bridge_stub 実装 15 分、REAL run 確認 5 分)

## instructor case

> **Codex 利用なし手書き**: このファイル群は Codex を実際に使用した出力ではなく、
> instructor が手書きした実装例です。

- sample case = SP2 で動かした **Panda demo (Lab 3 RViz planning) + minimal_robot mock_hardware (Lab 4)** を流用
- `example_scene_packet.json`: Panda 7-joint 初期角度 + minimal_robot mock 値を使用
- `candidate_set`: SP3 では provisional 1 件 (score=0.82)、SP4 で Affordance schema と接続予定
- `action_intent`: SP3 では `null`、Q1 後半で Selection Logic と接続予定

## REAL run 結果

```bash
python3 sandbox_reference/week3/lab6b/bridge_stub.py \
    sandbox_reference/week3/lab6b/example_scene_packet.json \
    > sandbox_reference/week3/lab6b/execution_log.txt 2>&1
echo "py_exit=$?"        # 0
grep -c "recv field=" sandbox_reference/week3/lab6b/execution_log.txt  # 4
wc -c execution_log.txt  # 902 bytes
```

| 確認項目 | 結果 |
|---------|------|
| py_exit | 0 |
| recv field= 件数 | 4 |
| py_compile | syntax OK |
| log サイズ | 902 bytes (>= 200 bytes) |

## SP3 G3 partial 対応注記

SP3 G3 (Gazebo フル統合) が partial 状態でも、本 Lab の bridge_stub.py は
Sim 不要の finite script であるため、**完全 REAL run 可能**。
Gazebo / ros_gz_bridge の環境構築状況に依存しない独立した検証が行える。

## G4 パターン確認 (6 件)

| # | ファイル | パターン | 確認 |
|---|---|---|---|
| 1 | codex_prompt_lab6b.md | 目的/入力/制約/成功条件/検証コマンド/禁止 6 項目 | OK |
| 2 | example_scene_packet.json | input 4 field key 全 4 件 | OK |
| 3 | bridge_stub.py | json.load による JSON 読み込み | OK |
| 4 | bridge_stub.py | recv field= 形式ログ出力 | OK |
| 5 | execution_log.txt | recv field= 4 件 (全 input field) | OK |
| 6 | execution_log.txt | bridge_stub 起動・終了ログ + >= 200 bytes | OK |

## 注意事項

- `subprocess` / `os.system` の import は bridge_stub.py に**含まれていない**。
  実装を拡張する場合も、これらの禁止 import を追加しないこと。
- Affordance 自動判定ロジックは **SP4 以降の範囲**。bridge_stub.py には含めない。
- `candidate_set` / `action_intent` の本格実装は SP4-5 フェーズで行う。
