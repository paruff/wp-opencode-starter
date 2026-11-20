# WP OpenCode Starter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish a complete, documented WordPress development starter environment with Docker, quality tooling, CI, and OpenCode integration.

**Architecture:** Docker Compose for local services (WordPress + MySQL), Composer for PHP tooling, npm for JS/CSS tooling, pre-commit for local hooks, GitHub Actions for CI, OpenCode skills/MCP for AI-assisted development.

**Tech Stack:** Docker, WordPress 6.5+, MySQL 8.0, PHP 8.2+, Composer, PHPCS/WPCS, PHPStan, Node 20+, npm, ESLint, Stylelint, pre-commit, GitHub Actions, OpenCode, WPVibe MCP.

**Spec:** `docs/ai-sdlc/wp-opencode-starter/spec.md`

## Global Constraints

- PHP 8.2+ (WordPress 6.5+ minimum)
- Node 20+ LTS
- MySQL 8.0 (not MariaDB)
- All dependencies pinned in lockfiles
- No paid services required
- GitHub Actions free tier compatible

## Review Focus

1. **Docker service health**: WordPress container must wait for MySQL readiness before accepting connections
2. **PHPCS/WPCS version compatibility**: WPCS 3.x requires PHPCS 3.7+, verify composer.json constraints
3. **PHPStan WordPress extension**: Must load WordPress stubs correctly for accurate analysis
4. **ESLint/Stylelint config discovery**: Configs must be found from wp-content themes/plugins
5. **pre-commit hook execution**: Must run only on staged files, not entire repo, for speed
6. **GitHub Actions service containers**: MySQL service must be healthy before WordPress job steps run
7. **OpenCode skill discovery**: `.agents/skills/` must be in OpenCode's search path
8. **WPVibe MCP server**: Must start and register tools without manual intervention

---

### Task 1: Verify Docker Compose Stack

**Files:**
- Verify: `docker-compose.yml`
- Test: Manual verification

**Interfaces:**
- Consumes: (none - first task)
- Produces: Working WordPress + MySQL at localhost:8080

- [ ] **Step 1: Verify docker-compose.yml exists and is valid**

```bash
docker-compose config
```
Expected: Valid YAML, services `db` and `wordpress` defined

- [ ] **Step 2: Start stack and verify WordPress responds**

```bash
docker-compose up -d
sleep 15
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080
```
Expected: HTTP 200 or 302 (WordPress install/redirect)

- [ ] **Step 3: Verify database connection**

```bash
docker-compose exec -T db mysql -uwordpress -pwordpress -e "SELECT 1"
```
Expected: Returns `1`

- [ ] **Step 4: Verify wp-content bind mount**

```bash
ls -la wp-content/
docker-compose exec -T wordpress ls -la /var/www/html/wp-content/
```
Expected: Local `wp-content/` contents visible in container

- [ ] **Step 5: Commit**

```bash
git add docker-compose.yml
git commit -m "chore: verify docker-compose stack"
```

---

### Task 2: Verify Composer PHP Tooling

**Files:**
- Verify: `composer.json`, `composer.lock`
- Test: Run PHPCS and PHPStan

**Interfaces:**
- Consumes: Working Docker stack (Task 1)
- Produces: Passing `composer phpcs` and `composer phpstan`

- [ ] **Step 1: Verify composer.json has required dependencies**

```bash
cat composer.json
```
Expected: `wp-coding-standards/wpcs`, `phpstan/phpstan`, `szepeviktor/phpstan-wordpress`, `dealerdirect/phpcodesniffer-composer-installer` in `require-dev`

- [ ] **Step 2: Install dependencies**

```bash
composer install
```
Expected: `vendor/` created, lockfile updated

- [ ] **Step 3: Run PHPCS on sample code**

```bash
composer phpcs -- --standard=WordPress wp-content/
```
Expected: Exits 0 (or shows only pre-existing violations in wp-content)

- [ ] **Step 4: Run PHPStan**

```bash
composer phpstan
```
Expected: Exits 0 (or shows only pre-existing errors)

- [ ] **Step 5: Commit**

```bash
git add composer.json composer.lock
git commit -m "chore: verify composer PHP tooling"
```

---

### Task 3: Verify npm JS/CSS Tooling

**Files:**
- Verify: `package.json`, `package-lock.json`, `.eslintrc.json`, `.stylelintrc.json`
- Test: Run ESLint and Stylelint

**Interfaces:**
- Consumes: (independent)
- Produces: Passing `npm run lint:js` and `npm run lint:css`

- [ ] **Step 1: Verify package.json has required dependencies**

```bash
cat package.json
```
Expected: `eslint`, `stylelint`, and relevant configs/plugins in `devDependencies`

- [ ] **Step 2: Install dependencies**

```bash
npm install
```
Expected: `node_modules/` created, lockfile updated

- [ ] **Step 3: Run ESLint**

```bash
npm run lint:js -- wp-content/
```
Expected: Exits 0 (or shows only pre-existing violations)

- [ ] **Step 4: Run Stylelint**

```bash
npm run lint:css -- wp-content/
```
Expected: Exits 0 (or shows only pre-existing violations)

- [ ] **Step 5: Commit**

```bash
git add package.json package-lock.json .eslintrc.json .stylelintrc.json
git commit -m "chore: verify npm JS/CSS tooling"
```

---

### Task 4: Verify Pre-Commit Hooks

**Files:**
- Verify: `.pre-commit-config.yaml`
- Test: Install and run hooks

