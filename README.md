# Atomic Pumpkin - Quick Deploy

**Collective Memory for AI Agents** - Get running in 5 minutes with pre-built Docker images.

---

## What is Atomic Pumpkin?

Atomic Pumpkin (APE) is a knowledge system that lets AI agents remember and learn across conversations. Instead of starting fresh each time, agents inherit collective wisdom from previous sessions.

**Key Features:**
- 🧠 **Persistent Memory** - Knowledge survives across sessions
- 🔗 **Knowledge Graph** - Concepts connect automatically
- 🎯 **Semantic Search** - Find answers, not just keywords
- 💬 **APEchat UI** - Clean, modern chat interface
- 🔒 **Auth Built-in** - Email magic links + GitHub OAuth

---

## Quick Start

### Prerequisites
- Docker & Docker Compose installed
- LiteLLM API keys (Anthropic, OpenAI, etc.)

### 1. Get the Files
```bash
git clone https://github.com/real-wimpSquad/atomic-pumpkin-deploy.git
cd atomic-pumpkin-deploy
```

### 2. Configure Environment
```bash
# Copy example config
cp .env.example .env

# Edit with your settings
nano .env
```

**Required settings in `.env`:**
```bash
# LiteLLM Proxy URL (where your LLM models are)
LITELLM_PROXY_URL=http://your-litellm-server:4000

# Admin email (for first login)
ADMIN_EMAILS=your@email.com

# Email settings (for magic link auth)
RESEND_API_KEY=re_...  # Get free key from resend.com
FROM_EMAIL=noreply@yourdomain.com
BASE_URL=https://yourdomain.com  # Or http://localhost:3080 for local
```

### 3. Start Services
```bash
# Pull latest images
docker-compose pull

# Start everything
docker-compose up -d
```

### 4. Access APEchat
Open http://localhost:3080 and sign in with your admin email.

---

## Architecture

```
┌─────────────┐
│  APEchat    │  ← SvelteKit 5 UI (Port 3080)
│  (Frontend) │
└──────┬──────┘
       │
┌──────▼──────┐
│   Wrapper   │  ← API Gateway + Auth (Port 8070)
└──────┬──────┘
       │
┌──────▼──────┐
│  APE Core   │  ← VDB + Knowledge Graph (Port 8069)
└──────┬──────┘
       │
┌──────▼──────┐
│   Qdrant    │  ← Vector Database (Port 6333)
└─────────────┘
```

---

## Common Tasks

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f wrapper
docker-compose logs -f ape-core
docker-compose logs -f apechat
```

### Update to Latest
```bash
docker-compose pull
docker-compose up -d
```

### Backup Data
```bash
# Backup Qdrant data
docker-compose exec qdrant tar czf /qdrant/backup.tar.gz /qdrant/storage

# Backup Postgres database
docker-compose exec -T wrapper pg_dump -U ape ape > backup_$(date +%Y%m%d).sql
```

### Restore Backup
```bash
# Restore Postgres
cat backup_20260131.sql | docker-compose exec -T wrapper psql -U ape ape
```

### Stop Services
```bash
# Stop but keep data
docker-compose stop

# Stop and remove containers (data persists in volumes)
docker-compose down

# Stop and remove EVERYTHING (including data)
docker-compose down -v  # ⚠️ Careful - deletes all data!
```

---

## Configuration

### Email Setup (Magic Links)

APE uses [Resend](https://resend.com) for email (free tier: 100 emails/day):

1. Sign up at https://resend.com
2. Get API key
3. Add to `.env`:
   ```bash
   RESEND_API_KEY=re_...
   FROM_EMAIL=noreply@yourdomain.com
   ```

### GitHub OAuth (Optional)

1. Create OAuth app at https://github.com/settings/developers
2. Set callback URL: `http://localhost:3080/login/oauth-complete` (or your domain)
3. Add to `.env`:
   ```bash
   GITHUB_CLIENT_ID=...
   GITHUB_CLIENT_SECRET=...
   ```

### LiteLLM Integration

APE connects to your LiteLLM proxy for models. In `.env`:
```bash
LITELLM_PROXY_URL=http://your-litellm:4000
```

Models auto-seed on startup from LiteLLM's `/v1/models` endpoint.

---

## Ports

| Service | Port | Purpose |
|---------|------|---------|
| APEchat | 3080 | Web UI |
| Wrapper | 8070 | API Gateway |
| APE Core | 8069 | VDB Engine |
| Qdrant | 6333 | Vector DB |

To change ports, edit `docker-compose.yml`.

---

## Troubleshooting

### "Can't connect to LiteLLM"
- Check `LITELLM_PROXY_URL` in `.env`
- Ensure LiteLLM is running and accessible
- Test: `curl http://your-litellm:4000/v1/models`

### "No models showing up"
- Check wrapper logs: `docker-compose logs wrapper`
- Verify LiteLLM has models configured
- Manually add models in Settings page

### "Magic link not sending"
- Check `RESEND_API_KEY` is valid
- Set `EMAIL_ENVIRONMENT=development` in `.env` to print links to console
- Check wrapper logs for email errors

### "Can't login as admin"
- Ensure `ADMIN_EMAILS` in `.env` matches your login email exactly
- Restart services after changing `.env`

---

## Support

- **Issues**: https://github.com/real-wimpSquad/atomic-pumpkin-deploy/issues
- **Docs**: https://github.com/real-wimpSquad/atomic-pumpkin

---

## What's Included

This deployment uses pre-built Docker images:

1. **ape-core** - Core VDB + knowledge graph engine
2. **wrapper** - API gateway, auth, LiteLLM proxy
3. **apechat** - SvelteKit 5 chat interface
4. **qdrant** - Vector database
5. **postgres** - User/settings database
6. **redis** - Session management

All images auto-built and published to GitHub Container Registry.

---

## License

Apache License 2.0

---

**Remember**: Every question you ask teaches the system. Every answer it gives becomes part of the collective memory. You're not just using a tool—you're contributing to an evolving intelligence.
