# WP OpenCode Starter

A beginner-friendly WordPress repository with local Docker, pre-commit quality gates, GitHub Actions CI, OpenCode skills, and WPVibe MCP.

## Quick start

See composer.json and package.json for tooling. Run:

- `docker-compose up -d`
- `composer install`
- `npm install`
- `pre-commit install`
- `open http://localhost:8080`

## Quality checks

- `composer phpcs`
- `composer phpstan`
- `npm run lint:js`
- `npm run lint:css`

## OpenCode

Skills live in `.agents/skills/` and are auto-discovered. The WPVibe MCP server is registered in `opencode.json`.
