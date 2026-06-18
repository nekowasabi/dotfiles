---
children_hash: ca4163669c4ca92f13bf45302d8bdd8ba5d9ffbb66011ec208bd9d04c89d0e40
compression_ratio: 0.4345372460496614
condensation_order: 1
covers: [neovim_plugin_startup_fixes.md]
covers_token_total: 886
summary_level: d1
token_count: 385
type: summary
---
# Neovim Plugin Startup Fixes

Structural overview of startup compatibility fixes for two Neovim plugins, with drill-down in **`neovim_plugin_startup_fixes.md`**.

- **Scope:** Fixes apply to `plugins/kulala.vim` and `plugins/claudecode.vim`.
- **Core kulala change:** Remove the `kulala.parser.jsonpath` requirement from `kulala.nvim` configuration because newer versions no longer need it.
- **Formatter behavior preserved:** JSON, XML, and HTML formatters remain guarded by `executable()` checks.
- **Core claudecode change:** Replace `denops#plugin#register` with `denops#plugin#load`.
- **Startup timing requirement:** Defer claudecode loading until after the `User DenopsReady` event to avoid channel-not-ready startup errors.

## Configuration structure
- `plugins/kulala.vim` handles content-type formatters for:
  - `application/json`
  - `application/xml`
  - `text/html`
- `plugins/claudecode.vim` handles denops plugin loading during startup.

## Dependency and compatibility notes
- `kulala.nvim` depends on `jq` and `xmllint` only when available.
- `claudecode.vim` depends on the newer `denops.vim` loading behavior using `denops#plugin#load`.
- The main compatibility goals are:
  - avoid missing `kulala.parser.jsonpath` module errors
  - avoid denops startup/channel readiness errors

## Startup flow
`Neovim startup -> load plugin config -> apply guarded formatters -> load denops plugin after User DenopsReady`

## Related entry
- See **`plugins/battlefront/battlefront_vim.md`** for a related plugin context reference.