# Open Tooling CRM Plugin

Gives Claude the knowledge layer to use [Open Tooling CRM](https://github.com/Attri-Inc/open-tooling/tree/main/crm) optimally from the get-go.

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

## Part of Open Tooling

CRM is the first plugin in the Open Tooling family. More modules coming soon — HR, Finance, Project Management, and Legal — each with their own dedicated plugin for instant agent-ready workflows.

## Connectors (Optional)

See [CONNECTORS.md](./CONNECTORS.md) for integrations that supercharge the plugin.
