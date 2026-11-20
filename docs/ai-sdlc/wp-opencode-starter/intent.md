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