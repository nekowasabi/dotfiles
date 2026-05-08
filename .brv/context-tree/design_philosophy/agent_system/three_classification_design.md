---
title: Three Classification Design
summary: 'Design philosophy for commands/agents/skills: 3-classification approach dividing work into deterministic (code), judgment (LLM), and preference (pre-flight questions)'
tags: []
related: []
keywords: []
createdAt: '2026-05-08T10:17:35.930Z'
updatedAt: '2026-05-08T10:17:35.930Z'
---
## Reason
Curate design philosophy for commands/agents/skills creation with deterministic/judgment/preference classification

## Raw Concept
**Task:**
Define common design philosophy for creating/revising commands, agents, and skills

**Files:**
- .tmp/design-philosophy.md

**Flow:**
Pre-flight Questions (preferences) -> Deterministic processing (code) -> Judgment tasks (LLM)

**Timestamp:** 2026-05-08

**Author:** takets

## Narrative
### Structure
The design philosophy classifies all processing into 3 categories when creating or revising commands, agents, and skills.

### Dependencies
A2 (cognitive load minimization), A3 (unverified information risk), A5 (user intent faithful realization)

### Highlights
Deterministic tasks go to code for reproducibility/cost/speed. Judgment tasks go to LLM for contextual adaptability. Preferences are front-loaded via AskUserQuestion to avoid round-trips.

### Rules
Rule 1 (確定論をLLMに任せない): Do not assign deterministic tasks to LLM — reproducibility, cost, and speed all degrade. Prioritize coding.
Rule 2 (LLMを確定論に縛らない): Do not over-constrain LLM on judgment tasks — its strength of contextual adaptability is lost.
Rule 3 (意見は先送りしない): Do not postpone preference questions — scattered AskUserQuestion calls increase round-trips and pollute context. Consolidate all preference questions upfront.

### Examples
Implementation pattern: (1) Place Pre-flight Questions phase at the top of skill/agent. (2) Implement deterministic processing with Bash/shell scripts and pass only output to LLM. (3) Clearly specify "judgment target" and "judgment criteria" to LLM, feeding deterministic preprocessing results as input.
