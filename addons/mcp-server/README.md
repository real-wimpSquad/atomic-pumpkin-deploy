# MCP Server Addon

SSE transport server for remote access to Atomic Pumpkin Engine via Claude Desktop or Claude Code CLI.

## What It Does

Exposes the APE tools (memory storage, retrieval, graph operations) over Server-Sent Events (SSE) for MCP (Model Context Protocol) clients.

## Usage

**Production (pre-built image):**
```bash
make ADDONS="mcp-server"
```

**Development (build from source):**
```bash
make dev ADDONS="mcp-server"
```

**With other addons:**
```bash
make ADDONS="apechat mcp-server ollama"
```

## Configuration

Environment variables (set in `.env`):
- `JWT_SECRET` - Required for auth (generate with `openssl rand -hex 32`)
- `BASE_URL` - Your public URL (default: https://ape.wimps.win:8070)
- `MCP_REQUIRE_AUTH` - Set to `false` for dev/local testing (default: true in prod)

## Ports

- `8071` - SSE endpoint for MCP clients

## Client Setup

See `/mcp-server/CLIENT_SETUP.md` in the main repo for instructions on connecting Claude Desktop/CLI.

## Dependencies

- Core engine service (automatic via docker-compose)
- Wrapper service for orchestration (in base stack)
