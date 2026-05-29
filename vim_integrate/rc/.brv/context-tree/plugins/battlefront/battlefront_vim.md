---
consolidated_at: '2026-05-28T23:16:18.585Z'
consolidated_from: [{date: '2026-05-28T23:16:18.585Z', path: plugins/battlefront/battlefront_vim.abstract.md, reason: 'These three files are redundant representations of the same Battlefront.vim topic. The main markdown file already contains the richest content, while the abstract and overview are compressed summaries of the same task movement, origin tagging, weekly YAML loading, conceal-based tag display, and related facts.'}, {date: '2026-05-28T23:16:18.585Z', path: plugins/battlefront/battlefront_vim.overview.md, reason: 'These three files are redundant representations of the same Battlefront.vim topic. The main markdown file already contains the richest content, while the abstract and overview are compressed summaries of the same task movement, origin tagging, weekly YAML loading, conceal-based tag display, and related facts.'}]
---
Battlefront.vim handles task movement in progress files, injects origin tags when moving lines to Today, loads weekly tasks from external YAML, and uses conceal plus Insert-mode visibility for tags.

## Reason
Document tag display behavior and task movement logic in battlefront.vim

## Raw Concept
**Task:**
Document the battlefront.vim plugin behavior for task movement, origin tagging, weekly task insertion, and tag display handling.

**Changes:**
- Added arrow-key movement for task relocation across Today and header boundaries
- Added origin tag injection and tag-based restoration logic for Today items
- Added weekly task insertion from external YAML data
- Replaced old right-aligned virt_text tag display with conceal-based inline tag handling
- Added/maintained movement mappings for progress files
- Injected @<header_name> origin tags when moving tasks into Today
- Loaded weekly tasks from external YAML instead of hardcoding them
- Added conceal-based tag hiding with Insert-mode visibility refresh

**Flow:**
open progress file -> move tasks with arrow keys -> inject origin tag from source header -> conceal tags in normal mode -> reveal inline tags in Insert mode -> refresh on cursor and text changes

**Timestamp:** 2026-05-28T23:00:48.371Z

**Author:** ByteRover context extraction

**Patterns:**
- `^#\s+Today$` - Detects the Today header used for task placement
- `^#` - Detects markdown headers used as section boundaries
- `\s+@\S+\s*$` - Matches inline origin tags appended to task lines
- `^\s+[-*]\s*\[` - Matches indented checklist child tasks

## Narrative
### Structure
The plugin defines helpers for moving selected tasks to Today, moving them across headers, restoring tasks back to their origin header, and injecting or stripping @<header_name> tags. A separate Tag Display section uses Neovim syntax conceal and autocmds to hide tags normally and show them during editing.

### Dependencies
Relies on Vim/Neovim features such as conceal, syntax match, augroup autocmds, matchaddpos, timer_start, and Python 3 for YAML loading. It also reads weekly task definitions from an external YAML file outside the repository.

### Highlights
Tags are kept visible while editing by reapplying conceallevel=0 during InsertEnter, TextChangedI, CursorMovedI, and ModeChanged. The plugin also preserves backward compatibility by falling back to text-based matching when origin tags are absent.

### Rules
Why: ハードコード ではなく 外部 YAML 読み込み。理由: 公開リポジトリでデータをコードから分離するため
Why: 通常時はタグを隠し、編集時だけ実テキストとして見せる。理由: Today 内の補助タグを視界から外しつつ手編集を妨げないため.
Why: BufWritePost/TextChanged でも旧 virt_text extmark を消し、表示状態を正規化する。

### Examples
A task moved into Today may be tagged like @創作戦線 so its origin header can be restored later, while the tag is concealed during normal browsing.

## Facts
- **tag_display_mode**: battlefront.vim hides tags with conceal during normal mode and shows them inline during Insert mode. [project]
- **tag_display_autocmds**: InsertEnter, TextChangedI, CursorMovedI, ModeChanged, BufWritePost, and TextChanged are used to reapply the tag display state for progress files. [project]
- **progress_buffers**: The progress buffers covered by the tag-display logic are battlefront/progress/private.md and battlefront/progress/work.md. [project]
- **weekly_tasks_source**: battlefront.vim loads weekly tasks from ~/repos/private_dotfiles/battlefront_weekly_tasks.yml when the file is readable and Python 3 is available. [project]

# Consolidated details from abstract and overview
- Battlefront.vim manages task movement in progress files, including moving tasks into Today, across section headers, and back to their origin headers.
- When tasks are moved into Today, the plugin injects an origin tag in the form `@<header_name>` so the source section can be restored later.
- Weekly tasks are loaded from an external YAML file rather than being hardcoded, using Python 3 when available and the file is readable.
- Tag display changed from right-aligned virtual text to conceal-based inline handling: tags are hidden in normal mode and shown during Insert mode.
- The tag visibility behavior is actively refreshed with autocmds such as `InsertEnter`, `TextChangedI`, `CursorMovedI`, `ModeChanged`, `BufWritePost`, and `TextChanged`.
- The document notes compatibility fallback behavior: if origin tags are absent, the plugin can fall back to text-based matching.
- Key regex patterns are documented for detecting Today headers, markdown headers, inline origin tags, and indented checklist child tasks.
- The structure centers on a reason statement, raw concept/change list, a narrative section covering structure/dependencies/highlights/rules/examples, and a facts section with specific buffer and path details.
- Notable entities include Neovim/Vim features like conceal, syntax match, augroup autocmds, matchaddpos, timer_start, and external YAML task definitions at `~/repos/private_dotfiles/battlefront_weekly_tasks.yml`.