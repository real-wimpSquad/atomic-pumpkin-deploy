# MCP Server Addon

**StreamableHTTP transport exposing APE memory/graph ops to Claude Desktop/CLI**

Uses MCP SDK 1.25+ (StreamableHTTPServerTransport, SSE deprecated). OAuth proxy to wrapper for auth.

## Usage

```bash
# Production (pre-built)
make ADDONS="mcp-server"

# Development (build from source)
make dev ADDONS="mcp-server"

# With other addons
make ADDONS="apechat mcp-server ollama"
```

## Config

Set in `.env`:
- `JWT_SECRET` - Auth token (`openssl rand -hex 32`)
- `MCP_PUBLIC_URL` - Public endpoint (default: `https://mcp.wimps.win`)
- `MCP_REQUIRE_AUTH` - `false` for dev (default: `true`)

## Endpoints

- `:8071/mcp` - MCP StreamableHTTP endpoint
- `:8071/health` - Health check
- `:8071/oauth/*` - OAuth proxy → wrapper

## Client Setup

See `/mcp-server/CLIENT_SETUP.md` for Claude Desktop/CLI connection.

## Dependencies

- `engine:8069` - APE core (auto via compose)
- `wrapper:8070` - OAuth/orchestration (base stack)
