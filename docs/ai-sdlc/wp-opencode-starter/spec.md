# Spec: WP OpenCode Starter

## Overview

A minimal, reproducible WordPress development environment with Docker, PHP/JS quality tooling, pre-commit hooks, GitHub Actions CI, OpenCode skills, and WPVibe MCP integration.

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