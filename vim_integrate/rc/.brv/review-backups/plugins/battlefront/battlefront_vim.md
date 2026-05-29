---
title: Battlefront Vim
summary: Battlefront.vim moves tasks among progress sections, injects origin tags for Today items, inserts weekly routine tasks from YAML, and hides tags in normal mode via conceal while showing them in insert mode.
tags: []
related: []
keywords: []
createdAt: '2026-05-28T22:58:32.426Z'
updatedAt: '2026-05-28T22:58:32.426Z'
---
## Reason
Document battlefront progress navigation, weekly task insertion, and tag display behavior in the Vim plugin.

## Raw Concept
**Task:**
Document the battlefront.vim plugin for moving tasks between progress sections, restoring tasks back to origin sections, inserting weekly routine tasks, and controlling Today tag visibility.

**Changes:**
- Added arrow-key movement for task relocation across Today and header boundaries
- Added origin tag injection and tag-based restoration logic for Today items
- Added weekly task insertion from external YAML data
- Replaced old right-aligned virt_text tag display with conceal-based inline tag handling

**Flow:**
BufEnter progress buffer -> load weekly tasks and bind keys -> move tasks with arrow keys -> inject @origin tags when entering Today -> conceal tags in normal mode -> reveal tags in insert mode

**Timestamp:** 2026-05-28T22:58:01.595Z

**Author:** ByteRover context extraction

**Patterns:**
- `^#\s+Today$` - Detects the Today header used for task placement
- `^#` - Detects markdown headers used as section boundaries
- `\s+@\S+\s*$` - Matches inline origin tags appended to task lines
- `^\s+[-*]\s*\[` - Matches indented checklist child tasks

## Narrative
### Structure
The plugin is organized around movement functions, origin-tag helper functions, weekly task loading, and a separate tag-display augroup for battlefront/progress markdown buffers. Movement logic distinguishes between single-line tasks, child tasks, and multi-line selections, and it uses the Today section as the main staging area.

### Dependencies
Requires Neovim for the namespace-based tag clearing path; it also depends on Python 3 plus PyYAML to load the external weekly task YAML file. The progress buffers are expected at battlefront/progress/private.md and battlefront/progress/work.md.

### Highlights
Tasks can be moved to the bottom, around markdown headers, or into Today while preserving provenance. Tags are hidden in normal mode with conceal and shown in insert mode, which keeps the Today list readable while still editable. Weekly routine tasks are auto-inserted without duplication.

### Rules
Why: ハードコード ではなく 外部 YAML 読み込み。理由: 公開リポジトリでデータをコードから分離するため
Why: 通常時はタグを隠し、編集時だけ実テキストとして見せる。理由: Today 内の補助タグを視界から外しつつ手編集を妨げないため.
Why: BufWritePost/TextChanged でも旧 virt_text extmark を消し、表示状態を正規化する。

### Examples
Example mappings: <Down> moves a selected task block to the end of the file; <Up> returns a Today item to the section identified by its @tag, or falls back to matching the original text if no tag exists.

## Facts
- **weekly_tasks_source**: battlefront.vim reads weekly tasks from ~/repos/private_dotfiles/battlefront_weekly_tasks.yml when filereadable() is true and has("python3") is available. [project]
- **weekly_tasks_default**: The plugin initializes g:battlefront_weekly_tasks with {"work": {}, "private": {}}. [project]
- **progress_key_scope**: Progress navigation keys are bound in battlefront/progress/private.md and battlefront/progress/work.md on BufEnter. [convention]
- **key_down_action**: <Down> moves the current line or selection to the end of the file. [convention]
- **key_left_action**: <Left> moves the current line or selection above the previous # header. [convention]
- **key_right_action**: <Right> moves the current line or selection below the next # header. [convention]
- **key_up_action**: <Up> moves the current line or selection to just below # Today and deduplicates if already present. [convention]
- **routine_task_normalization**: Routine tasks inserted by BattlefrontWeeklyTasks are normalized to a checklist line and appended with @routine when missing. [project]
- **tag_conceal_pattern**: Battlefront tag display uses syntax conceal for /\s+@\S+\s*$/ with conceallevel=2 and concealcursor=n in normal mode. [project]
- **insert_mode_tag_visibility**: InsertEnter on battlefront/progress/*.md clears the tag display namespace and sets conceallevel=0 so the inline tag is visible while editing. [project]
- **tag_display_refresh_events**: BufWritePost and TextChanged on battlefront/progress/*.md call BattlefrontApplyTagDisplay to clear old virt_text extmarks and normalize display. [project]
- **deprecated_tag_display**: The old right-aligned virt_text display is no longer used; the namespace is cleared instead. [project]
- **restore_strategy**: Task restoration logic prefers origin tags such as @header_name and falls back to matching stripped line text for backward compatibility. [project]
- **today_section_detection**: The Today section is detected by a line matching ^# Today and weekly task insertion occurs directly below that header. [project]
