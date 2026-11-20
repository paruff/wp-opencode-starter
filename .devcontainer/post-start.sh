#!/usr/bin/env bash
set -euo pipefail

# Post-start script for WP OpenCode Starter devcontainer
# Runs every time the container starts

echo "🔄 Starting WP OpenCode Starter services..."

# Find workspace - devcontainer mounts at /workspaces/<repo-name>
WORKSPACE="${WORKSPACE:-/workspaces/wp-opencode-starter}"
if [ ! -d "$WORKSPACE" ]; then
  WORKSPACE="/workspace"
fi
if [ ! -d "$WORKSPACE" ]; then
  WORKSPACE="$(pwd)"
fi

cd "$WORKSPACE"
echo "📁 Working in: $WORKSPACE"

# 1. Ensure Docker is running (optional - for Docker Compose)
if ! docker info &> /dev/null; then
  echo "⚠️  Docker not available in container (use host Docker for docker-compose)"
fi

# 2. Start Docker Compose services (if docker-compose.yml exists and Docker works)
if [ -f "docker-compose.yml" ] && docker info &> /dev/null; then
  echo "🐳 Starting WordPress + MySQL..."
  docker-compose up -d
  
  # Wait for services to be healthy
  echo "⏳ Waiting for services to be ready..."
  for i in {1..30}; do
    if docker-compose ps 2>/dev/null | grep -q "healthy\|Up"; then
      break
    fi
    sleep 1
  done
  
  # Verify WordPress is responding
  for i in {1..15}; do
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 2>/dev/null | grep -q "200\|302"; then
      echo "✅ WordPress is ready at http://localhost:8080"
      break
    fi
    sleep 2
  done
elif [ -f "docker-compose.yml" ]; then
  echo "📝 docker-compose.yml found. Run 'docker-compose up -d' on host to start services."
else
  echo "⚠️  No docker-compose.yml found"
fi

# 3. Verify tooling
echo "🔍 Verifying development tooling..."

# PHP/Composer
if command -v php &> /dev/null; then
  echo "  PHP: $(php -v | head -1)"
fi
if command -v composer &> /dev/null; then
  echo "  Composer: $(composer --version | head -1)"
fi

# Node/npm
if command -v node &> /dev/null; then
  echo "  Node: $(node --version)"
fi
if command -v npm &> /dev/null; then
  echo "  npm: $(npm --version)"
fi

# Linting tools
if [ -f "vendor/bin/phpcs" ]; then
  echo "  PHPCS: Available"
fi
if [ -f "vendor/bin/phpstan" ]; then
  echo "  PHPStan: Available"
fi
if [ -f "node_modules/.bin/eslint" ]; then
  echo "  ESLint: Available"
fi
if [ -f "node_modules/.bin/stylelint" ]; then
  echo "  Stylelint: Available"
fi

# Pre-commit
if command -v pre-commit &> /dev/null; then
  echo "  pre-commit: $(pre-commit --version)"
fi

# OpenCode
if command -v opencode &> /dev/null; then
  echo "  OpenCode: $(opencode --version 2>/dev/null || echo 'installed')"
else
  echo "  OpenCode: Not installed (run post-create or install manually)"
fi

# 4. Git status
if [ -d ".git" ]; then
  echo "📋 Git status:"
  git status --short
else
  echo "📋 Not a git repository"
fi

echo ""
echo "✅ Devcontainer ready!"
echo "   WordPress: http://localhost:8080 (run docker-compose up -d on host)"
echo "   OpenCode:  Run 'opencode' to start"
echo "   Skills:    Auto-discovered from .agents/skills/"
echo "   MCP:       WPVibe configured in opencode.json"