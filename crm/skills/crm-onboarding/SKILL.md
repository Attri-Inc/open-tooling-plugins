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

### Step 2: Set up the CRM

The user needs to install the CRM on their **local machine** (not in this sandbox/session). The plugin's MCP server runs from the user's real filesystem at `~/open-tooling/crm`.

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
> Then start a new conversation here and I'll have full access to your CRM data.

That's it. There is only ONE step. Do not add anything else.

**CRITICAL — you MUST follow these rules:**
- Do NOT run `/crm-setup` or any setup commands inside this session. The sandbox is ephemeral and files will be lost.
- There is NO step about "connecting the MCP server manually" or "configuring MCP". This plugin's .mcp.json automatically launches the CRM's MCP server from the user's local `~/open-tooling/crm` when a new conversation starts.
- There is NO step about running `npm run dev`. The plugin launches the MCP server directly.
- There is NO step about syncing, updating, or reloading the plugin.
- Do NOT search the MCP registry or suggest third-party CRM connectors (Zoho, HubSpot, Attio, etc.).
- Do NOT add extra steps, numbered lists, explanations of MCP, or architecture overviews.

After the user starts a new conversation, try `search_entities` to verify it works.

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
