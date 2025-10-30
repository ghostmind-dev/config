#!/bin/bash

set -e

echo "🤖 Installing AI Tools..."

# Check if INIT_INSTALL_AI_TOOLS is set to true
if [ "${INIT_INSTALL_AI_TOOLS:-true}" = "true" ]; then
    echo "📦 Installing AI development tools..."

    # Install system dependencies
    echo "📦 Installing system dependencies (tesseract-ocr, git)..."
    if apt-get update && apt-get install -y tesseract-ocr git 2>/dev/null; then
        echo "✅ System dependencies installed successfully"
    else
        echo "⚠️ Failed to install system dependencies (may already be installed)"
    fi

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

    # Install Skill_Seekers
    echo "🔍 Installing Skill_Seekers from https://github.com/yusufkaraaslan/Skill_Seekers.git..."
    SKILL_SEEKERS_DIR="/usr/local/skill_seekers"

    # Remove old installation if it exists
    if [ -d "$SKILL_SEEKERS_DIR" ]; then
        echo "🧹 Removing old Skill_Seekers installation..."
        rm -rf "$SKILL_SEEKERS_DIR"
    fi

    # Clone the repository
    if git clone https://github.com/yusufkaraaslan/Skill_Seekers.git "$SKILL_SEEKERS_DIR" 2>/dev/null; then
        echo "✅ Skill_Seekers cloned successfully to $SKILL_SEEKERS_DIR"

        # Install MCP server dependencies
        if [ -f "$SKILL_SEEKERS_DIR/skill_seeker_mcp/requirements.txt" ]; then
            echo "📦 Installing Skill_Seekers MCP server dependencies..."
            if pip3 install -r "$SKILL_SEEKERS_DIR/skill_seeker_mcp/requirements.txt" 2>/dev/null; then
                echo "✅ MCP server dependencies installed successfully"
            else
                echo "⚠️ Failed to install MCP server dependencies"
            fi
        fi

        # Install additional Python dependencies for full Skill_Seekers functionality
        echo "📦 Installing additional Skill_Seekers dependencies..."
        if pip3 install PyMuPDF Pillow PyGithub pytesseract pytest pytest-cov coverage 2>/dev/null; then
            echo "✅ Additional Python dependencies installed successfully"
            echo "   - PyMuPDF (PDF processing)"
            echo "   - Pillow (image processing)"
            echo "   - PyGithub (GitHub API)"
            echo "   - pytesseract (OCR)"
            echo "   - pytest, pytest-cov, coverage (testing)"
        else
            echo "⚠️ Failed to install some additional dependencies"
        fi
    else
        echo "⚠️ Failed to clone Skill_Seekers repository"
    fi

    echo ""
    echo "🎉 AI tools installation completed!"
else
    echo "ℹ️ Skipping AI tools installation (INIT_INSTALL_AI_TOOLS != 'true')"
fi 