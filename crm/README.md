# Open Tooling CRM Plugin

Gives Claude the knowledge layer to use [Open Tooling CRM](https://github.com/Attri-Inc/open-tooling-crm) optimally from the get-go.

## What's Included

### Skills (auto-triggered)

| Skill | Triggers when... |
|-------|-------------------|
| **CRM Onboarding** | User first connects Open Tooling CRM or asks how to get started |
| **Evidence Ingestion** | User mentions emails, transcripts, documents, or raw evidence to ingest |
| **Entity Management** | User wants to create, update, search, or manage contacts, companies, deals |
| **Memory Layer** | User asks what's known about a contact/deal, or wants to update knowledge |

### Commands (user-invoked)

| Command | What it does |
|---------|--------------|
| `/crm-ingest` | Ingest an email, transcript, or document into the CRM evidence chain |
| `/crm-brief` | Get a full briefing on a contact, company, or deal with evidence trail |
| `/crm-status` | Quick pipeline overview and recent activity |

## Prerequisites

1. Open Tooling CRM running locally (`npm run dev`)
2. MCP server connected (see main repo for config)

## Connectors (Optional)

See [CONNECTORS.md](./CONNECTORS.md) for integrations that supercharge the plugin.
