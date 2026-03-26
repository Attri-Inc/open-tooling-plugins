---
description: "Get a full briefing on a contact, company, or deal with evidence trail"
argument-hint: "contact, company, or deal name"
---

## CRM Status Check

Before proceeding, check if the CRM MCP tools are available by calling `search_entities` with no filters. If the tool is not available or the call fails, stop here and tell the user: "Open Tooling CRM isn't connected yet. Run `/crm-setup` first to get everything installed and connected."

---

# /crm-brief

Get a comprehensive briefing on any entity in Open Tooling CRM, backed by evidence.

## What I Need From You
- The name of the contact, company, or deal you want briefed
- Optionally: what aspect you care about most (e.g., "deal status", "recent interactions", "key relationships")

## What I'll Do
1. **Search** for the entity by name
2. **Pull the brief** if one exists (or generate one from current observations)
3. **Show current observations** grouped by type, with confidence and source
4. **Surface conflicts** if any observations disagree
5. **Map relationships** — who and what is connected to this entity

## Output
- Summary brief with cited observations
- Key facts, open questions, and recent changes
- Relationship map (connected contacts, companies, deals)
- Flagged conflicts or low-confidence observations
- Links to source artifacts for verification
