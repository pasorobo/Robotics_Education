---
type: guide
id: TOOL-CODEX-PROMPT
title: Codex Prompt 前 5 項目テンプレート
date: 2026-04-27
---

# Codex Prompt 前 5 項目テンプレート

Codex に依頼する前に、以下 5 項目を **自分の言葉で** 書く。書けないなら、まだ Codex に依頼するべきではない (タスク分解が不十分)。

## テンプレート (コピー用)

```
## 目的
- 何を達成したいか。1-2文。

## 入力
- どのファイル、どの関数、どのデータが Codex に渡されるか。

## 制約
- 言語、framework、依存関係、API互換性、命名規約など。
- 触ってはいけないファイル/関数も明記。

## 成功条件
- 何が起きれば「できた」と判断するか。具体的に。

## 検証コマンド
- 上記成功条件を確認するための具体コマンド or 手順。
- 例: `pytest tests/test_foo.py::test_bar -v`、`bash scripts/smoke.sh`。
```

## 委ねない判断 (Codex に依頼してはいけないこと)

- Affordance schema の設計
- 評価指標の定義
- 安全境界の判断
- 実機投入の可否判断

これらは PJ (人間) の責任で決める。Codex は実装補助・読解補助・検証補助。

## 記入例

```
## 目的
turtlesim の `/turtle1/cmd_vel` に1秒ごとに線速度0.5を publish する Python ノードを追加する。

## 入力
新規ファイル `course/week1/labs/lab1_turtlesim_rosbag/example_publisher.py` を作成。
既存の launch ファイルは変更しない。

## 制約
- ROS 2 Humble、`rclpy`
- Python 3.10
- 依存追加禁止 (標準ライブラリ + rclpy のみ)
- スリープは `rclpy` の Timer で実装、`time.sleep` は使わない

## 成功条件
- `ros2 run` で起動するとturtlesim が真っすぐ動く
- Ctrl-C で graceful shutdown (例外ログ無し)
- 30秒間 publish が継続

## 検証コマンド
1. `ros2 run turtlesim turtlesim_node &`
2. `python3 example_publisher.py &`
3. `ros2 topic hz /turtle1/cmd_vel` で約1Hz確認 (10秒)
4. `kill` で両方停止、終了コード 0 を確認
```

## レビュー観点 (PR Review Notes に記録)

- diff summary: どのファイルがどう変わったか
- 動く根拠: 検証コマンドの実行ログ
- 壊れうる条件: edge case、依存条件、環境差
- 採用しない提案: Codexが提案したが取らなかった選択肢と理由
- 追加修正: Codex出力にユーザーが加えた修正
