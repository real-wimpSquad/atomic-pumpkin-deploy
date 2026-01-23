# MCP Server Addon - v6.0

**StreamableHTTP transport exposing APE v6.0 memory/graph ops to Claude Desktop/CLI**

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

## Tools (v6.0 API - 18 Comprehensive Tools)

| MCP Tool | API Endpoint | Description |
|----------|--------------|-------------|
| **Semantic (6)** | | |
| `store` | `POST /add` | Store→cognitive_processing→dedup+rels+compression |
| `retrieve` | `POST /semantic/search` | Semantic_search→vector_similarity→top_k_results |
| `traverse` | `POST /semantic/topo` | Semantic_entry→graph_expansion→subgraph |
| `get` | `POST /semantic/get` | UUID→direct_retrieval |
| `search_by_tags` | `POST /semantic/tags` | Tag_search→match_any_or_all |
| `search_filtered` | `POST /semantic/search/filtered` | Semantic+filters (fitness+date+model) |
| **Graph (5)** | | |
| `connect` | `POST /graph/connect` | Graph_edge→bidirectional→subject→relation→object |
| `graph_properties` | `POST /graph/properties` | Entity→properties (what props does entity have) |
| `graph_entities` | `POST /graph/entities` | Property→entities (reverse lookup) |
| `graph_intersect` | `POST /graph/intersect` | Compositional_AND (entities with both properties) |
| `nearby` | `POST /graph/nearby` | Nucleoid_orbit→explicit_rels+semantic+gaps |
| **Quality (2)** | | |
| `vote` | `POST /quality/vote` | Vote:±1→δfitness (semantic tier assessment) |
| `amend` | `POST /quality/amend` | Amend_own_entry→session_restricted→earned_scars |
| **Batch (2)** | | |
| `batch_store` | `POST /batch/add` | Batch_store→multiple_entries→efficiency |
| `batch_connect` | `POST /batch/graph/connect` | Batch_connect→multiple_edges→relationship_graphs |
| **Discovery (1)** | | |
| `recent` | `POST /discover/recent` | Chronological→most_recent_entries |
| **Session (2)** | | |
| `session_history` | `POST /session/history` | Session_log→self_reflection |
| `session_similar` | `POST /session/similar` | Similar_start→different_paths→pattern_discovery |

## Endpoints

- `:8071/mcp` - MCP StreamableHTTP endpoint
- `:8071/health` - Health check
- `:8071/oauth/*` - OAuth proxy → wrapper

## Client Setup

See `/mcp-server/CLIENT_SETUP.md` for Claude Desktop/CLI connection.

## Dependencies

- `engine:8069` - APE core (auto via compose)
- `wrapper:8070` - OAuth/orchestration (base stack)
