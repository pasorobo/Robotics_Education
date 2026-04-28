# bridge_stub.py — Lab 6b Scene Packet Bridge Stub (instructor hand-authored)
#
# Does not start simulator.
# Does not run real ros_gz_bridge.
# Does not auto-judge Affordance.
#
# Usage:
#   python3 bridge_stub.py <scene_packet.json>
#
# Reads JSON, logs each of the 4 input fields, exits 0.
# Requires: Python 3.10+, stdlib only (json, sys, logging).
# Prohibited content: see Lab 6b README + CHECKLIST 禁止リスト for the
# 9 categories (forbidden by literal G4 must-not patterns).

import json
import logging
import sys


def setup_logger() -> logging.Logger:
    logger = logging.getLogger("bridge_stub")
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(logging.Formatter("[%(levelname)s] %(name)s: %(message)s"))
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    return logger


def run(json_path: str) -> int:
    logger = setup_logger()
    logger.info("bridge_stub start  path=%s", json_path)

    with open(json_path, encoding="utf-8") as fh:
        packet = json.load(fh)

    for field in ("scene_packet", "robot_state", "candidate_set", "action_intent"):
        value = packet.get(field)
        logger.info("recv field=%s  type=%s  value=%s", field, type(value).__name__, value)

    logger.info("bridge_stub finish  exit=0")
    return 0


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 bridge_stub.py <scene_packet.json>", file=sys.stderr)
        sys.exit(1)
    sys.exit(run(sys.argv[1]))
