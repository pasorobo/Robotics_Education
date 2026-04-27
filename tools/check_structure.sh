#!/usr/bin/env bash
# tools/check_structure.sh
# Static structure validator for SP1.
# Spec G1/G2/G4/G5a (§5.1, §5.2).

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

ERR=0
WARN=0
PASSED=0

err()  { printf "  [FAIL] %s\n" "$1"; ERR=$((ERR+1)); }
warn() { printf "  [WARN] %s\n" "$1"; WARN=$((WARN+1)); }
ok()   { PASSED=$((PASSED+1)); }

# ---------- G1: File existence ----------
echo "==== G1: File existence (42 expected files) ===="

EXPECTED_FILES=(
    "README.md"
    "CONTRIBUTING.md"
    ".gitignore"
    "docs/Robotics_simulation_phase0_education_plan.md"
    "docs/CONVENTIONS.md"
    "docs/glossary.md"
    "docs/references.md"
    "course/00_setup/README.md"
    "course/00_setup/ubuntu_2204_humble_setup.md"
    "course/00_setup/gazebo_fortress_setup.md"
    "course/00_setup/moveit2_humble_setup.md"
    "course/00_setup/verify_setup.sh"
    "course/week1/README.md"
    "course/week1/lectures/l0_git_codex_sandbox.md"
    "course/week1/lectures/l1_ros2_basics.md"
    "course/week1/lectures/l2_tf_urdf.md"
    "course/week1/labs/lab0_sandbox_setup/README.md"
    "course/week1/labs/lab0_sandbox_setup/CHECKLIST.md"
    "course/week1/labs/lab0_sandbox_setup/HINTS.md"
    "course/week1/labs/lab1_turtlesim_rosbag/README.md"
    "course/week1/labs/lab1_turtlesim_rosbag/CHECKLIST.md"
    "course/week1/labs/lab1_turtlesim_rosbag/HINTS.md"
    "course/week1/labs/lab2_tf_tree/README.md"
    "course/week1/labs/lab2_tf_tree/CHECKLIST.md"
    "course/week1/labs/lab2_tf_tree/HINTS.md"
    "course/week1/deliverables/skill_baseline_sheet_template.md"
    "course/week1/deliverables/sandbox_setup_log_template.md"
    "sandbox_reference/README.md"
    "sandbox_reference/week1/skill_baseline_sheet_example.md"
    "sandbox_reference/week1/sandbox_setup_log_example.md"
    "sandbox_reference/week1/lab0/codex_connection_check.md"
    "sandbox_reference/week1/lab1/bag_info.txt"
    "sandbox_reference/week1/lab1/rosbag_metadata.yaml"
    "sandbox_reference/week1/lab1/terminal_5min.log"
    "sandbox_reference/week1/lab2/frame_inventory.md"
    "tools/verify_env.sh"
    "tools/new_week_skeleton.sh"
    "tools/codex_prompt_template.md"
    "tools/check_structure.sh"
    "docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md"
    "docs/superpowers/plans/2026-04-27-robotics-course-sp1-plan.md"
    "sandbox_reference/week1/lab0/README.md"
)

for f in "${EXPECTED_FILES[@]}"; do
    if [[ -e "$f" ]]; then
        ok
    else
        err "missing: $f"
    fi
done

# ---------- G2: Front matter (course 10-key) ----------
echo
echo "==== G2: Front matter (course docs require 10 keys) ===="

COURSE_TEN_KEY_FILES=(
    "course/week1/README.md"
    "course/week1/lectures/l0_git_codex_sandbox.md"
    "course/week1/lectures/l1_ros2_basics.md"
    "course/week1/lectures/l2_tf_urdf.md"
    "course/week1/labs/lab0_sandbox_setup/README.md"
    "course/week1/labs/lab1_turtlesim_rosbag/README.md"
    "course/week1/labs/lab2_tf_tree/README.md"
    "course/week1/deliverables/skill_baseline_sheet_template.md"
    "course/week1/deliverables/sandbox_setup_log_template.md"
    "course/00_setup/README.md"
    "course/00_setup/ubuntu_2204_humble_setup.md"
    "course/00_setup/gazebo_fortress_setup.md"
    "course/00_setup/moveit2_humble_setup.md"
    "sandbox_reference/week1/skill_baseline_sheet_example.md"
    "sandbox_reference/week1/sandbox_setup_log_example.md"
    "sandbox_reference/week1/lab0/README.md"
    "sandbox_reference/week1/lab0/codex_connection_check.md"
    "sandbox_reference/week1/lab2/frame_inventory.md"
)

REQUIRED_KEYS=(type id title week duration_min prerequisites worldcpj_ct roles references deliverables)

