---
name: crm-onboarding
description: "Triggered when the user first asks about Open Tooling CRM, wants to get started, or asks Claude to use the CRM. Checks if setup has been done and guides accordingly."
---

# CRM Onboarding

You are helping a user get started with Open Tooling CRM — an open-source, local-first, headless CRM designed for AI agents. CRM is the first module in the Open Tooling family, a growing suite of AI-native SaaS tools.

## Setup Status
!`cat ~/.open-tooling/state.json 2>/dev/null || echo '{"setup_required": true}'`

## When to Use This Skill
- User says "how do I get started with the CRM" or similar
- User asks Claude to "use Open Tooling CRM" or "start using the CRM"
- User just installed this plugin and wants to try it out
- User asks about setup, configuration, or first steps

## Onboarding Flow

### If `setup_required` is true (state file missing)

The CRM hasn't been set up yet. Tell the user you'll get it set up now, then **immediately invoke `/crm-setup`** — don't wait for the user to run it themselves. Say something like:

> Open Tooling CRM isn't set up yet — let me take care of that now.

Then invoke `/crm-setup`. This gives the user a fully hands-free experience.

### If setup is complete (state file has `crm_path`)

#### Step 1: Verify Connection
Use the `search_entities` tool with no filters to check if the MCP server is responding.

- If it fails: the server might not be running. Tell the user to start it: `cd <crm_path> && npm run dev`, or check that they ran `/reload-plugins` after setup.
- If it works: proceed to Step 2.

#### Step 2: First Queries
Walk the user through practical examples:
1. **Search contacts**: Use `search_entities` with `type: "contact"`
2. **View a deal pipeline**: Use `search_entities` with `type: "deal"`
3. **Check relationships**: Use `traverse_graph` on a contact to see their company, deals, interactions
4. **Read a brief**: Use `list_briefs` then `get_brief` to see a derived summary with evidence citations
5. **Drill into evidence**: From a brief, follow observation IDs to `get_observation`, then to `get_artifact` for raw source

#### Step 3: Explain the Architecture
If the user asks, explain the core concepts:
- **Entities**: Typed records (contact, company, deal, interaction, task, agent) with JSON properties
- **Relationships**: Directed edges between entities (EMPLOYED_AT, ASSOCIATED_WITH, etc.)
- **Memory Layer**: Artifacts -> Observations -> Briefs -> Conflicts (evidence chain)
- **Event Ledger**: Append-only audit trail for every mutation
- **Field Provenance**: Per-field source tracking for trust

### Key Principles
- Always use the MCP tools (not REST API) when working through Claude
- The memory layer is the differentiator — emphasize the evidence chain
- Progressive retrieval: start with briefs, drill to observations, then artifacts
- Every claim should have receipts (provenance)
