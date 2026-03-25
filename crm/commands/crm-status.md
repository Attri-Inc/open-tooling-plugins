---
description: "Quick pipeline overview and recent CRM activity"
argument-hint: ""
---

## CRM Status
!`cat ~/.open-tooling/state.json 2>/dev/null || echo '{"setup_required": true}'`

**If `setup_required` is true above, stop here.** Tell the user: "Open Tooling CRM isn't set up yet. Run `/crm-setup` first to get everything installed and connected."

---

# /crm-status

Get a quick overview of your CRM pipeline and recent activity.

## What I'll Do
1. **Pipeline snapshot**: Search all deals, group by stage, show total values
2. **Recent activity**: Pull recent events from the ledger (last 7 days)
3. **Open conflicts**: List any unresolved conflicts that need attention
4. **Stale briefs**: Flag entities with observations newer than their last brief

## Output
- Deal pipeline by stage with values
- Recent entity changes and interactions
- Action items: conflicts to resolve, briefs to regenerate, follow-ups due
