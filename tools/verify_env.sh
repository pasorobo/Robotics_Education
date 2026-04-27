#!/usr/bin/env bash
# tools/verify_env.sh
# Verify that the SP1 development environment is in place.
# Spec G3 (§5.1).
# Exit codes:
#   0 - all required checks PASS
#   1 - at least one required check FAILED

set -uo pipefail

PASS=0
FAIL=0
WARN=0

print_check() {
    local label="$1"
    local status="$2"
    local detail="${3:-}"
    printf "  [%-4s] %-30s %s\n" "$status" "$label" "$detail"
}

check_required() {
    local label="$1"; shift
    if "$@" >/dev/null 2>&1; then
        print_check "$label" "PASS"
        PASS=$((PASS+1))
    else
        print_check "$label" "FAIL"
        FAIL=$((FAIL+1))
    fi
}

check_either() {
    local label="$1"; shift
    local cmd_a="$1"; shift
    local cmd_b="$1"; shift
    if command -v "$cmd_a" >/dev/null 2>&1; then
        print_check "$label" "PASS" "($cmd_a)"
        PASS=$((PASS+1))
    elif command -v "$cmd_b" >/dev/null 2>&1; then
        print_check "$label" "PASS" "($cmd_b)"
        PASS=$((PASS+1))
    else
        print_check "$label" "FAIL" "neither $cmd_a nor $cmd_b found"
        FAIL=$((FAIL+1))
    fi
}

echo "==== Robotics Education Course — Environment Verification ===="
echo

echo "[OS]"
if command -v lsb_release >/dev/null 2>&1; then
    OS_DESC=$(lsb_release -d -s 2>/dev/null || echo "unknown")
    if echo "$OS_DESC" | grep -qE "Ubuntu 22\.04"; then
        print_check "Ubuntu 22.04" "PASS" "$OS_DESC"
        PASS=$((PASS+1))
    else
        print_check "Ubuntu 22.04" "WARN" "$OS_DESC (not Ubuntu 22.04 — Course assumes 22.04)"
        WARN=$((WARN+1))
    fi
else
    print_check "Ubuntu 22.04" "WARN" "lsb_release not found"
    WARN=$((WARN+1))
fi

echo "[ROS 2]"
check_required "ros2 CLI"      command -v ros2
check_required "ros2 Humble"   bash -c 'ros2 --help 2>&1 | grep -qi humble || [ -d /opt/ros/humble ]'

echo "[Gazebo (Fortress)]"
check_either "gazebo CLI" gz ign

echo "[MoveIt 2]"
if dpkg -l 2>/dev/null | grep -q "ros-humble-moveit "; then
    print_check "ros-humble-moveit pkg" "PASS"
    PASS=$((PASS+1))
else
    print_check "ros-humble-moveit pkg" "WARN" "(SP1 only needs demo install; SP2 requires full)"
    WARN=$((WARN+1))
fi

echo "[Tooling]"
check_required "git"      command -v git
check_required "python3"  command -v python3
check_required "bash"     command -v bash

echo
echo "==== Summary: PASS=$PASS  FAIL=$FAIL  WARN=$WARN ===="

if [[ $FAIL -gt 0 ]]; then
    echo "Result: FAIL — required checks failed"
    exit 1
else
    echo "Result: PASS"
    exit 0
fi