**Interfaces:**
- Consumes: Composer and npm tooling (Tasks 2, 3)
- Produces: Working pre-commit hooks blocking bad commits

- [ ] **Step 1: Verify .pre-commit-config.yaml exists**

```bash
cat .pre-commit-config.yaml
```
Expected: Repos for phpcs, phpstan, eslint, stylelint with appropriate hooks

- [ ] **Step 2: Install pre-commit**

```bash
pre-commit install
```
Expected: Hooks installed in `.git/hooks/pre-commit`

- [ ] **Step 3: Test hooks on staged file**

```bash
echo "<?php echo 'test';" > /tmp/test.php
git add /tmp/test.php
pre-commit run --files /tmp/test.php
```
Expected: PHPCS/PHPStan run on the file

- [ ] **Step 4: Commit**

```bash
git add .pre-commit-config.yaml
git commit -m "chore: verify pre-commit hooks"
```

---

### Task 5: Verify GitHub Actions CI

**Files:**
- Verify: `.github/workflows/ci.yml` (or similar)
- Test: Push to trigger workflow

**Interfaces:**
- Consumes: All tooling (Tasks 1-4)
- Produces: Green CI run on push/PR

- [ ] **Step 1: Verify CI workflow exists**

```bash
ls -la .github/workflows/
cat .github/workflows/*.yml
```
Expected: Workflow with jobs for phpcs, phpstan, eslint, stylelint

- [ ] **Step 2: Verify workflow syntax**

```bash
# Uses GitHub's workflow validation
gh workflow view <workflow-name> 2>/dev/null || echo "Check manually"
```
Expected: Valid YAML, required jobs present

- [ ] **Step 3: Trigger CI run**

```bash
git push origin master
```
Expected: GitHub Actions workflow runs, all jobs pass

- [ ] **Step 4: Commit**

```bash
git add .github/workflows/
git commit -m "chore: verify GitHub Actions CI"
```

---

### Task 6: Verify OpenCode Integration

**Files:**
- Verify: `opencode.json`, `.agents/skills/`
- Test: OpenCode session discovers skills and MCP

**Interfaces:**
- Consumes: (independent)
- Produces: OpenCode loads skills, WPVibe MCP connects

- [ ] **Step 1: Verify opencode.json registers WPVibe MCP**

```bash
cat opencode.json
```
Expected: `mcp.servers.wpvibe` configured with command/args

- [ ] **Step 2: Verify skills directory structure**

```bash
ls -la .agents/skills/
```
Expected: Skill directories with `skill.json` or `skill.yaml`

- [ ] **Step 3: Test OpenCode skill discovery**

```bash
# In an OpenCode session in this repo:
# > /skill list
```
Expected: Skills from `.agents/skills/` listed

- [ ] **Step 4: Test WPVibe MCP connection**

```bash
# In an OpenCode session:
# > /mcp list
```
Expected: `wpvibe` server shows connected with tools

- [ ] **Step 5: Commit**

```bash
git add opencode.json .agents/skills/
git commit -m "chore: verify OpenCode integration"
```

---

### Task 7: Verify Documentation Completeness

**Files:**
- Verify: `README.md`, `docs/ai-sdlc/wp-opencode-starter/intent.md`, `spec.md`, `plan.md`
- Test: All documents present and accurate

**Interfaces:**
- Consumes: All previous tasks
- Produces: Complete documentation set

- [ ] **Step 1: Verify README has quick start and quality commands**

```bash
cat README.md
```
Expected: Docker, Composer, npm, pre-commit, OpenCode sections

- [ ] **Step 2: Verify intent.md exists and matches spec**

```bash
cat docs/ai-sdlc/wp-opencode-starter/intent.md
```
Expected: Purpose, why now, audience, success criteria, non-goals, anti-goals

- [ ] **Step 3: Verify spec.md exists and covers all requirements**

```bash
cat docs/ai-sdlc/wp-opencode-starter/spec.md
```
Expected: R1-R7, C1-C5, acceptance criteria table

- [ ] **Step 4: Verify plan.md exists and references spec**

```bash
cat docs/ai-sdlc/wp-opencode-starter/plan.md
```
Expected: Header with spec reference, tasks 1-7 with steps

- [ ] **Step 5: Commit**

```bash
git add README.md docs/ai-sdlc/wp-opencode-starter/
git commit -m "docs: add intent, spec, plan for WP OpenCode Starter"
```

---

### Task 8: Final Verification and Tag

**Files:**
- (none new)
- Test: Full clean-room verification

**Interfaces:**
- Consumes: All tasks 1-7
- Produces: Confirmed working starter environment

- [ ] **Step 1: Clean verification in fresh directory**

```bash
cd /tmp
git clone https://github.com/paruff/wp-opencode-starter.git wp-test
cd wp-test
docker-compose up -d
composer install
npm install
pre-commit install
```

- [ ] **Step 2: Run all quality checks**

```bash
composer phpcs
composer phpstan
npm run lint:js
npm run lint:css
```

- [ ] **Step 3: Verify WordPress accessible**

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080
```

- [ ] **Step 4: Push and verify CI**

```bash
git push origin master
# Check GitHub Actions
```

- [ ] **Step 5: Tag release**

```bash
git tag -a v1.0.0 -m "WP OpenCode Starter v1.0.0"
git push origin v1.0.0
```

- [ ] **Step 6: Cleanup**

```bash
cd /tmp && rm -rf wp-test
docker-compose -f /Users/philruff/projects/github/paruff/wp-opencode-starter/docker-compose.yml down -v
```