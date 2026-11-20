# Intent: WP OpenCode Starter

## Purpose

Provide a beginner-friendly, batteries-included WordPress development environment that works out of the box with OpenCode, enabling developers to start building WordPress sites immediately without wrestling with tooling configuration.

## Why Now

- WordPress development often requires piecing together Docker, PHP tooling, JS/CSS linting, pre-commit hooks, CI/CD, and AI-assisted coding tools separately
- New developers face a steep learning curve assembling a modern WordPress stack
- OpenCode's skill system and MCP integration can supercharge WordPress development but lacks a starter template
- The wp-opencode-starter repo exists but lacks formal intent/spec/plan documentation for onboarding and governance

## Target Audience

- WordPress developers new to modern tooling (Docker, Composer, npm, pre-commit, CI)
- Developers adopting OpenCode for WordPress work
- Teams wanting a standardized, reproducible WordPress dev environment

## Success Criteria

1. **Zero-config start**: `docker-compose up -d && composer install && npm install && pre-commit install` yields a working WordPress site at localhost:8080
2. **Quality gates enforced**: PHPCS (WPCS), PHPStan, ESLint, Stylelint run on every commit via pre-commit and in CI
3. **OpenCode ready**: Skills auto-discovered from `.agents/skills/`, WPVibe MCP server registered and functional
4. **CI passes**: GitHub Actions runs all quality checks on push/PR
5. **Documented**: Intent, spec, and plan exist for governance and onboarding

## Non-Goals

- Production deployment configuration (staging/prod infra, secrets management)
- Specific theme/plugin scaffolding (starter provides the environment, not the product)
- Database migration tooling beyond what WordPress core provides
- Multi-site or headless WordPress configurations

## Anti-Goals

- Bloating the starter with opinionated theme choices (Underscores, Sage, etc.)
- Requiring paid services or non-free tiers
- Locking into a specific hosting provider's workflow

---

## Methodology Alignment

This project follows a unified documentation suite that integrates three complementary AI-native development methodologies:

### 1. Superpowers (Skill-Based Workflow)
**Source**: [github.com/obra/superpowers](https://github.com/obra/superpowers) | [OpenCode Install](https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.opencode/INSTALL.md)

Superpowers provides the **execution layer** — a complete skill-based workflow that triggers automatically:
- `using-superpowers` → `brainstorming` → `writing-plans` → `using-git-worktrees` → `subagent-driven-development` / `executing-plans` → `test-driven-development` → `requesting-code-review` → `finishing-a-development-branch`

**In this repo**: Skills live in `.agents/skills/` and are auto-discovered by OpenCode. The `using-superpowers` bootstrap is injected via OpenCode's native session hooks.

### 2. Elephant-Goldfish Model (EGM) — Design & Review
**Source**: [egm.dev](https://egm.dev) | [github.com/google/elephant-goldfish-model](https://github.com/google/elephant-goldfish-model)

EGM provides the **design and review layer** — a structured draft-and-review workflow:
- **Elephant** (context holder): `egm-brainstorm` → `egm-draft` — explores the problem and drafts the specification
- **Goldfish** (fresh reviewers): `egm-review` — independent review of the draft against source material
- **Human**: Resolves trade-offs, approves the design

**In this repo**: The `docs/ai-sdlc/wp-opencode-starter/` directory serves as the EGM artifact directory. Intent = concept brief, Spec = design draft, Plan = implementation plan. Run `egm-review` on `spec.md` before implementation.

### 3. AI-Native SDLC Playbook
**Source**: [claude.com/resources/articles/the-ai-native-sdlc-playbook](https://claude.com/resources/articles/the-ai-native-sdlc-playbook)

The playbook provides the **strategic framing** — principles for AI-native software development:
- Intent → Spec → Plan → Implement → Verify → Ship
- Human-in-the-loop for architectural decisions
- Evidence-based verification over claims
- Small batches, frequent integration

---

## Document Map

| Document | Superpowers Phase | EGM Phase | Playbook Stage |
|----------|-------------------|-----------|----------------|
| `intent.md` | `brainstorming` output | Concept brief (`egm-brainstorm`) | Intent |
| `spec.md` | Design doc (builder check) | Design draft (`egm-draft`) | Spec |
| `plan.md` | `writing-plans` output | Implementation plan (post-review) | Plan |

## Workflow Integration

```
┌─────────────────────────────────────────────────────────────────┐
│                    AI-Native SDLC Playbook                      │
│  Intent → Spec → Plan → Implement → Verify → Ship              │
└─────────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   Superpowers   │ │      EGM        │ │  This Project   │
│  (Execution)    │ │  (Design/Review)│ │  (Artifacts)    │
├─────────────────┤ ├─────────────────┤ ├─────────────────┤
│ brainstorming   │ │ egm-brainstorm  │ │ intent.md       │
│ writing-plans   │ │ egm-draft       │ │ spec.md         │
│ executing-plans │ │ egm-review      │ │ plan.md         │
│ test-driven-dev │ │ egm-resolve     │ │ (implementation)│
│ code-review     │ │ egm-drift-report│ │ (verification)  │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

## Usage

### For New Features (Full Cycle)
```bash
# 1. Superpowers: Brainstorm (auto-triggers on "Let's build...")
# 2. EGM: Draft spec from brief
/egm-draft

# 3. EGM: Review spec with fresh eyes
/egm-review docs/ai-sdlc/wp-opencode-starter/spec.md

# 4. Superpowers: Write plan from approved spec
# (writing-plans skill auto-invokes after spec approval)

# 5. Superpowers: Execute plan
# (subagent-driven-development or executing-plans)

# 6. EGM: Check for drift after implementation
/egm-drift-report docs/ai-sdlc/wp-opencode-starter/
```

### For Small Changes (Lite Cycle)
```bash
# Superpowers: Lite workflow (brainstorming → plan → execute)
# EGM: egm-lite for fast-track iterations
```

### For Codebase Documentation
```bash
# EGM: Bootstrap docs from existing code
/egm-bootstrap
```