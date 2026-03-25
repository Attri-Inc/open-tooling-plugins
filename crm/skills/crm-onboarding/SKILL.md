---
name: crm-onboarding
description: "Triggered when the user first connects Open Tooling CRM, asks how to get started, or needs help setting up. Walks through seeding data, verifying the MCP connection, and running first queries."
---

# CRM Onboarding

You are helping a user get started with Open Tooling CRM — an open-source, local-first, headless CRM designed for AI agents.

## When to Use This Skill
- User says "how do I get started with the CRM" or similar
- User just connected the Open Tooling CRM MCP server for the first time
- User asks about setup, configuration, or first steps

## Onboarding Flow

### Step 1: Verify Connection
Use the `search_entities` tool with no filters to check if the MCP server is responding. If it fails, guide the user through setup:
1. Clone the repo: `git clone https://github.com/Attri-Inc/open-tooling.git`
2. Navigate to CRM: `cd open-tooling/crm`
3. Install: `npm install && cp .env.example .env`
4. Start: `npm run dev`
5. Connect MCP server in their client config

### Step 2: Seed Sample Data (Optional)
If the database is empty, suggest: `npm run seed` to populate with sample contacts, companies, deals, interactions, and memory layer data (artifacts, observations, briefs).

### Step 3: First Queries
Walk the user through practical examples:
1. **Search contacts**: Use `search_entities` with `type: "contact"`
2. **View a deal pipeline**: Use `search_entities` with `type: "deal"`
3. **Check relationships**: Use `traverse_graph` on a contact to see their company, deals, interactions
4. **Read a brief**: Use `list_briefs` then `get_brief` to see a derived summary with evidence citations
5. **Drill into evidence**: From a brief, follow observation IDs to `get_observation`, then to `get_artifact` for raw source

### Step 4: Explain the Architecture
If the user asks, explain the core concepts:
- **Entities**: Typed records (contact, company, deal, interaction, task, agent) with JSON properties
- **Relationships**: Directed edges between entities (EMPLOYED_AT, ASSOCIATED_WITH, etc.)
- **Memory Layer**: Artifacts → Observations → Briefs → Conflicts (evidence chain)
- **Event Ledger**: Append-only audit trail for every mutation
- **Field Provenance**: Per-field source tracking for trust

### Key Principles
- Always use the MCP tools (not REST API) when working through Claude
- The memory layer is the differentiator — emphasize the evidence chain
- Progressive retrieval: start with briefs, drill to observations, then artifacts
- Every claim should have receipts (provenance)
