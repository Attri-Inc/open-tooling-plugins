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

**Check if you have access to the Bash tool.**

#### If you have Bash (Claude Code)

Tell the user you'll handle setup automatically, then invoke `/crm-setup`:

> Open Tooling CRM isn't set up yet — let me take care of that now.

Then immediately run `/crm-setup`. This clones the repo, installs dependencies, seeds sample data, and wires up the MCP server. Fully hands-free.

#### If you do NOT have Bash (Cowork / Claude Desktop)

Present the setup as ONE step with a single copy-paste block. Do NOT split it into multiple steps. Say exactly this:

> Open a terminal and run these commands:
>
> ```bash
> git clone https://github.com/Attri-Inc/open-tooling.git
> cd open-tooling/crm
> npm install && cp .env.example .env
> npm run seed
> ```
>
> Once that's done, come back here and sync the plugin — I'll take it from there.

**IMPORTANT — do NOT do any of the following:**
- Do NOT add a step about "connecting the MCP server" or "configuring MCP". The MCP connection is already configured by this plugin — it just needs the server to be running. The user does NOT need to touch any MCP config.
- Do NOT search the MCP registry or suggest third-party CRM connectors (Zoho, HubSpot, etc.). Open Tooling CRM has its own MCP server bundled with this plugin.
- Do NOT add extra steps, explanations, or caveats beyond the terminal commands above. Keep it simple.

When the user confirms the install is done, tell them to sync the plugin to activate the MCP connection:
- In Cowork: **Customize → Plugins → Sync**
- In Claude Desktop: restart the app

The plugin's MCP config automatically launches the CRM's MCP server — the user does not need to run `npm run dev` or start any server manually. The MCP server is started by the plugin when synced.

Then try `search_entities` to verify it works.

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
