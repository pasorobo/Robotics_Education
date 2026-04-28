---
type: reference
id: W4-REF-BAD-Q1-PACKAGE
title: bad_q1_package_example — INTENTIONALLY INVALID, do not copy
week: 4
duration_min: 15
prerequisites: [W4-Lab8]
worldcpj_ct: [CT-09]
roles: [common, sandbox]
references: [R-30]
deliverables: []
---

# **不採用例 (bad example) — INTENTIONALLY INVALID, do not copy**

> **artifact_status**: intentionally_invalid_example
>
> **do_not_copy: true**
>
> 本 file は教材として **何が不採用例か** を示すために置かれている。実際に Sandbox にコピーしないこと。`source_artifact_path` には dead link / plain text placeholder のみ書かれており、Markdown link は使っていない。

## YAML header (intentionally invalid)

```yaml
artifact_status: intentionally_invalid_example
do_not_copy: true
```

## なぜ不採用か (4 件の bad pattern)

### Bad pattern 1: safety review marked done without reviewer

```yaml
review_status: approved   # ❌ NG: reviewer_name / reviewer_role / reviewed_at が未記入
reviewer_name: TBD
reviewer_role: TBD
reviewed_at: TBD
```

**理由**: `review_status: approved` は `reviewer_name` / `reviewer_role` / `reviewed_at` が埋まっている場合のみ許可。安全に直結する review が空 reviewer で承認になっている。

### Bad pattern 2: trial_sheet copies template content

```yaml
# ❌ NG: Q1 Package 内に trial_sheet の 15 rows を直接コピーしている
rows:
  - row: 7_trial_kpi_plan
    rows_inline:
      - {trial_id: trial_001, ...}
      - {trial_id: trial_002, ...}
      # ... 13 more
```

**理由**: Q1 Package は他 templates を **参照** する meta package。data を copy すると trial_sheet 更新時に Q1 Package を全書き直しする必要が出る。`source_artifact_path` で path 参照すべき。

### Bad pattern 3: Q1 W2-W3 omitted without re_judge_gates

```yaml
# ❌ NG: q1_w1_pre_start と q1_w1_exit のみ。q1_mid_point / q1_closeout が silent omission
re_judge_gates:
  - gate_id: q1_w1_pre_start
    ...
  - gate_id: q1_w1_exit
    ...
```

**理由**: Q1 W2 以降の detail (failure taxonomy 改訂 / KPI / operator workflow) を Phase 0 で prescribe しない方針だが、その判断 gate を `re_judge_gates` で **deferred 明示** する必要がある。silent omission は bad pattern。

### Bad pattern 4: Codex accepted without rationale

```yaml
# ❌ NG: Codex が出力した scope decision を rationale なしで採用
phase0_review_summary_path: missing/path/example.md  # intentionally invalid
```

(本 file の dead link は plain text placeholder で記載 — Markdown link `[]()` は使わない、G5a が dead link を検出するため)

**理由**: Lab 8b で「Codex は summarize 可、判断・実装は不可」と定めている。Q1 縮小 Lv1 の scope 判断 (CC/MS どこまで、人協調/双腕入れるか) を Codex に委ね、accepted/rejected の rationale なしに採用するのは bad pattern。

## 正しい例

→ [q1_reduced_lv1_execution_package_example.md](./q1_reduced_lv1_execution_package_example.md) を参照
