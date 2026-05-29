---
children_hash: 8e8b5c9fe63690973b0a91c697e5ebc264d710907877523536925bb30a07e17a
compression_ratio: 0.4346338124572211
condensation_order: 1
covers: [battlefront_vim.md]
covers_token_total: 1461
summary_level: d1
token_count: 635
type: summary
---
# Battlefront.vim

Battlefront.vim is a task-movement plugin for progress files with three core behaviors: moving tasks between sections, tagging moved tasks with their origin header, and controlling how those tags are displayed. The consolidated entry is **battlefront_vim.md**; the redundant compressed versions were **battlefront_vim.abstract.md** and **battlefront_vim.overview.md**.

## Core behavior

- Moves tasks across **Today** and other markdown headers using arrow-key-based relocation.
- When a task is moved into **Today**, it injects an origin tag in the form `@<header_name>` so the task can later be restored to its source section.
- Can restore tasks back to their origin header, with a fallback to text-based matching if origin tags are missing.
- Loads weekly tasks from an external YAML file instead of hardcoding them.

## Tag display model

- The plugin replaced old right-aligned `virt_text` tag display with a **conceal-based inline model**.
- Tags are hidden in normal mode and revealed inline in Insert mode.
- Visibility is refreshed on editing and cursor events to keep the display consistent.

### Relevant entry details
- **battlefront_vim.md** contains the full behavior, rules, and implementation notes.
- The tag display system is tied to **InsertEnter**, **TextChangedI**, **CursorMovedI**, **ModeChanged**, **BufWritePost**, and **TextChanged**.

## Structure and dependencies

- Uses Vim/Neovim features including **conceal**, **syntax match**, **augroup autocmds**, **matchaddpos**, and **timer_start**.
- Depends on **Python 3** for YAML loading when the external file is readable.
- Weekly task source: `~/repos/private_dotfiles/battlefront_weekly_tasks.yml`

## Key rules and constraints

- Weekly tasks are loaded externally so public repository data stays separated from code.
- Tags should be hidden during normal browsing but visible during editing to avoid obscuring task context.
- Old `virt_text` extmarks are removed on write/change events to normalize display state.

## Key patterns and anchors

- `^#\s+Today$` — detects the Today header
- `^#` — detects markdown headers
- `\s+@\S+\s*$` — matches inline origin tags
- `^\s+[-*]\s*\[` — matches indented checklist child tasks

## Facts and scope

- Tag display mode is conceal in normal mode, inline in Insert mode.
- The progress buffers covered are `battlefront/progress/private.md` and `battlefront/progress/work.md`.
- The plugin’s logic centers on task movement, origin preservation, weekly task loading, and dynamic tag visibility.