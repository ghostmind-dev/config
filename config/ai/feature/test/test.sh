#!/bin/bash

# Test script for the AI feature - Claude Code and MCP Proxy installation

set -e

echo "🧪 Testing AI Feature - Claude Code and MCP Proxy Installation"
echo ""

# Counter for tests
PASSED=0
FAILED=0

# Test 1: Verify Claude Code installation
echo "📦 Checking Claude Code..."

if command -v claude-code >/dev/null 2>&1 || npm list -g @anthropic-ai/claude-code >/dev/null 2>&1; then
    echo "✓ Claude Code is installed"
    PASSED=$((PASSED + 1))
else
    echo "✗ Claude Code not found"
    FAILED=$((FAILED + 1))
fi

# Test 2: Verify MCP Proxy installation
echo ""
echo "🔧 Checking MCP Proxy..."

if command -v uv >/dev/null 2>&1; then
    if uv tool list | grep -q "mcp-proxy" || command -v mcp-proxy >/dev/null 2>&1; then
        echo "✓ MCP Proxy is installed"
        PASSED=$((PASSED + 1))
    else
        echo "✗ MCP Proxy not found"
        FAILED=$((FAILED + 1))
    fi
else
    echo "⚠️ UV not found, skipping MCP Proxy check"
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
    echo "✅ All AI tools verified successfully!"
    exit 0
else
    echo ""
    echo "⚠️ Some dependencies are missing."
    exit 1
fi
