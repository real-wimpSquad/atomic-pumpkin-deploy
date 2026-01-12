# Easy Start - Pre-built Images

**For complete beginners who just want to use Atomic Pumpkin + LibreChat**

## What You Need

1. Docker Desktop installed ([Download here](https://www.docker.com/products/docker-desktop/))
2. An API key from Anthropic or OpenAI ([Anthropic](https://console.anthropic.com/) | [OpenAI](https://platform.openai.com/api-keys))
3. 5 minutes

## Step-by-Step

### 1. Download the Files

You need a few config files. Easiest way:

```bash
# Download the repo
git clone https://github.com/real-wimpSquad/atomic-pumpkin.git
cd atomic-pumpkin
```

**Don't have git?** Just download the ZIP from GitHub and extract it.

### 2. Create Your API Keys File

Copy and paste this into your terminal (inside the `atomic-pumpkin` folder):

```bash
cat > .env << 'EOF'
# Replace these with your actual API keys
ANTHROPIC_API_KEY=sk-ant-your-key-here
OPENAI_API_KEY=sk-your-key-here

# These are auto-generated - leave as is
JWT_SECRET=$(openssl rand -hex 32)
JWT_REFRESH_SECRET=$(openssl rand -hex 32)
EOF
```

**Or create it manually:**
1. Create a file named `.env` (yes, that dot is important)
2. Add your keys:
   ```
   ANTHROPIC_API_KEY=sk-ant-your-key-here
   OPENAI_API_KEY=sk-your-key-here
   JWT_SECRET=any-random-string-32-characters-long
   JWT_REFRESH_SECRET=another-random-string-32-chars
   ```

### 3. Start Everything

Copy and paste this command:

```bash
docker-compose -f docker-compose.prod.yml -f addons/librechat/docker-compose.librechat.prod.yml up -d
```

**What's happening:**
- Docker downloads the pre-built images (~1-2 GB)
- Starts 4 services: Qdrant (database), API, OpenAI Wrapper, LibreChat, MongoDB
- Takes about 2-3 minutes first time

### 4. Open LibreChat

Go to: **http://localhost:3080**

1. Click "Sign Up"
2. Create an account (stored locally)
3. Start chatting!

The AI has access to the Atomic Pumpkin VDB automatically. Try asking it to remember things!

---

## That's It! 🎃

You're now running:
- **LibreChat** (the chat UI) at http://localhost:3080
- **Atomic Pumpkin API** at http://localhost:8069

---

## Common Questions

### "The command didn't work"

Make sure:
1. Docker Desktop is running (check the whale icon in your system tray)
2. You're in the `atomic-pumpkin` folder (the one with `docker-compose.prod.yml`)
3. You created the `.env` file

### "localhost:3080 doesn't load"

Wait 30 seconds - services take time to start. Check if they're ready:

```bash
docker ps
```

You should see 5 containers running.

### "I want to stop it"

```bash
docker-compose -f docker-compose.prod.yml -f addons/librechat/docker-compose.librechat.prod.yml down
```

### "I want to start fresh"

```bash
# Stop everything
docker-compose -f docker-compose.prod.yml -f addons/librechat/docker-compose.librechat.prod.yml down -v

# Delete data
rm -rf qdrant/ project_vdb/ addons/librechat/mongodb_data/ addons/librechat/logs/

# Start again
docker-compose -f docker-compose.prod.yml -f addons/librechat/docker-compose.librechat.prod.yml up -d
```

### "I only have one API key"

That's fine! Just put the same key in both fields, or leave one blank. The system will use whichever provider you configure in LibreChat.

### "I want JUST the API, no chat UI"

Use this simpler command:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

Then access the API directly at http://localhost:8069

---

## Next Steps

Once you're comfortable:
- Read [QUICKSTART.md](QUICKSTART.md) for more commands
- Read [README.md](README.md) to understand how it works
- Read [addons/librechat/README.md](addons/librechat/README.md) to customize LibreChat

---

## Troubleshooting

### Port Already in Use

If you get an error about ports 8069, 8070, or 3080 being in use, something else is using those ports.

**Option 1: Stop the other service**

**Option 2: Change the ports** - Edit `docker-compose.prod.yml` and change:
```yaml
ports:
  - "9069:8069"  # Changed from 8069:8069
```

### Still Stuck?

1. Check logs: `docker-compose -f docker-compose.prod.yml logs`
2. Open an issue: https://github.com/real-wimpSquad/atomic-pumpkin/issues
3. Make sure Docker has at least 4GB RAM allocated (Docker Desktop → Settings → Resources)

---

**Happy chatting! The AI can now remember things across conversations using the Atomic Pumpkin VDB.** 🎃
