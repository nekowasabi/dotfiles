---
children_hash: 10d421135df18a622dda388aeb84d67fa1187620ada271fcbfb91f2ccd1fc949
compression_ratio: 0.9032258064516129
condensation_order: 3
covers: [plugins/_index.md]
covers_token_total: 620
summary_level: d3
token_count: 560
type: summary
---
## Plugins

The `plugins` domain currently centers on **Battlefront.vim**, with the consolidated implementation and details in **battlefront_vim.md**.

### Battlefront.vim overview
- A task-movement plugin for markdown progress files.
- Core responsibilities:
  - move tasks between headers,
  - tag moved tasks with their origin header,
  - restore tasks to the original section,
  - control how those tags are displayed.

### Key behavior
- Tasks are relocated across **Today** and other markdown headers using arrow-key-driven movement.
- When moved into **Today**, a task is tagged with its origin header, e.g. `@<header_name>`, so it can be restored later.
- Restoration prefers the origin tag and falls back to text matching when tags are missing.
- Weekly tasks are loaded from an external YAML file rather than being hardcoded.

### Display and UI model
- Uses a **conceal-based inline display** instead of the older right-aligned `virt_text` model.
- Tags stay hidden in normal mode and appear inline in Insert mode.
- Visibility is refreshed on edit and cursor events to keep the display consistent.

### Dependencies and implementation hooks
- Relies on Vim/Neovim features:
  - `conceal`
  - `syntax match`
  - `augroup autocmds`
  - `matchaddpos`
  - `timer_start`
- Requires **Python 3** for YAML loading when the external file is readable.
- External weekly task source:
  - `~/repos/private_dotfiles/battlefront_weekly_tasks.yml`

### Rules and constraints
- Weekly tasks are kept external so public repository data remains separated from code.
- Tags should remain hidden while browsing and visible while editing.
- Old `virt_text` extmarks are cleared on write/change events to normalize display.

### Patterns and anchors
- `^#\s+Today$` — detects the Today header
- `^#` — detects markdown headers
- `\s+@\S+\s*$` — matches inline origin tags
- `^\s+[-*]\s*\[` — matches indented checklist child tasks

### Scope
- Focuses on task movement, origin preservation, weekly task loading, and dynamic tag visibility.
- Applies to progress buffers such as:
  - `battlefront/progress/private.md`
  - `battlefront/progress/work.md`

### Drill-down
- See **battlefront_vim.md** for the full implementation notes and detailed rules.