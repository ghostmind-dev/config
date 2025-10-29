#!/bin/bash

set -e

echo "🤖 Installing AI Tools..."

# Check if INIT_INSTALL_AI_TOOLS is set to true
if [ "${INIT_INSTALL_AI_TOOLS:-true}" = "true" ]; then
    echo "📦 Installing AI development tools..."

    # Install Claude Code
    if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
        echo "✅ Claude Code installed successfully"
    else
        echo "⚠️ Failed to install Claude Code"
    fi

    # Install OpenAI Codex
    if npm install -g @openai/codex 2>/dev/null; then
        echo "✅ OpenAI Codex installed successfully"
    else
        echo "⚠️ Failed to install OpenAI Codex"
    fi

    # Install Gemini CLI
    if npm install -g @google/gemini-cli 2>/dev/null; then
        echo "✅ Gemini CLI installed successfully"
    else
        echo "⚠️ Failed to install Gemini CLI"
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

    # Install specify-cli using uv
    echo "🔧 Installing Specify CLI from git+https://github.com/github/spec-kit.git..."
    if command -v uv &> /dev/null; then
        if uv tool install specify-cli --from git+https://github.com/github/spec-kit.git; then
            echo "✅ Specify CLI installed successfully"
            echo "📍 Location: $(uv tool list | grep specify-cli || echo 'Not found in uv tool list')"
            if command -v specify-cli &> /dev/null; then
                echo "📍 Binary path: $(which specify-cli)"
            fi
        else
            echo "⚠️ Failed to install Specify CLI"
        fi
    else
        echo "⚠️ uv not found, skipping Specify CLI installation"
    fi
    echo "⏸️  Waiting 5 seconds to review Specify CLI installation output..."
    sleep 5

    echo ""
    echo "🎉 AI tools installation completed!"
else
    echo "ℹ️ Skipping AI tools installation (INIT_INSTALL_AI_TOOLS != 'true')"
fi 