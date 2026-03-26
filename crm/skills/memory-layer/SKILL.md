---
name: memory-layer
description: "Triggered when the user asks what's known about a contact, company, or deal, or wants to update, verify, or manage CRM knowledge. Teaches Claude the progressive retrieval pattern and evidence chain."
---

## CRM Status Check

Before proceeding, check if the CRM MCP tools are available by calling `search_entities` with no filters. If the tool is not available or the call fails, stop here and tell the user: "Open Tooling CRM isn't connected yet. Run `/crm-setup` first to get everything installed and connected." Do not proceed with any memory layer operations.

---

# Memory Layer

You are helping a user interact with Open Tooling CRM's evidence-first memory system.

## When to Use This Skill
- User asks "what do we know about [contact/company/deal]?"
- User wants to verify a claim or check evidence
- User asks about observation lifecycle (supersede, retract)
- User wants to understand conflicts or stale data

## The Memory Primitives

### Artifacts
Raw, immutable evidence. Content-hashed for integrity.
- Types: `email`, `call_transcript`, `meeting_notes`, `document`, `note`
- Tools: `ingest_artifact`, `get_artifact`, `list_artifacts`

### Observations
Typed, atomic claims extracted from artifacts. Each has a lifecycle.
- Types: `fact`, `sentiment`, `intent`, `event`, `metric`, `relationship`, `status_change`
- Lifecycle: `current` → `superseded` or `retracted`
- Tools: `add_observation`, `get_observation`, `list_observations`, `supersede_observation`, `retract_observation`

### Briefs
Derived summaries that cite observations. Always regeneratable.
- Types: `contact_brief`, `company_brief`, `deal_brief`, `interaction_summary`
- Tools: `create_brief`, `get_brief`, `list_briefs`

### Conflicts
Explicit records when observations disagree. Never silently resolved.
- Tools: `create_conflict`, `get_conflict`, `list_conflicts`, `resolve_conflict`

## Progressive Retrieval Pattern

When the user asks "what do we know about X?", follow this pattern:

### Level 1: Brief (Start Here)
1. Use `list_briefs` with `entity_id` to find existing briefs
2. If a brief exists, present the summary — it cites observation IDs
3. If no brief exists, go to Level 2 and offer to generate one

### Level 2: Observations (Drill Down)
1. Use `list_observations` with `entity_id` and `lifecycle: "current"`
2. Present the current observations grouped by type
3. Each observation references an `artifact_id` for provenance

### Level 3: Artifacts (Raw Evidence)
1. Use `get_artifact` to retrieve the raw source material
2. Show the user exactly what was said and where it came from
3. This is the "receipts" — the bottom of the evidence chain

## Managing Knowledge

### Superseding Observations
When new information replaces old (e.g., budget changed from $100K to $150K):
1. Use `supersede_observation` on the old observation, providing the new observation ID
2. The old observation moves to `superseded` lifecycle but is never deleted
3. The audit trail is preserved

### Retracting Observations
When information turns out to be wrong:
1. Use `retract_observation` with a reason
2. The observation moves to `retracted` lifecycle
3. Any briefs citing it should be regenerated

### Resolving Conflicts
When two observations disagree:
1. Present both observations and their source artifacts to the user
2. Let the user decide which is correct
3. Use `resolve_conflict` with the resolution
4. Supersede or retract the incorrect observation

## Key Principles
- Always start with briefs, drill down only when needed
- Every claim must trace back to an artifact — no orphan observations
- Never silently overwrite — supersede or retract with an audit trail
- Conflicts are features, not bugs — they surface data quality issues
- Briefs are derived, never authoritative — the observations are the source of truth
