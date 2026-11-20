#!/usr/bin/env bash
set -euo pipefail

# Post-start script for WP OpenCode Starter devcontainer
# Runs every time the container starts

echo "🔄 Starting WP OpenCode Starter services..."

# 1. Ensure Docker is running
if ! docker info &> /dev/null; then
  echo "⚠️  Docker not running, starting Docker-in-Docker..."
  # Docker-in-Docker should be started by the feature
  sleep 2
fi

# 2. Start Docker Compose services
cd /workspace
if [ -f "docker-compose.yml" ]; then
  echo "🐳 Starting WordPress + MySQL..."
  docker-compose up -d
  
  # Wait for services to be healthy
  echo "⏳ Waiting for services to be ready..."
  for i in {1..30}; do
    if docker-compose ps | grep -q "healthy\|Up"; then
      break
    fi
    sleep 1
  done
  
  # Verify WordPress is responding
  for i in {1..15}; do
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200\|302"; then
      echo "✅ WordPress is ready at http://localhost:8080"
      break
    fi
    sleep 2
  done
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
fi

# 4. Git status
echo "📋 Git status:"
cd /workspace
git status --short

echo ""
echo "✅ Devcontainer ready!"
echo "   WordPress: http://localhost:8080"
echo "   OpenCode:  Run 'opencode' to start"
echo "   Skills:    Auto-discovered from .agents/skills/"
echo "   MCP:       WPVibe configured in opencode.json"