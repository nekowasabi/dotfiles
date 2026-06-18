---
title: Neovim Plugin Startup Fixes
summary: Kulala no longer requires kulala.parser.jsonpath; claudecode loads denops plugins with denops#plugin#load after User DenopsReady
tags: []
related: [plugins/battlefront/battlefront_vim.md]
keywords: []
createdAt: '2026-06-17T21:52:09.694Z'
updatedAt: '2026-06-17T21:52:09.694Z'
---
## Reason
Document startup compatibility fixes for plugins/kulala.vim and plugins/claudecode.vim

## Raw Concept
**Task:**
Document Neovim rc startup fixes for plugin compatibility

**Changes:**
- Removed the kulala.parser.jsonpath requirement from kulala.nvim configuration
- Kept JSON, XML, and HTML formatters guarded by executable() checks
- Switched claudecode.vim loading from denops#plugin#register to denops#plugin#load after User DenopsReady

**Files:**
- plugins/kulala.vim
- plugins/claudecode.vim

**Flow:**
Neovim startup -> load plugin config -> apply guarded formatters -> load denops plugin after User DenopsReady

**Timestamp:** 2026-06-17T21:51:42.955Z

## Narrative
### Structure
The configuration is split across plugins/kulala.vim and plugins/claudecode.vim. Kulala defines content-type formatters for application/json, application/xml, and text/html, while claudecode must defer denops plugin loading until the DenopsReady user event.

### Dependencies
Kulala depends on jq and xmllint only when they are executable. Claudecode depends on current denops.vim behavior that uses denops#plugin#load instead of the removed denops#plugin#register.

### Highlights
The key compatibility fix is avoiding a missing kulala.parser.jsonpath module in newer kulala.nvim versions and avoiding channel-not-ready startup errors with denops.

### Examples
JSON uses jq when available, XML uses xmllint for formatting and xpath path resolution when available, and HTML uses xmllint formatting when available.
