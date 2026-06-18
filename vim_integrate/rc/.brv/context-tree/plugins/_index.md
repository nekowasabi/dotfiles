---
children_hash: 03747effd5d997248b187cb1a1aa07d13508c650a050fa34661c59e70450f079
compression_ratio: 0.6036585365853658
condensation_order: 2
covers: [battlefront/_index.md, startup_fixes/_index.md]
covers_token_total: 1148
summary_level: d2
token_count: 693
type: summary
---
## plugins

Structural summaries of two Neovim plugin topics: **Battlefront.vim** for task movement/tag rendering and **Neovim Plugin Startup Fixes** for startup compatibility changes. Drill down into **battlefront_vim.md** and **neovim_plugin_startup_fixes.md** for implementation detail.

### battlefront
- **battlefront_vim.md** documents the full behavior of Battlefront.vim, a task-movement plugin for progress files.
- Core behaviors:
  - Move tasks between markdown headers, especially **Today** and other sections.
  - When moved into **Today**, add an origin tag in the form `@<header_name>`.
  - Restore tasks back to their origin header, with text-based fallback when tags are missing.
  - Load weekly tasks from an external YAML file rather than hardcoding them.
- Tag display model:
  - Replaced right-aligned `virt_text` tags with a **conceal-based inline** approach.
  - Tags are hidden in normal mode and revealed inline in Insert mode.
  - Visibility is refreshed on edit and cursor events for consistency.
- Dependencies and mechanics:
  - Uses Vim/Neovim features such as **conceal**, **syntax match**, **augroup autocmds**, **matchaddpos**, and **timer_start**.
  - Depends on **Python 3** for YAML loading when the external file is readable.
- Key rules and scope:
  - Weekly tasks live outside the repo at `~/repos/private_dotfiles/battlefront_weekly_tasks.yml`.
  - Old `virt_text` extmarks are cleared on write/change events to normalize display state.
  - Progress buffers covered: `battlefront/progress/private.md` and `battlefront/progress/work.md`.
- Important patterns:
  - `^#\s+Today$` for the Today header
  - `^#` for markdown headers
  - `\s+@\S+\s*$` for inline origin tags
  - `^\s+[-*]\s*\[` for indented checklist child tasks

### startup_fixes
- **neovim_plugin_startup_fixes.md** covers startup compatibility fixes for **`plugins/kulala.vim`** and **`plugins/claudecode.vim`**.
- **kulala.vim** changes:
  - Remove the `kulala.parser.jsonpath` requirement from `kulala.nvim` configuration because newer versions no longer need it.
  - Preserve formatter guards for:
    - `application/json`
    - `application/xml`
    - `text/html`
  - External formatter dependencies remain conditional via `executable()` checks, including **jq** and **xmllint** when available.
- **claudecode.vim** changes:
  - Replace `denops#plugin#register` with `denops#plugin#load`.
  - Delay loading until after the `User DenopsReady` event to avoid channel-not-ready startup errors.
- Startup flow:
  - `Neovim startup -> load plugin config -> apply guarded formatters -> load denops plugin after User DenopsReady`
- Main compatibility goals:
  - Avoid missing `kulala.parser.jsonpath` module errors.
  - Avoid denops startup and channel readiness errors.