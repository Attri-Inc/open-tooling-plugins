---
name: entity-management
description: "Triggered when the user wants to create, update, search, or manage CRM entities (contacts, companies, deals, interactions, tasks). Provides best practices for entity operations and relationship management."
---

## CRM Status Check

Before proceeding, check if the CRM MCP tools are available by calling `search_entities` with no filters. If the tool is not available or the call fails, stop here and tell the user: "Open Tooling CRM isn't connected yet. Run `/crm-setup` first to get everything installed and connected." Do not proceed with any entity operations.

---

# Entity Management

You are helping a user manage CRM entities in Open Tooling CRM.

## When to Use This Skill
- User wants to create, find, update, or archive contacts, companies, deals, tasks
- User asks to link entities or explore relationships
- User wants to search or filter CRM data

## Entity Types

| Type | Typical Properties |
|------|-------------------|
| `contact` | name, email, phone, title, company, notes |
| `company` | name, domain, industry, size, location, website |
| `deal` | name, value, stage, expected_close, probability |
| `interaction` | type (call/email/meeting), date, summary, participants |
| `task` | title, description, due_date, status, assigned_to |
| `agent` | name, type, capabilities |

Properties are stored as JSON — fully flexible. The types above are conventions, not constraints.

## Best Practices

### Creating Entities
- Always check if the entity exists first with `search_entities` before creating duplicates
- Use meaningful properties that agents can query later
- Set appropriate `status` (active/inactive/archived)

### Relationships
Available relationship types: `EMPLOYED_AT`, `ASSOCIATED_WITH`, `OWNS`, `INTERACTED_WITH`, `CREATED_BY`, `RELATED_TO`

- Link contacts to companies with `EMPLOYED_AT`
- Link deals to companies with `ASSOCIATED_WITH`
- Link interactions to participants with `INTERACTED_WITH`
- Use `traverse_graph` to explore relationship networks (set depth for multi-hop)

### Searching
- Use `search_entities` with `type` filter for scoped searches
- Use `q` parameter for full-text search across entity properties
- Use `filters` for structured queries (e.g., `{"stage": "negotiation"}`)
- Combine: `type=deal&q=acme&filters={"stage":"negotiation"}`

### Updating
- Use `update_entity` with `merge` mode (default) to add/update specific properties without overwriting others
- Use `replace` mode only when you want to fully replace all properties
- Every update creates an event in the ledger — nothing is lost

### Archiving
- Use `archive_entity` (soft delete) rather than hard deletion
- Archived entities are excluded from searches by default but can still be retrieved by ID

## Key Principles
- Check before creating — avoid duplicates
- Link entities to build the relationship graph
- Use structured properties that are queryable, not free-text blobs
- Every mutation is audited in the event ledger
