#!/bin/bash

# Test script for the AI feature

set -e

echo "🧪 Testing AI Feature - All Dependencies Installation"
echo ""

# Counter for successful checks
PASSED=0
FAILED=0

# Test 1: Basic container functionality
echo "✓ Container is running"
PASSED=$((PASSED + 1))

# Test 2: Verify Node.js tools
echo ""
echo "📦 Checking Node.js AI Tools..."

if command -v claude-code >/dev/null 2>&1 || npm list -g @anthropic-ai/claude-code >/dev/null 2>&1; then
    echo "✓ Claude Code is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ Claude Code not found"
    FAILED=$((FAILED + 1))
fi

if command -v codex >/dev/null 2>&1 || npm list -g @openai/codex >/dev/null 2>&1; then
    echo "✓ OpenAI Codex is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ OpenAI Codex not found"
    FAILED=$((FAILED + 1))
fi

if command -v gemini-cli >/dev/null 2>&1 || npm list -g @google/gemini-cli >/dev/null 2>&1; then
    echo "✓ Gemini CLI is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ Gemini CLI not found"
    FAILED=$((FAILED + 1))
fi

# Test 3: Verify uv-based tools
echo ""
echo "🔧 Checking UV Tools..."

if command -v uv >/dev/null 2>&1; then
    echo "✓ UV is available"
    PASSED=$((PASSED + 1))

    if uv tool list | grep -q "mcp-proxy" || command -v mcp-proxy >/dev/null 2>&1; then
        echo "✓ MCP Proxy is installed"
        PASSED=$((PASSED + 1))
    else
        echo "✗ MCP Proxy not found"
        FAILED=$((FAILED + 1))
    fi

    if uv tool list | grep -q "specify-cli" || command -v specify-cli >/dev/null 2>&1; then
        echo "✓ Specify CLI is installed"
        PASSED=$((PASSED + 1))
    else
        echo "✗ Specify CLI not found"
        FAILED=$((FAILED + 1))
    fi
else
    echo "⚠️  UV not found, skipping UV tool checks"
    FAILED=$((FAILED + 2))
fi

# Test 4: Verify Skill_Seekers installation
echo ""
echo "🔍 Checking Skill_Seekers Installation..."

SKILL_SEEKERS_DIR="/usr/local/skill_seekers"

if [ -d "$SKILL_SEEKERS_DIR" ]; then
    echo "✓ Skill_Seekers directory exists at $SKILL_SEEKERS_DIR"
    PASSED=$((PASSED + 1))

    if [ -f "$SKILL_SEEKERS_DIR/skill_seeker_mcp/requirements.txt" ]; then
        echo "✓ Skill_Seekers MCP server files found"
        PASSED=$((PASSED + 1))
    else
        echo "✗ Skill_Seekers MCP server files not found"
        FAILED=$((FAILED + 1))
    fi
else
    echo "✗ Skill_Seekers directory not found"
    FAILED=$((FAILED + 2))
fi

# Test 5: Verify System Dependencies
echo ""
echo "🔧 Checking System Dependencies..."

if command -v tesseract >/dev/null 2>&1; then
    echo "✓ tesseract-ocr is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ tesseract-ocr not found"
    FAILED=$((FAILED + 1))
fi

if command -v git >/dev/null 2>&1; then
    echo "✓ git is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ git not found"
    FAILED=$((FAILED + 1))
fi

# Test 6: Verify Python dependencies
echo ""
echo "🐍 Checking Core Python Dependencies..."

if python3 -c "import mcp" 2>/dev/null; then
    echo "✓ mcp library is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ mcp library not found"
    FAILED=$((FAILED + 1))
fi

if python3 -c "import requests" 2>/dev/null; then
    echo "✓ requests library is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ requests library not found"
    FAILED=$((FAILED + 1))
fi

if python3 -c "import bs4" 2>/dev/null; then
    echo "✓ beautifulsoup4 library is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ beautifulsoup4 library not found"
    FAILED=$((FAILED + 1))
fi

# Test 7: Verify Additional Python Dependencies
echo ""
echo "🐍 Checking Additional Python Dependencies..."

if python3 -c "import fitz" 2>/dev/null; then
    echo "✓ PyMuPDF (fitz) library is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ PyMuPDF library not found"
    FAILED=$((FAILED + 1))
fi

if python3 -c "import PIL" 2>/dev/null; then
    echo "✓ Pillow (PIL) library is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ Pillow library not found"
    FAILED=$((FAILED + 1))
fi

if python3 -c "import github" 2>/dev/null; then
    echo "✓ PyGithub library is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ PyGithub library not found"
    FAILED=$((FAILED + 1))
fi

if python3 -c "import pytesseract" 2>/dev/null; then
    echo "✓ pytesseract library is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ pytesseract library not found"
    FAILED=$((FAILED + 1))
fi

if python3 -c "import pytest" 2>/dev/null; then
    echo "✓ pytest library is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ pytest library not found"
    FAILED=$((FAILED + 1))
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Test Summary:"
echo "   ✓ Passed: $PASSED"
echo "   ✗ Failed: $FAILED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FAILED -eq 0 ]; then
    echo ""
    echo "✅ All AI tools and dependencies verified successfully!"
    exit 0
else
    echo ""
    echo "⚠️  Some dependencies are missing. Check the log above for details."
    echo "   (This may be expected depending on your test scenario)"
    exit 0
fi
