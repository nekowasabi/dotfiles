---
children_hash: cd454108b94b3420cad5cd49c5446b8439567eda7f72c0b30c8c929618c376a7
compression_ratio: 0.6827309236947792
condensation_order: 1
covers: [three_classification_design.md]
covers_token_total: 498
summary_level: d1
token_count: 340
type: summary
---
## Three Classification Design

Design philosophy for commands, agents, and skills: all processing splits into 3 categories — **deterministic** (code), **judgment** (LLM), and **preference** (pre-flight questions).

### Flow
Pre-flight Questions (preferences) → Deterministic processing (code) → Judgment tasks (LLM)

### Architectural Decisions
- **Deterministic tasks → code**: reproducibility, cost, and speed degrade if assigned to LLM. Implement with Bash/shell scripts; pass only output to LLM.
- **Judgment tasks → LLM**: over-constraining loses contextual adaptability. Clearly specify "judgment target" and "judgment criteria", feeding deterministic preprocessing results as input.
- **Preference questions → upfront**: consolidate all `AskUserQuestion` calls at the top to avoid scattered round-trips and context pollution.

### Governing Rules
1. **Do not assign deterministic tasks to LLM** — reproducibility, cost, and speed degrade.
2. **Do not over-constrain LLM on judgment tasks** — contextual adaptability is lost.
3. **Do not postpone preference questions** — scattered calls increase round-trips and pollute context.

### Dependencies
A2 (cognitive load minimization), A3 (unverified information risk), A5 (user intent faithful realization)

*Drill down into `three_classification_design.md` for full implementation patterns and examples.*