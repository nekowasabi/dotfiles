---
children_hash: dac2dd40e0e4988d687f040932ed87d9f37c631d224f77879190623df541ae8e
compression_ratio: 0.5407407407407407
condensation_order: 2
covers: [agent_system/_index.md]
covers_token_total: 405
summary_level: d2
token_count: 219
type: summary
---
## Three Classification Design

Design philosophy dividing all processing into three categories: **deterministic** (code), **judgment** (LLM), and **preference** (pre-flight questions).

**Flow**: Pre-flight Questions → Deterministic processing → Judgment tasks

**Architectural Decisions**:
- Deterministic tasks → Bash/shell scripts (reproducibility, cost, speed)
- Judgment tasks → LLM with clear "judgment target" and "judgment criteria", fed deterministic preprocessing results
- Preference questions → consolidated upfront to avoid scattered round-trips

**Governing Rules**: Do not assign deterministic work to LLM, do not over-constrain LLM on judgment, do not postpone preference questions.

**Dependencies**: A2 (cognitive load), A3 (unverified information risk), A5 (user intent fidelity).

*Drill into `three_classification_design.md` for implementation patterns.*