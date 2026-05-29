---
children_hash: c787741140497aecb394cb5974ce9d4e9612fc5da8ba985397ced99545f3c829
compression_ratio: 0.7979942693409742
condensation_order: 2
covers: [battlefront/_index.md]
covers_token_total: 698
summary_level: d2
token_count: 557
type: summary
---
## Battlefront.vim

Battlefront.vim is a task-movement plugin for markdown progress files. Its main responsibilities are:
- moving tasks between headers,
- tagging moved tasks with their origin header,
- restoring tasks to the original section,
- controlling how those tags are displayed.

The consolidated source entry is **battlefront_vim.md**.

### Core behavior
- Tasks are moved across **Today** and other markdown headers using arrow-key-based relocation.
- When a task is moved into **Today**, it receives an origin tag like `@<header_name>`, enabling restoration later.
- Restoration prefers the origin tag, but falls back to text-based matching when tags are missing.
- Weekly tasks are loaded from an external YAML file rather than being hardcoded.

### Tag display model
- The plugin uses a **conceal-based inline display** instead of the older right-aligned `virt_text` model.
- Tags are hidden in normal mode and revealed inline in Insert mode.
- Visibility is refreshed on edit and cursor events to keep display state consistent.

### Structure and dependencies
- Relies on Vim/Neovim features: **conceal**, **syntax match**, **augroup autocmds**, **matchaddpos**, and **timer_start**.
- Depends on **Python 3** for YAML loading when the external file is readable.
- External weekly task source: `~/repos/private_dotfiles/battlefront_weekly_tasks.yml`.

### Rules and constraints
- Weekly tasks are loaded externally so public repository data stays separated from code.
- Tags should remain hidden during normal browsing but visible while editing to avoid obscuring task context.
- Old `virt_text` extmarks are removed on write/change events to normalize display state.

### Key patterns and anchors
- `^#\s+Today$` — detects the Today header
- `^#` — detects markdown headers
- `\s+@\S+\s*$` — matches inline origin tags
- `^\s+[-*]\s*\[` — matches indented checklist child tasks

### Scope
- The plugin’s logic centers on task movement, origin preservation, weekly task loading, and dynamic tag visibility.
- Covered progress buffers: `battlefront/progress/private.md` and `battlefront/progress/work.md`.

### Drill-down
- See **battlefront_vim.md** for full behavior, implementation notes, and detailed rules.