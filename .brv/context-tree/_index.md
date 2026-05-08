---
children_hash: 53db90671b767da069d556f9184602d4eb86d61f95d49653d53ce20bdebc7a55
compression_ratio: 0.911660777385159
condensation_order: 3
covers: [design_philosophy/_index.md]
covers_token_total: 283
summary_level: d3
token_count: 258
type: summary
---
## Design Philosophy

The design philosophy is organized around a **Three Classification Design** that divides all processing into three categories: **deterministic** (code), **judgment** (LLM), and **preference** (pre-flight questions).

### Processing Flow
Pre-flight Questions → Deterministic processing → Judgment tasks

### Architectural Decisions
- **Deterministic tasks** → Bash/shell scripts (for reproducibility, cost, and speed)
- **Judgment tasks** → LLM with clear "judgment target" and "judgment criteria", fed deterministic preprocessing results
- **Preference questions** → consolidated upfront to avoid scattered round-trips

### Governing Rules
- Do not assign deterministic work to LLM
- Do not over-constrain LLM on judgment
- Do not postpone preference questions

### Dependencies
Relates to cognitive load (A2), unverified information risk (A3), and user intent fidelity (A5).

*Drill into `agent_system/_index.md` for agent-specific patterns, and `three_classification_design.md` for implementation details.*