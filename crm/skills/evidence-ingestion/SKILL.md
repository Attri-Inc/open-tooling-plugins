---
name: evidence-ingestion
description: "Triggered when the user mentions emails, transcripts, meeting notes, documents, or any raw evidence they want to ingest into the CRM. Teaches Claude the artifact → observation → brief pipeline."
---

# Evidence Ingestion

You are helping a user ingest raw evidence into Open Tooling CRM and extract structured knowledge from it.

## When to Use This Skill
- User shares an email, transcript, meeting notes, or document
- User says "ingest this", "add this to the CRM", "log this interaction"
- User pastes raw text and wants it captured with provenance

## The Evidence Chain

Open Tooling CRM follows a strict evidence chain: **Artifact → Observations → Brief → Conflicts**

### Step 1: Ingest the Artifact
Use `ingest_artifact` with:
- `artifact_type`: one of `email`, `call_transcript`, `meeting_notes`, `document`, `note`
- `content`: the raw text content
- `source`: where it came from (e.g., "Gmail", "user paste", "Zoom transcript")
- `participants`: array of participant names/emails if applicable
- `timestamp`: when the interaction occurred

The artifact is stored immutably and content-hashed for integrity.

### Step 2: Extract Observations
Read the artifact content and extract typed, atomic claims. For each claim, use `add_observation` with:
- `entity_id`: the entity this observation is about
- `observation_type`: one of `fact`, `sentiment`, `intent`, `event`, `metric`, `relationship`, `status_change`
- `content`: the specific claim (atomic — one fact per observation)
- `artifact_id`: links back to the source artifact
- `confidence`: 0.0–1.0 based on how explicit the claim is in the source

**Extraction guidelines:**
- Be specific: "Budget is $120,000" not "They discussed budget"
- Be atomic: one claim per observation, not compound statements
- Include context: "Decision maker is Maya Chen (mentioned by CEO in Q3 review call)"
- Flag uncertainty: lower confidence for inferred vs. explicitly stated claims
- Check for conflicts: if a new observation contradicts an existing one, create a conflict

### Step 3: Link to Entities
For each observation, ensure the referenced entity exists. If not:
1. Use `create_entity` to create the contact, company, or deal
2. Use `link_entities` to establish relationships (e.g., contact EMPLOYED_AT company)
3. Then add the observation linked to the correct entity

### Step 4: Check for Conflicts
After adding observations, check if any contradict existing current observations on the same entity:
1. Use `list_observations` with `entity_id` and `lifecycle: "current"`
2. Compare new observations against existing ones
3. If a conflict exists, use `create_conflict` to record it explicitly
4. If the new information supersedes old information, use `supersede_observation` on the old one

### Step 5: Update Briefs
If a brief exists for the affected entity, it may now be stale. Use `create_brief` to regenerate it, citing the updated set of current observations.

## Example Workflow

User: "Here's the email from the call with Acme Corp yesterday"

1. `ingest_artifact` → artifact_id: "art_abc123"
2. Extract observations:
   - "Acme's budget for this project is $250K" → fact, confidence: 0.9
   - "Timeline is Q2 2026" → fact, confidence: 0.85
   - "Sarah Chen is the technical decision maker" → relationship, confidence: 0.95
   - "They're evaluating us against Competitor X" → intent, confidence: 0.8
3. Link entities: create/find Acme Corp, Sarah Chen, the deal
4. Check existing observations for conflicts
5. Regenerate brief for the Acme deal

## Key Principles
- Never skip the artifact step — raw evidence must be preserved
- Never create observations without linking to an artifact
- Always check for conflicts rather than silently overwriting
- Confidence should reflect how explicit the claim is in the source material
