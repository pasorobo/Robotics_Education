---
type: reference
id: W4-REF-CODEX-PATTERN-EXTRACT
title: codex_pattern_extract example — optional Codex usage in Lab 8b
week: 4
duration_min: 15
prerequisites: [W4-Lab8b]
worldcpj_ct: [CT-04]
roles: [common, sandbox]
references: [R-28]
deliverables: []
---

# codex_pattern_extract example (Lab 8b 任意 Codex 利用)

> **artifact_status**: sandbox_example
>
> Lab 8b で **Codex を利用する場合** の擬似 example。instructor case (Codex 利用なし) では「もし Codex を使うなら」の参考として置く。

## 想定 prompt

```
以下は私の Sandbox PR Review Notes (W2 + W3 計 3 件) です。
共通 pattern を 3 行で抽出してください。

注意: pattern 抽出のみ。implementation / scope decision / safety
judgment は出力しないでください。

---
[W2 Lab 4 PR Notes 抜粋]
- mock adapter で /joint_states を publish するが topic 名 typo で他 node が subscribe できなかった
- launch file の use_sim_time false が原因で tf_static の timestamp が古いと判定された

[W3 Lab 5 PR Notes 抜粋]
- ros_gz_bridge YAML の topic 名前が gz 側と ros 側で逆だった
- Gazebo 起動時に GZ_PARTITION 未設定で複数 instance が衝突

[W3 Lab 6 PR Notes 抜粋]
- provisional schema の output 4 field のうち failure_reason が unknown のまま放置
```

## Codex-suggested patterns (3 行抽出)

```
1. topic / param 名前の typo / mismatch (W2 launch / W3 ros_gz_bridge YAML 共通)
2. environment variable や launch arg の sourcing / 設定漏れ (use_sim_time, GZ_PARTITION)
3. provisional schema の output field を unknown のまま放置せず、Phase 0 では unknown 容認 + 空欄 NG ルールを徹底
```

## Accepted / rejected 分離記録

- **Accepted**: 1, 2 — 確かに W2/W3 共通の pattern として human-found patterns に追記する価値あり
- **Rejected**: 3 — provisional schema の output field policy は spec §3.4 で既に定めており、本 review summary で再記載は冗長。reject。
