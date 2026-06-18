---
children_hash: 63369bd27bfa2b723354b0bf9c6af9e285a2ca9f839c0917a23edbed11be858e
compression_ratio: 0.872870249017038
condensation_order: 3
covers: [plugins/_index.md]
covers_token_total: 763
summary_level: d3
token_count: 666
type: summary
---
## plugins

Structural summary of two Neovim plugin topics: **Battlefront.vim** and **Neovim Plugin Startup Fixes**. Drill down into **battlefront_vim.md** and **neovim_plugin_startup_fixes.md** for implementation details.

### battlefront
- **battlefront_vim.md** documents Battlefront.vim as a task-movement plugin for progress files.
- Core behavior:
  - Move tasks between markdown headers, especially **Today** and other sections.
  - When moving into **Today**, add an origin tag like `@<header_name>`.
  - Restore tasks to their origin header, with text-based fallback if tags are missing.
  - Load weekly tasks from an external YAML file instead of hardcoding them.
- Tag rendering model:
  - Replaced right-aligned `virt_text` tags with a **conceal-based inline** approach.
  - Tags are hidden in normal mode and revealed inline in Insert mode.
  - Visibility is refreshed on edit and cursor events for consistency.
- Mechanics and dependencies:
  - Uses Vim/Neovim features including **conceal**, **syntax match**, **augroup autocmds**, **matchaddpos**, and **timer_start**.
  - Depends on **Python 3** for YAML loading when the external file is readable.
- Scope and rules:
  - Weekly tasks live outside the repo at `~/repos/private_dotfiles/battlefront_weekly_tasks.yml`.
  - Old `virt_text` extmarks are cleared on write/change events to normalize display state.
  - Covered progress buffers include `battlefront/progress/private.md` and `battlefront/progress/work.md`.
- Key patterns:
  - `^#\s+Today$` for the Today header
  - `^#` for markdown headers
  - `\s+@\S+\s*$` for inline origin tags
  - `^\s+[-*]\s*\[` for indented checklist child tasks

### startup_fixes
- **neovim_plugin_startup_fixes.md** covers startup compatibility fixes for **`plugins/kulala.vim`** and **`plugins/claudecode.vim`**.
- **kulala.vim**:
  - Remove the `kulala.parser.jsonpath` requirement from `kulala.nvim` configuration because newer versions no longer need it.
  - Preserve formatter guards for:
    - `application/json`
    - `application/xml`
    - `text/html`
  - External formatter dependencies remain conditional via `executable()` checks, including **jq** and **xmllint** when available.
- **claudecode.vim**:
  - Replace `denops#plugin#register` with `denops#plugin#load`.
  - Delay plugin loading until after the `User DenopsReady` event to avoid channel-not-ready startup errors.
- Startup flow:
  - `Neovim startup -> load plugin config -> apply guarded formatters -> load denops plugin after User DenopsReady`
- Main compatibility goals:
  - Avoid missing `kulala.parser.jsonpath` module errors.
  - Avoid denops startup and channel readiness errors.