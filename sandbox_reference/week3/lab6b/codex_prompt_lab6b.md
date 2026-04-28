---
type: reference
id: REF-W3-LAB6B-CODEX-PROMPT
title: Codex prompt 記入例 — Lab 6b (Scene Packet Bridge Stub)
week: 3
duration_min: 0
prerequisites: [W3-L6B]
worldcpj_ct: [CT-08]
roles: [common, sim]
references: []
deliverables: [codex_prompt_lab6b.md]
---

# Codex prompt 記入例 — Lab 6b (Scene Packet Bridge Stub)

> **instructor case 注記**: このファイルは Codex を実際に使用した出力ではなく、
> instructor が手書きした prompt 記入例です。
> Codex 利用なし、Sim 不要、Python 3.10 + json + sys 標準ライブラリのみ使用。

## 10-key reference

| # | key | 説明 |
|---|-----|------|
| 1 | 目的 (purpose) | 何を作るかを一行で明示 |
| 2 | 入力 (input) | 受け取る引数・ファイル形式 |
| 3 | 出力 (output) | 期待する stdout / 戻り値 |
| 4 | 制約 (constraints) | 使用禁止ライブラリ・副作用制限 |
| 5 | 成功条件 (success_criteria) | 終了コード・log 件数などの定量条件 |
| 6 | 検証コマンド (verify_cmd) | 生成後に実行すべき確認コマンド |
| 7 | 禁止事項 (prohibitions) | 実行してはいけない操作の列挙 |
| 8 | 言語バージョン (lang_version) | Python 3.10 等の具体バージョン |
| 9 | ログ形式 (log_format) | INFO / recv field= 等の書式 |
| 10 | 範囲外 (out_of_scope) | Affordance 判定・実機制御等 |

## prompt 5 項目記入例

### 1. 目的 (purpose)

```
JSON ファイルを読み込み、input 4 field (scene_packet, robot_state,
candidate_set, action_intent) を各々ログ出力して終了コード 0 を返す
Python スクリプトを生成してください。Sim 起動不要の finite script です。
```

### 2. 入力 (input)

```
コマンドライン引数 argv[1] で JSON ファイルパスを受け取ります。
JSON スキーマは以下の 4 field を持ちます:
  - scene_packet: dict
  - robot_state: dict
  - candidate_set: list
  - action_intent: null または dict
```

### 3. 制約 (constraints)

```
以下のライブラリ・モジュールは使用禁止:
  - subprocess
  - os.system
  - KDL (PyKDL 等)
  - controller_manager
  - rospy / rclpy (ROS 依存)
  - 外部 pip パッケージ全般
使用可: Python 3.10 標準ライブラリ (json, sys, logging のみ)
副作用禁止: ファイル書き込み・ネットワーク接続・プロセス起動
```

### 4. 成功条件 (success_criteria)

```
- 終了コード 0 (sys.exit(0) または return 0)
- stdout に "recv field=scene_packet" を含む行が 1 件以上出力される
- stdout に "recv field=robot_state" を含む行が 1 件以上出力される
- stdout に "recv field=candidate_set" を含む行が 1 件以上出力される
- stdout に "recv field=action_intent" を含む行が 1 件以上出力される
- python3 -m py_compile でエラー 0
```

### 5. 検証コマンド (verify_cmd)

```bash
python3 bridge_stub.py example_scene_packet.json > execution_log.txt 2>&1
echo "py_exit=$?"          # expect 0
grep -c "recv field=" execution_log.txt   # expect 4
python3 -m py_compile bridge_stub.py && echo "syntax OK"
wc -c execution_log.txt   # expect >= 200 bytes
```

## 禁止リスト補足

上記制約に加え、以下も明示的に禁止:

- `import subprocess` または `__import__("subprocess")` の記述
- `os.system(...)` または `os.popen(...)` の記述
- `import KDL` / `import PyKDL` / `from PyKDL` の記述
- `from controller_manager` / `import controller_manager` の記述
- Affordance 自動判定ロジックの実装 (SP4 以降の範囲)
- 実機センサー接続コードの実装 (SP5 以降の範囲)
