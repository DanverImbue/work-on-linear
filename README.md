# work-on-linear Agent Skill

An Agent Skill that helps AI coding agents **work a Linear ticket end-to-end** — fetch and understand
it, gate on its workflow state, claim it, set up a properly named branch, implement it following the
repo's own conventions, and stop for local review without opening a PR.

## Overview

This repository provides an Agent Skill for Claude Code and other compatible AI agents. It teaches the
agent to pick up a Linear ticket and carry it to completion in the current workspace, with the workflow
**gated** at every risky step:

- **Unclear tickets get clarified first** — the agent stops and asks a blocking question rather than
  guessing at scope or acceptance criteria.
- **Tickets in the wrong state get confirmed first** — backlog/triage, someone else's in-progress work,
  or already-completed tickets are surfaced before anything is touched.
- **Claiming is explicit** — the ticket is assigned to the user and moved to In Progress only after the
  state gate passes.
- **Finished work stops for local review** — the agent runs the repo's verification and reports a
  summary. It never pushes or opens a PR without explicit permission.

Linear access goes through the [`latchkey`](https://github.com/imbue-ai/latchkey) skill, using
`latchkey curl` against the Linear GraphQL API. It is not project-specific.

## Installation

### One-line install (curl | bash)

```bash
curl -fsSL https://raw.githubusercontent.com/DanverImbue/work-on-linear/main/install.sh | bash
```

This downloads the skill into `~/.claude/skills/work-on-linear/`. Override the destination with
`CLAUDE_SKILLS_DIR`.

### With [just](https://just.systems)

```bash
just install
```

### With a skill manager ([agent-skills-manager](https://github.com/umutbozdag/agent-skills-manager) / `asm` / `sm`)

The skill follows the standard `skills/<name>/SKILL.md` layout, so skill managers discover it straight
from the repo:

```bash
# asm (github.com/luongnv89/asm)
asm install github:DanverImbue/work-on-linear -p claude

# sm (pypi.org/project/agent-skill-manager)
sm install https://github.com/DanverImbue/work-on-linear -a claude-code
```

For the agent-skills-manager dashboard, open **Install → From Git** and paste
`https://github.com/DanverImbue/work-on-linear`, then pick `work-on-linear`.

### As a Claude Code plugin

The repo doubles as its own single-plugin marketplace. From inside Claude Code:

```
/plugin marketplace add DanverImbue/work-on-linear
/plugin install work-on-linear@work-on-linear-marketplace
```

Then reload (`/reload-plugins`) and invoke the skill with `/work-on-linear:work-on-linear`.

### Manually

Copy the skill directory into your skills directory — either global:

```bash
cp -r skills/work-on-linear/ ~/.claude/skills/work-on-linear/
```

or into a single project:

```bash
cp -r skills/work-on-linear/ /path/to/your/project/.claude/skills/work-on-linear/
```

## Usage

Once installed, the skill activates when you hand the agent a Linear issue identifier (e.g. `ENG-123`),
a Linear issue URL, or ask it to "work on" / "pick up" / "start" a ticket:

```
/work-on-linear ENG-123
/work-on-linear https://linear.app/<team>/issue/ENG-123/some-title
```

If invoked without an identifier, the agent asks which ticket to work on.

## Preconditions

- Linear access goes through the `latchkey` skill. Verify credentials first:

  ```bash
  latchkey services info linear   # credentialStatus should be "valid"
  ```

  If not valid, follow the latchkey skill to set them up before continuing.

## Skill Contents

```
skills/
└── work-on-linear/
    └── SKILL.md    # The gated workflow: fetch, state gate, claim, branch, implement, stop for review
```

## Key ideas

1. **Gate before acting** — unclear scope, wrong ticket state, or a foreign in-progress branch stop the
   agent for a blocking question instead of a guess.
2. **Claim explicitly** — assign to the user and move to In Progress in one mutation, only after the gate
   passes.
3. **State type, not display name** — decisions key off Linear's `state.type`
   (`triage`/`backlog`/`unstarted`/`started`/`completed`/`canceled`), which is stable across teams.
4. **Traceable branches** — branches are named `<user>/<IDENTIFIER>-<short-kebab-description>`, preferring
   the user's existing convention.
5. **Stop for local review** — verify with the repo's own test/lint/build, report a summary, and never
   push or open a PR without explicit permission.

## Contributing

Contributions are welcome. Keep the skill workflow-gated and non-project-specific, and preserve the
"stop for local review — never a PR" contract.

## License

MIT
