#!/usr/bin/env bash
set -euo pipefail

# Post-create script for WP OpenCode Starter devcontainer
# Runs once after container creation

echo "🚀 Setting up WP OpenCode Starter devcontainer..."

# 1. Install OpenCode
echo "📦 Installing OpenCode..."
if ! command -v opencode &> /dev/null; then
  curl -fsSL https://opencode.ai/install.sh | bash
  export PATH="$HOME/.opencode/bin:$PATH"
  echo 'export PATH="$HOME/.opencode/bin:$PATH"' >> ~/.bashrc
else
  echo "OpenCode already installed"
fi

# 2. Install Superpowers for OpenCode
echo "🦸 Installing Superpowers..."
if [ ! -d "$HOME/.config/opencode/plugin/superpowers" ]; then
  mkdir -p "$HOME/.config/opencode/plugin"
  cd "$HOME/.config/opencode/plugin"
  git clone https://github.com/obra/superpowers.git superpowers 2>/dev/null || echo "Superpowers already cloned"
  cd superpowers
  # Follow OpenCode install instructions
  if [ -f ".opencode/INSTALL.md" ]; then
    echo "Superpowers installed, will be loaded on next session"
  fi
else
  echo "Superpowers already installed"
fi

# 3. Install project dependencies
echo "📦 Installing Composer dependencies..."
cd /workspace
if [ -f "composer.json" ]; then
  composer install --no-interaction --prefer-dist
else
  echo "No composer.json found"
fi

echo "📦 Installing npm dependencies..."
if [ -f "package.json" ]; then
  npm ci
else
  echo "No package.json found"
fi

# 4. Install pre-commit
echo "🔧 Installing pre-commit..."
if command -v pre-commit &> /dev/null; then
  pre-commit install
  pre-commit install --hook-type commit-msg
else
  echo "Installing pre-commit via pip..."
  pip install --user pre-commit
  export PATH="$HOME/.local/bin:$PATH"
  pre-commit install
  pre-commit install --hook-type commit-msg
fi

# 5. Verify OpenCode skills discovery
echo "🎯 Verifying OpenCode skills..."
if command -v opencode &> /dev/null; then
  # Skills are auto-discovered from .agents/skills/
  if [ -d "/workspace/.agents/skills" ]; then
    echo "✅ Skills directory found at .agents/skills/"
    ls -la /workspace/.agents/skills/
  else
    echo "⚠️  Skills directory not found"
  fi
fi

# 6. Verify WPVibe MCP configuration
echo "🔌 Verifying WPVibe MCP..."
if [ -f "/workspace/opencode.json" ]; then
  echo "✅ opencode.json found"
  cat /workspace/opencode.json | jq . 2>/dev/null || cat /workspace/opencode.json
else
  echo "⚠️  opencode.json not found"
fi

# 7. Start Docker services
echo "🐳 Starting Docker services..."
cd /workspace
docker-compose up -d || echo "Docker Compose will start on post-start"

echo "✅ Post-create setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'docker-compose up -d' to start WordPress + MySQL"
echo "  2. Open http://localhost:8080 for WordPress"
echo "  3. Run 'opencode' to start OpenCode session"
echo "  4. Skills and WPVibe MCP will be auto-discovered"