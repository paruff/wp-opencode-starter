# Spec: WP OpenCode Starter

## Overview

A minimal, reproducible WordPress development environment with Docker, PHP/JS quality tooling, pre-commit hooks, GitHub Actions CI, OpenCode skills, and WPVibe MCP integration.

## Methodology Context

This spec is the **design draft** in the EGM workflow (`egm-draft` output) and the **design document** for Superpowers' builder check. It implements the **Spec** stage of the AI-Native SDLC Playbook.

- **Superpowers phase**: Post-`brainstorming`, pre-`writing-plans`
- **EGM phase**: `egm-draft` output, input to `egm-review`
- **Playbook stage**: Spec (approved design, ready for planning)
- **Artifact location**: `docs/ai-sdlc/wp-opencode-starter/spec.md`
- **Review command**: `/egm-review docs/ai-sdlc/wp-opencode-starter/spec.md`

## Requirements

### R1: Local Development Environment

- **R1.1** Docker Compose stack with WordPress (latest) and MySQL 8.0
- **R1.2** WordPress accessible at `http://localhost:8080`
- **R1.3** `wp-content/` bind-mounted for live theme/plugin development
- **R1.4** Database persisted in named Docker volume (`db_data`)

### R2: PHP Quality Tooling

- **R2.1** Composer manages PHP dev dependencies
- **R2.2** PHP_CodeSniffer with WordPress Coding Standards (WPCS) ^3.0
- **R2.3** PHPStan ^1.10 with WordPress extension ^1.3 for static analysis
- **R2.4** `composer phpcs` and `composer phpstan` scripts executable

### R3: JavaScript/CSS Quality Tooling

- **R3.1** npm manages JS/CSS dev dependencies
- **R3.2** ESLint configured for modern JS (ES2022+, browser/Node)
- **R3.3** Stylelint configured for modern CSS with WordPress conventions
- **R3.4** `npm run lint:js` and `npm run lint:css` scripts executable

### R4: Pre-Commit Hooks

- **R4.1** pre-commit framework installed and configured
- **R4.2** Runs PHPCS, PHPStan, ESLint, Stylelint on staged files
- **R4.3** `pre-commit install` sets up hooks in `.git/hooks/`

### R5: Continuous Integration

- **R5.1** GitHub Actions workflow runs on push and PR to `master`
- **R5.2** Jobs: PHP lint (PHPCS), PHP static analysis (PHPStan), JS lint, CSS lint
- **R5.3** All jobs must pass for merge
- **R5.4** Uses `actions/setup-php`, `actions/setup-node`, Docker for services

### R6: OpenCode Integration

- **R6.1** Skills directory at `.agents/skills/` auto-discovered by OpenCode
- **R6.2** WPVibe MCP server registered in `opencode.json`
- **R6.3** Skills load without manual configuration

### R7: Documentation

- **R7.1** README with quick start and quality check commands
- **R7.2** Intent, Spec, Plan documents in `docs/ai-sdlc/wp-opencode-starter/`
- **R7.3** `.gitignore` excludes vendor, node_modules, .env, Docker volumes

## Constraints

- **C1** No paid services required (GitHub Actions free tier sufficient)
- **C2** PHP 8.2+ compatible (WordPress 6.5+ requirement)
- **C3** Node 20+ LTS for tooling
- **C4** MySQL 8.0 (not MariaDB) for consistency with WordPress.org
- **C5** All tooling versions pinned in lockfiles (composer.lock, package-lock.json)

## Acceptance Criteria

| ID | Scenario | Expected |
|----|----------|----------|
| AC1 | Fresh clone + `docker-compose up -d` | WordPress at localhost:8080, DB connected |
| AC2 | `composer install` | PHPCS, PHPStan installed, scripts run |
| AC3 | `npm install` | ESLint, Stylelint installed, scripts run |
| AC4 | `pre-commit install` + staged changes | Hooks run, block commit on failures |
| AC5 | Push to GitHub | CI workflow runs, all jobs green |
| AC6 | OpenCode session in repo | Skills discovered, WPVibe MCP connects |
| AC7 | `composer phpcs` on clean code | Exits 0, no errors |
| AC8 | `composer phpstan` on clean code | Exits 0, no errors |

---

## Methodology Traceability

Each requirement maps to methodology artifacts:

| Req | Superpowers Skill | EGM Skill | Playbook Principle |
|-----|-------------------|-----------|-------------------|
| R1-R3 | `using-git-worktrees` (isolated env) | `egm-draft` (design env) | Reproducible environments |
| R2, R3 | `test-driven-development` (lint as tests) | `egm-review` (quality gates) | Evidence over claims |
| R4 | `executing-plans` (hooks as verification) | `egm-lite` (fast feedback) | Small batches |
| R5 | `subagent-driven-development` (CI per task) | `egm-review` (independent check) | Human-in-the-loop |
| R6 | `using-superpowers` (skill bootstrap) | N/A (tooling) | AI-native tooling |
| R7 | `writing-plans` (doc as deliverable) | `egm-draft`/`egm-bootstrap` | Documentation as code |

## Review Focus (EGM Goldfish Review Targets)

When running `/egm-review` on this spec, reviewers should focus on:

1. **Docker service health**: WordPress container must wait for MySQL readiness before accepting connections (R1)
2. **PHPCS/WPCS version compatibility**: WPCS 3.x requires PHPCS 3.7+, verify composer.json constraints (R2.2)
3. **PHPStan WordPress extension**: Must load WordPress stubs correctly for accurate analysis (R2.3)
4. **ESLint/Stylelint config discovery**: Configs must be found from wp-content themes/plugins (R3.2, R3.3)
5. **pre-commit hook execution**: Must run only on staged files, not entire repo, for speed (R4.2)
6. **GitHub Actions service containers**: MySQL service must be healthy before WordPress job steps run (R5.4)
7. **OpenCode skill discovery**: `.agents/skills/` must be in OpenCode's search path (R6.1)
8. **WPVibe MCP server**: Must start and register tools without manual intervention (R6.2)

## Approval Gate

**Superpowers HARD-GATE**: Nothing gets built until this spec is approved.
- Short design (this spec) for a project-level change
- Builder check: dispatch subagent with `builder-check-prompt.md` from brainstorming skill
- Human approval required before `writing-plans` invocation

**EGM Review Gate**: Run `/egm-review` on this spec. Resolve findings via `/egm-resolve`. Approve before planning.