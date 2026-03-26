---
description: "Ingest an email, transcript, or document into the CRM evidence chain"
argument-hint: "paste or describe the content to ingest"
---

## CRM Status Check

Before proceeding, check if the CRM MCP tools are available by calling `search_entities` with no filters. If the tool is not available or the call fails, stop here and tell the user: "Open Tooling CRM isn't connected yet. Run `/crm-setup` first to get everything installed and connected."

---

# /crm-ingest

Ingest raw evidence into Open Tooling CRM and extract structured knowledge.

## What I Need From You
- The raw content (email, transcript, meeting notes, or document) — paste it or describe it
- Who was involved (optional — I'll try to extract participants)
- Which contact, company, or deal this relates to (optional — I'll try to match)

## What I'll Do
1. **Ingest** the raw content as an immutable artifact
2. **Extract** typed observations (facts, sentiments, intents, metrics, events)
3. **Link** observations to the relevant entities (creating them if needed)
4. **Check** for conflicts against existing observations
5. **Update** briefs for affected entities

## Output
- Confirmation of artifact ingestion with ID
- List of extracted observations with confidence scores
- Any new entities or relationships created
- Any conflicts detected
- Updated brief summary for affected entities
