---
type: reference
id: REF-W1-LAB1-README
title: Lab 1 reference bag — headless capture note
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-01]
roles: [common]
references: [R-04]
deliverables: []
---

# Lab 1 — Reference Bag: Headless Capture Note

## 背景

このディレクトリのリファレンスデータは、GUI なしの headless 環境で収録されたものです。

## headless 収録による制約

- `turtlesim_node` は表示ウィンドウを必要とするため、CI/ヘッドレス環境では起動しない。
- 代わりに `ros2 topic pub` で `/turtle1/cmd_vel` を合成パブリッシュしてバッグを収録した。
- その結果、このリファレンスバッグには **`/turtle1/cmd_vel` のみ** が収録されており、`/turtle1/pose` は含まれない。

## 実学習者との違い

実際の学習者が `turtlesim_node` + `teleop_turtle_key` を使って実行した場合は、バッグに以下の両トピックが含まれる:

| トピック | headless リファレンス | 実学習者実行 |
|---|---|---|
| `/turtle1/cmd_vel` | 収録済み | 収録済み |
| `/turtle1/pose` | **なし**（GUI 必要） | 収録済み |

## G4 ゲート充足状況

Lab 1 の G4 合格判定パターン（`bag_info.txt` の `Duration:`、`topics_with_message_count:`、`terminal_5min.log` サイズ）は、`/turtle1/cmd_vel` のみの収録でも充足している。

`/turtle1/pose` の欠如はヘッドレス収録の既知制約であり、SP1 リファレンス目的では許容される。

## SP2 以降の方針

SP2 以降の Lab では turtlesim 相当の GUI ノードが必要な手順について、学習者の実行環境（表示あり）を前提とした参照データを用意する。

## 関連ファイル

- `bag_info.txt` — `ros2 bag info` 出力（Duration、topics_with_message_count 含む）
- `rosbag_metadata.yaml` — バッグメタデータ
- `terminal_5min.log` — 収録セッションのターミナルログ
