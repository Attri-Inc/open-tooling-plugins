---
name: crm-onboarding
description: "Triggered when the user first asks about Open Tooling CRM, wants to get started, or asks Claude to use the CRM. Detects the environment and guides setup accordingly."
---

# CRM Onboarding

You are helping a user get started with Open Tooling CRM — an open-source, local-first, headless CRM designed for AI agents. CRM is the first module in the Open Tooling family.

## When to Use This Skill
- User says "how do I get started with the CRM" or similar
- User asks Claude to "use Open Tooling CRM" or "start using the CRM"
- User just installed this plugin and wants to try it out
- User asks about setup, configuration, or first steps

## Onboarding Flow

### Step 1: Check if CRM is already connected

Try calling the `search_entities` MCP tool with no filters. This is the fastest way to know if the CRM is set up and connected.

- **If it works** → skip to "CRM is Connected" below.
- **If the tool is not available or fails** → the CRM needs to be set up. Continue to Step 2.

### Step 2: Install the CRM locally

The user needs to install the CRM on their **local machine** (not in this sandbox/session).

**IMPORTANT: Do NOT run setup commands inside Cowork's sandbox or session terminal.** Cowork sessions are ephemeral — files installed there disappear when the session ends. The user must run these commands in their own local terminal (e.g., iTerm, Terminal.app, Windows Terminal).

Say exactly this:

> Open your **local terminal** (not this chat) and run:
>
> ```bash
> git clone https://github.com/Attri-Inc/open-tooling.git ~/open-tooling
> cd ~/open-tooling/crm
> npm install && cp .env.example .env
> npm run seed
> ```
>
> Let me know when that's done and I'll configure the MCP connection for you.

Do NOT add anything else. Wait for the user to confirm.

### Step 3: Configure the MCP connection

Once the user confirms the install is done, say:

> I can add the CRM MCP server to your Claude Desktop config so it's available in every Cowork session. Want me to do that?

If the user agrees, update the config file.

**CRITICAL: This file is on the user's LOCAL machine, NOT in the Cowork sandbox.** The path is:

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

You MUST access this file on the **host filesystem** — request access to the `~/Library/Application Support/Claude/` folder if prompted. Do NOT look for it inside the sandbox working directory. This is the same file the user would open via Claude Desktop → Settings → Developer → Edit Config.

Steps:
1. Request access to the folder and read the file at the full local path above
2. Parse the existing JSON (it may have `preferences` and other keys — preserve them all)
3. If there's no `mcpServers` key, create it. Add the `open-tooling-crm` entry:
   ```json
   {
     "open-tooling-crm": {
       "command": "npx",
       "args": ["tsx", "<HOME>/open-tooling/crm/src/mcp.ts"],
       "env": {
         "CRM_DB_PATH": "<HOME>/open-tooling/crm/data/crm.db"
       }
     }
   }
   ```
   Replace `<HOME>` with the user's actual home directory path (e.g., `/Users/username`). Determine this from the config file path or the CRM install path.
4. Write the updated JSON back. **Do not overwrite other keys** — only add/update `mcpServers["open-tooling-crm"]`.
5. Say:

> Done! I've added the CRM MCP server to your Claude Desktop config. Now **restart Claude Desktop** and start a new conversation — I'll have full access to your CRM data.

If the user declines, show the manual config instructions as a fallback.

**CRITICAL — you MUST follow these rules:**
- Do NOT run `/crm-setup` or any setup commands inside this session. The sandbox is ephemeral and files will be lost.
- There is NO step about running `npm run dev`. The MCP server is launched directly by Claude Desktop.
- There is NO step about syncing, updating, or reloading the plugin.
- Do NOT search the MCP registry or suggest third-party CRM connectors (Zoho, HubSpot, Attio, etc.).
- Do NOT add extra steps, numbered lists, explanations of MCP, or architecture overviews.

---

## CRM is Connected

Once `search_entities` works, walk the user through what they can do:

1. **Search contacts**: Use `search_entities` with `type: "contact"`
2. **View the deal pipeline**: Use `search_entities` with `type: "deal"`
3. **Explore relationships**: Use `traverse_graph` on a contact to see their company, deals, interactions
4. **Read a brief**: Use `list_briefs` then `get_brief` to see a summary backed by evidence
5. **Drill into evidence**: From a brief, follow observation IDs to `get_observation`, then `get_artifact` for the raw source

If the database was seeded, jump straight in and show the user their data.

### Key Concepts (explain if asked)
- **Entities**: Typed records (contact, company, deal, interaction, task, agent) with JSON properties
- **Relationships**: Directed edges (EMPLOYED_AT, ASSOCIATED_WITH, etc.)
- **Memory Layer**: Artifacts → Observations → Briefs → Conflicts (evidence chain)
- **Event Ledger**: Append-only audit trail for every mutation
- **Progressive Retrieval**: Start with briefs, drill to observations, then artifacts

### Key Principles
- Always use the MCP tools (not REST API) when working through Claude
- The memory layer is the differentiator — every claim has receipts
- Progressive retrieval keeps context lean while maintaining full traceability