for f in "${COURSE_TEN_KEY_FILES[@]}"; do
    [[ -f "$f" ]] || continue   # missing reported by G1
    # Extract front matter (between first two --- lines)
    if ! awk '/^---$/{c++; if(c==2)exit; next} c==1' "$f" | grep -q .; then
        err "no front matter: $f"
        continue
    fi
    fm=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$f")
    missing_keys=()
    for k in "${REQUIRED_KEYS[@]}"; do
        if ! echo "$fm" | grep -qE "^${k}:"; then
            missing_keys+=("$k")
        fi
    done
    if [[ ${#missing_keys[@]} -eq 0 ]]; then
        ok
    else
        err "front matter missing keys in $f: ${missing_keys[*]}"
    fi
done

# ---------- G2: Spec/Plan front matter (7 keys) ----------
echo
echo "==== G2: spec/plan front matter (7 keys) ===="

SPEC_FILES=("docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md")
PLAN_FILES=("docs/superpowers/plans/2026-04-27-robotics-course-sp1-plan.md")
SPEC_KEYS=(type id title date status sub_project related_plan)
PLAN_KEYS=(type id title date status sub_project related_spec)

check_special_fm() {
    local f="$1"; shift
    local keys=("$@")
    [[ -f "$f" ]] || return
    fm=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$f")
    for k in "${keys[@]}"; do
        if ! echo "$fm" | grep -qE "^${k}:"; then
            err "$f: missing key '$k'"
            return
        fi
    done
    ok
}

for f in "${SPEC_FILES[@]}"; do check_special_fm "$f" "${SPEC_KEYS[@]}"; done
for f in "${PLAN_FILES[@]}"; do check_special_fm "$f" "${PLAN_KEYS[@]}"; done

# ---------- G4: Sandbox content patterns ----------
echo
echo "==== G4: Sandbox reference content patterns ===="

check_pattern() {
    local f="$1"; local pattern="$2"; local label="$3"
    if [[ ! -f "$f" ]]; then
        warn "missing for content check (covered by G1): $f"
        return
    fi
    if grep -qE "$pattern" "$f"; then
        ok
    else
        err "$f: pattern not found ($label)"
    fi
}

check_min_size() {
    local f="$1"; local min_bytes="$2"
    if [[ ! -f "$f" ]]; then
        warn "missing for size check (covered by G1): $f"
        return
    fi
    local size; size=$(wc -c < "$f")
    if [[ "$size" -ge "$min_bytes" ]]; then
        ok
    else
        err "$f: too small ($size bytes, need ≥$min_bytes)"
    fi
}

check_pattern "sandbox_reference/week1/lab1/bag_info.txt" "Duration:|Topic information:" "Duration|Topic"
check_pattern "sandbox_reference/week1/lab1/rosbag_metadata.yaml" "topics_with_message_count:" "rosbag2 metadata key"
check_min_size "sandbox_reference/week1/lab1/terminal_5min.log" 1024
check_pattern "sandbox_reference/week1/lab2/frame_inventory.md" '```mermaid' "mermaid fence"
check_pattern "sandbox_reference/week1/lab2/frame_inventory.md" "base_link" "base_link"
check_pattern "sandbox_reference/week1/lab2/frame_inventory.md" "camera_link" "camera_link"
check_pattern "sandbox_reference/week1/lab2/frame_inventory.md" "tool0" "tool0"
check_pattern "sandbox_reference/week1/lab0/codex_connection_check.md" "workspace" "workspace"
check_pattern "sandbox_reference/week1/lab0/codex_connection_check.md" "connector" "connector"

# Skill baseline 8 categories
if [[ -f "sandbox_reference/week1/skill_baseline_sheet_example.md" ]]; then
    cats=("ROS2 CLI" "TF/URDF" "MoveIt2" "Calibration" "Simulation" "Logging" "Safety" "Git/Codex")
    miss=()
    for c in "${cats[@]}"; do
        if ! grep -qF "$c" "sandbox_reference/week1/skill_baseline_sheet_example.md"; then
            miss+=("$c")
        fi
    done
    if [[ ${#miss[@]} -eq 0 ]]; then
        ok
    else
        err "skill_baseline_sheet_example.md missing categories: ${miss[*]}"
    fi
fi

check_pattern "sandbox_reference/week1/sandbox_setup_log_example.md" "repo:" "repo: key"
check_pattern "sandbox_reference/week1/sandbox_setup_log_example.md" "first branch:" "first branch: key"

# ---------- G5a: Local link resolution ----------
echo
echo "==== G5a: Local link resolution ===="

# Find Markdown links pointing to local relative paths.
local_link_failures=0
while IFS= read -r mdfile; do
    # Extract links like [text](relative/path) — exclude http(s):// and #anchor-only
    while IFS= read -r link; do
        # Strip optional fragment
        target="${link%%#*}"
        # Skip if empty after fragment strip (anchor-only) or absolute URL
        [[ -z "$target" ]] && continue
        [[ "$target" =~ ^https?:// ]] && continue
        [[ "$target" =~ ^mailto: ]] && continue
        [[ "$target" =~ ^#  ]] && continue
        # Resolve relative to mdfile's directory
        dir="$(dirname "$mdfile")"
        resolved="$dir/$target"
        # Normalize via realpath if possible (handle ../)
        if command -v realpath >/dev/null 2>&1; then
            abs=$(realpath -m "$resolved")
        else
            abs="$resolved"
        fi
        if [[ ! -e "$abs" ]]; then
            err "broken local link in $mdfile -> $target"
            local_link_failures=$((local_link_failures+1))
        fi
    done < <(sed 's/`[^`]*`//g' "$mdfile" | grep -oE '\]\([^)]+\)' | sed 's/^](//;s/)$//')
done < <(find . -name "*.md" -not -path "./.git/*" -not -path "./build/*" -not -path "./install/*" -not -path "./docs/superpowers/*")

[[ $local_link_failures -eq 0 ]] && ok

# ---------- bash -n on all *.sh ----------
echo
echo "==== bash -n syntax check on tools/*.sh and course/00_setup/*.sh ===="

while IFS= read -r sh; do
    if output=$(bash -n "$sh" 2>&1); then
        ok
    else
        err "syntax error: $sh"
        if [[ -n "$output" ]]; then
            printf "         %s\n" "$output"
        fi
    fi
done < <(find tools course/00_setup -name "*.sh" -not -path "./.git/*" 2>/dev/null)

# ---------- Summary ----------
echo
echo "============================================================"
echo "  PASS: $PASSED   FAIL: $ERR   WARN: $WARN"
echo "============================================================"

if [[ $ERR -gt 0 ]]; then
    echo "Result: FAIL — $ERR check(s) failed"
    exit 1
else
    echo "Result: PASS"
    exit 0
fi
