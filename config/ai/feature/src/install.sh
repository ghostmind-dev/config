#!/bin/bash

set -e

echo "🤖 Installing AI Tools..."

# Check if INIT_INSTALL_AI_TOOLS is set to true
if [ "${INIT_INSTALL_AI_TOOLS:-true}" = "true" ]; then
    echo "📦 Installing AI development tools..."

    # Install Claude Code
    if su  ${_REMOTE_USER} -c "curl -fsSL https://claude.ai/install.sh | bash" 2>/dev/null; then
        echo "✅ Claude Code installed successfully"
    else
        echo "⚠️ Failed to install Claude Code"
    fi

    # Install mcp-proxy using uv
    if command -v uv &> /dev/null; then
        if uv tool install mcp-proxy 2>/dev/null; then
            echo "✅ MCP Proxy installed successfully"
        else
            echo "⚠️ Failed to install MCP Proxy"
        fi
    else
        echo "⚠️ uv not found, skipping MCP Proxy installation"
    fi

    echo ""
    echo "🎉 AI tools installation completed!"
else
    echo "ℹ️ Skipping AI tools installation (INIT_INSTALL_AI_TOOLS != 'true')"
fi
