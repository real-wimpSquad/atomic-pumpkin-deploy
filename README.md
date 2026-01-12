# Atomic Pumpkin - Deployment

**Pre-built Docker images for easy deployment**

This repository contains everything you need to deploy Atomic Pumpkin using pre-built images from GitHub Container Registry. The source code is maintained in a separate private repository.

## Quick Start

### Prerequisites
- Docker & Docker Compose installed
- API key from [Anthropic](https://console.anthropic.com/) or [OpenAI](https://platform.openai.com/)

### 1. Get the Files

```bash
git clone https://github.com/real-wimpSquad/atomic-pumpkin-deploy.git
cd atomic-pumpkin-deploy
```

### 2. Configure

```bash
# Copy the example env file
cp .env.example .env

# Edit .env and add your API keys
nano .env  # or use any text editor
```

### 3. Run

**Core API only:**
```bash
docker-compose up -d
```

**With LibreChat UI:**
```bash
docker-compose -f docker-compose.yml -f addons/librechat/docker-compose.librechat.yml up -d
```

### 4. Access

- **API**: http://localhost:8069
- **LibreChat** (if enabled): http://localhost:3080

## Documentation

- **[EASY_START.md](EASY_START.md)** - Step-by-step guide for beginners
- **[API Usage](docs/API.md)** - Using the REST API
- **[Configuration](docs/CONFIGURATION.md)** - Advanced configuration options

## What's Inside

This deployment uses three Docker images:

1. **Qdrant** (`qdrant/qdrant:latest`) - Vector database
2. **Atomic Pumpkin API** (`ghcr.io/real-wimpsquad/atomic-pumpkin/api:latest`) - Core VDB + graph engine
3. **OpenAI Wrapper** (`ghcr.io/real-wimpsquad/atomic-pumpkin/openai-wrapper:latest`) - Optional, for LibreChat integration

All images are automatically built from the private source repository and published to GitHub Container Registry.

## Updating

```bash
# Pull latest images
docker-compose pull

# Restart with new images
docker-compose up -d
```

## Support

- **Issues**: [GitHub Issues](https://github.com/real-wimpSquad/atomic-pumpkin-deploy/issues)
- **Discussions**: [GitHub Discussions](https://github.com/real-wimpSquad/atomic-pumpkin-deploy/discussions)
- **Documentation**: https://docs.atomic-pumpkin.dev (coming soon)

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

---

**Note**: This is the deployment repository. Source code is maintained separately.
