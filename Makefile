.PHONY: help start up stop down clean logs

# Composable Addons System for Atomic Pumpkin Deploy
# Uses pre-built images from ghcr.io
# Usage: make ADDONS="apechat ollama mcp-server code-thumbs"

ADDONS ?=
AVAILABLE_ADDONS := apechat ollama code-thumbs mcp-server

# Build compose file list
define build_compose_files
	$(eval COMPOSE_FILES := -f docker-compose.yml)
	$(foreach addon,$(ADDONS),\
		$(if $(filter $(addon),$(AVAILABLE_ADDONS)),\
			$(eval COMPOSE_FILES += -f addons/$(addon)/docker-compose.$(addon).prod.yml),\
			$(error Unknown addon: $(addon). Available: $(AVAILABLE_ADDONS))\
		)\
	)
endef

.DEFAULT_GOAL := start

help:
	@echo "🎃 Atomic Pumpkin - Production Deployment"
	@echo ""
	@echo "Quick Start:"
	@echo "  make                         - Core stack only"
	@echo "  make ADDONS=\"apechat\"         - Core + APEChat UI"
	@echo "  make ADDONS=\"mcp-server\"      - Core + MCP Server"
	@echo "  make ADDONS=\"apechat mcp-server ollama\" - Full stack"
	@echo ""
	@echo "Available Addons:"
	@echo "  apechat      - Web UI for chat interface"
	@echo "  ollama       - Local LLM server (Llama, Qwen, etc.)"
	@echo "  code-thumbs  - Multi-language formatter/linter"
	@echo "  mcp-server   - SSE transport for Claude Desktop/CLI"
	@echo ""
	@echo "Commands:"
	@echo "  make [start]             - Start services (default)"
	@echo "  make up                  - Alias for start"
	@echo "  make stop                - Stop services (keep data)"
	@echo "  make down                - Stop and remove containers"
	@echo "  make clean               - Stop and remove all data"
	@echo "  make logs                - View logs"
	@echo ""
	@echo "Examples:"
	@echo "  make                                  # Minimal stack"
	@echo "  make ADDONS=\"apechat\"                  # + Web UI"
	@echo "  make ADDONS=\"apechat mcp-server\"       # + Web UI + MCP"
	@echo "  make ADDONS=\"apechat mcp-server ollama\" # Full stack"
	@echo ""

start:
	@$(call build_compose_files)
	@echo "🚀 Starting Atomic Pumpkin (production images)..."
	@echo "   Core: qdrant + engine + postgres + redis + litellm + wrapper"
	@if [ -n "$(ADDONS)" ]; then \
		echo "   Addons: $(ADDONS)"; \
	else \
		echo "   Addons: (none - use ADDONS=\"...\" to add)"; \
	fi
	@echo ""
	@docker-compose $(COMPOSE_FILES) up -d
	@echo ""
	@echo "✓ Services started"
	@echo ""
	@echo "Access points:"
	@echo "  Engine:  http://localhost:8069"
	@echo "  Wrapper: http://localhost:8070"
	@if echo "$(ADDONS)" | grep -q "apechat"; then \
		echo "  APEChat: http://localhost:8072"; \
	fi
	@if echo "$(ADDONS)" | grep -q "mcp-server"; then \
		echo "  MCP:     http://localhost:8071"; \
	fi

up: start

stop:
	@$(call build_compose_files)
	@echo "Stopping services..."
	@docker-compose $(COMPOSE_FILES) stop
	@echo "✓ Stopped (data preserved)"

down:
	@$(call build_compose_files)
	@echo "Stopping and removing containers..."
	@docker-compose $(COMPOSE_FILES) down
	@echo "✓ Containers removed (data preserved)"

clean:
	@echo "⚠️  This will remove ALL containers and data volumes"
	@read -p "Continue? [y/N] " confirm && [ "$$confirm" = "y" ] || exit 1
	@$(call build_compose_files)
	@docker-compose $(COMPOSE_FILES) down -v
	@echo "✓ Cleaned (all data removed)"

logs:
	@$(call build_compose_files)
	@docker-compose $(COMPOSE_FILES) logs -f
