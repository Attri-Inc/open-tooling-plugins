---
name: crm-setup
description: "Set up Open Tooling CRM locally — clones the repo, installs dependencies, seeds data, and wires up the MCP server"
argument-hint: "[install-path]"
disable-model-invocation: true
allowed-tools: Bash(bash *), Bash(chmod *)
---

# /crm-setup

Set up Open Tooling CRM on the user's machine so all CRM skills and commands work automatically.

## What I Need From You
- Where to install (default: `~/open-tooling`). Pass a path as an argument to override.
- Whether to seed sample data (default: yes)

## Step 1: Run the Setup Script

Run the bundled setup script. If the user passed an install path as `$ARGUMENTS`, use it via `OPEN_TOOLING_DIR`:

```bash
OPEN_TOOLING_DIR="$ARGUMENTS" bash ${CLAUDE_SKILL_DIR}/scripts/setup.sh
```

If no argument was passed, just run it with defaults:

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/setup.sh
```

If the user wants to skip sample data, prepend `SKIP_SEED=1`.

The script handles everything:
- Checks prerequisites (git, node >= 18, npm)
- Clones `Attri-Inc/open-tooling` (or pulls latest if it exists)
- Runs `npm install`
- Copies `.env.example` to `.env`
- Seeds sample data (optional)
- Writes `~/.open-tooling/state.json` (state marker for other skills)
- Creates `~/.open-tooling/start-mcp.sh` (MCP launcher that the plugin's `.mcp.json` points to)

## Step 2: Connect the MCP Server

The setup script auto-configures Claude Desktop's MCP config (on macOS). Tell the user:

> Setup complete! **Restart Claude Desktop** to activate the CRM MCP server, then start a new conversation. All commands and skills will be live.

If the script reported that it couldn't find Claude Desktop config (e.g., on Linux), tell the user to manually add the MCP server to their Claude Desktop config:

```json
{
  "mcpServers": {
    "open-tooling-crm": {
      "command": "npx",
      "args": ["tsx", "<CRM_PATH>/src/mcp.ts"],
      "env": {
        "CRM_DB_PATH": "<CRM_PATH>/data/crm.db"
      }
    }
  }
}
```

Replace `<CRM_PATH>` with the absolute path to the CRM directory (e.g., `/Users/foo/open-tooling/crm`).

## Step 3: Verify

After the user restarts Claude Desktop and opens a new conversation, verify by calling the `search_entities` MCP tool with no filters. If it responds, setup is fully complete.

If it fails, troubleshoot:
- Check that the CRM directory exists and has `node_modules/`
- Check that `claude_desktop_config.json` has the `open-tooling-crm` entry with correct absolute paths
- Try running the MCP server manually: `cd ~/open-tooling/crm && npx tsx ./src/mcp.ts`

## Step 4: Show Next Steps

Once verified, tell the user:

- **`/crm-status`** — quick pipeline overview
- **`/crm-ingest`** — ingest emails, transcripts, or documents
- **`/crm-brief`** — get a full briefing on any contact, company, or deal
- Just ask naturally — skills like entity management and memory layer activate automatically

If the database was seeded, suggest they try `/crm-status` to see the sample data.

## Error Handling
- If `git` is missing: tell user to install Git
- If `node` is missing or < 18: tell user to install/upgrade Node.js
- If the repo already exists: pull latest instead of re-cloning
- If `npm install` fails: show the error, suggest checking Node version or network
- If seed fails: that's OK, continue — it's optional
