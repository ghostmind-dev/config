# Claude Code Feature

**Registry:** `ghcr.io/ghostmind-dev/features/ai`

Installs Claude Code and MCP Proxy with configuration binding support.

## 📦 What's Included

This feature installs:

- **Claude Code**: Anthropic's official CLI for Claude AI assistance
- **MCP Proxy**: Model Context Protocol proxy tool (installed via uv)

## 🔧 Configuration

The feature automatically:
- Installs Claude Code via npm
- Installs MCP Proxy via uv (if available)
- Binds your local `.claude` configuration directory to the container
- Sets up the `CLAUDE_CONFIG_DIR` environment variable

## 📖 Usage

To use this feature, add it to your `.devcontainer/devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/ai:1": {}
  }
}
```

## 🗂️ Configuration Binding

The feature mounts your local `.claude` directory from `${localEnv:RUN_PROJECT}/.creds/.claude` to `/home/vscode/.claude` in the container, allowing you to persist your Claude Code configuration across container rebuilds.

## ⚙️ Options

- `INIT_INSTALL_AI_TOOLS`: Set to `"true"` (default) to install the tools, or `"false"` to skip installation.
