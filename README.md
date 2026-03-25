# Open Tooling Plugins

**Give Claude superpowers with AI-native SaaS tools — install a plugin and go.**

Plugin marketplace for [Open Tooling](https://github.com/Attri-Inc/open-tooling) — an open-source family of AI-native SaaS tools designed for agents, not humans.

[![License](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE)

---

## Why Plugins?

Open Tooling gives your AI agent a full enterprise back office — CRM, and soon HR, Finance, Project Management, and more. These plugins give Claude the **knowledge layer** to use each tool optimally out of the box: the right ingestion patterns, evidence-chain workflows, progressive retrieval, and domain-specific best practices.

No training. No prompt engineering. Install the plugin and Claude just *knows* how to operate your tools.

---

## Available Plugins

| Plugin | What it does | Status |
|--------|-------------|--------|
| [**CRM**](./crm) | Evidence-based CRM with 27 MCP tools — contacts, deals, memory layer, full provenance | v0.1.0 |

More plugins coming — covering HR, Finance, Project Management, Procurement, and beyond. Same architectural DNA: headless, local-first, evidence-based, agent-first.

---

## Getting Started

### Install the Marketplace

In [Claude](https://claude.ai) (Cowork or desktop):

1. **Customize** → **Add plugin** → **Add marketplace**
2. Enter: `Attri-Inc/open-tooling-plugins`
3. Click **Sync**

### Install a Plugin

**Customize** → **Add plugin** → **Browse plugins** → **Personal** → **open-tooling-plugins** → select the plugin you want.

### That's It

The CRM plugin includes a `/crm-setup` command that handles everything — cloning the repo, installing dependencies, seeding sample data, and wiring up the MCP server. Or just ask Claude to "use Open Tooling CRM" and it kicks off setup automatically.

<!-- TODO: Replace with GIF showing marketplace install → plugin install → hands-off /crm-setup -->
<!-- ![Open Tooling CRM Setup in Claude Cowork](./assets/crm-setup-demo.gif) -->

> **See it in action:** The GIF above shows the full flow — marketplace install, plugin install, and hands-off setup. From zero to a running CRM in under a minute.

---

## How Plugins Work

Each plugin bundles:

- **Skills** — domain knowledge that Claude activates automatically based on context (e.g., when you mention "ingest this email", the evidence ingestion skill kicks in)
- **Commands** — explicit actions you invoke with `/` (e.g., `/crm-setup`, `/crm-brief`)
- **MCP server config** — auto-wires the tool's MCP server so Claude can call its tools directly

Plugins don't just connect Claude to a tool — they teach Claude *how to think* about the domain. The CRM plugin teaches evidence-chain reasoning, progressive retrieval, and conflict detection. Future plugins will bring domain-specific reasoning for their respective verticals.

---

## Part of Open Tooling

These plugins are the agent interface layer for [Open Tooling](https://github.com/Attri-Inc/open-tooling) — open-source, AI-native SaaS tools that share the same DNA:

- **Headless** — no UI, just APIs and MCP tools
- **Local-first** — SQLite, self-hostable, zero cloud dependencies
- **Evidence-based** — every claim traces back to raw source material
- **Agent-first** — designed for AI agents as the primary operators

The tools live at [Attri-Inc/open-tooling](https://github.com/Attri-Inc/open-tooling). The plugins live here. Together they give you a fully agent-operated back office.

---

## Contributing

We'd love contributions — new plugins, improvements to existing ones, bug reports, and feature requests.

See the [Open Tooling repo](https://github.com/Attri-Inc/open-tooling) for the core tools.

---

## License

Apache 2.0

Built by [Attri AI](https://github.com/Attri-Inc).
