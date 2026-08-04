#!/usr/bin/env bash
# work-on-linear — one-line installer.
#
#   curl -fsSL https://raw.githubusercontent.com/DanverImbue/work-on-linear/main/install.sh | bash
#
# Downloads the work-on-linear Agent Skill into your Claude skills directory.
# Override the destination with CLAUDE_SKILLS_DIR, or the source with WORK_ON_LINEAR_RAW.
set -euo pipefail

RAW="${WORK_ON_LINEAR_RAW:-https://raw.githubusercontent.com/DanverImbue/work-on-linear/main}"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}/work-on-linear"

mkdir -p "$DEST"
curl -fsSL "$RAW/skills/work-on-linear/SKILL.md" -o "$DEST/SKILL.md"

echo "Installed work-on-linear skill to $DEST"
