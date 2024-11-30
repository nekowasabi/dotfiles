let g:ale_completion_enabled = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_delay = 100
let g:ale_fix_on_save = 1

" neovimのvirtual textでlintのメッセージを表示
let g:ale_virtualtext_cursor = 0

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_sign_info = 'ℹ️'

" エラー表示の列を常時表示
let g:ale_sign_column_always = 0

let g:ale_disable_lsp = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0
let g:ale_hover_to_preview = 0
let g:ale_hover_to_floating_preview = 0
let g:ale_set_balloons = 0
let g:ale_virtualtext_cursor = 0
let g:ale_set_balloons_legacy_echo = 0
let g:ale_echo_cursor = 0
let g:ale_echo_delay = 5000
let g:ale_lsp_suggestions = 0

let g:ale_linters = {
      \   'shd': ['textlint'],
			\   'typescript': ['biome'],
			\   'javascript': ['biome'],
		  \   'php': ['php-cs', 'pint', 'intelephense'],
      \}
let g:ale_fixers = {
    \   'typescript': ['biome'],
    \   'javascript': ['biome'],
		\   'php': ['php_cs_fixer', 'pint'],
    \}

" php
if g:IsMacNeovimInWork()
  let g:ale_php_pint_executable = $BACKEND_LARAVEL_MAC_DIR.'/vendor/bin/pint'
  let g:ale_php_cs_fixer_executable = $BACKEND_LARAVEL_MAC_DIR.'/tools/php-cs-fixer/vendor/bin/php-cs-fixer'
elseif g:IsWsl()
  let g:ale_php_pint_executable = '/home/linuxbrew/.linuxbrew/bin/pint'
  let g:ale_php_cs_fixer_executable = '/home/linuxbrew/.linuxbrew/bin/php-cs-fixer'
else
  let g:ale_php_pint_executable = '~/repos/laravel/vendor/bin/pint'
  let g:ale_php_cs_fixer_executable = '~/repos/laravel/tools/php-cs-fixer/vendor/bin/php-cs-fixer'
endif
let g:ale_php_langserver_use_global = 1

call ale#linter#Define('php', {
\   'name': 'intelephense',
\   'lsp': 'stdio',
\   'executable': 'intelephense',
\   'command': '%e --stdio',
\   'project_root': function('ale_linters#php#langserver#GetProjectRoot')
\ })

" biome
if g:IsWsl()
  let g:ale_biome_executable = '/home/linuxbrew/.linuxbrew/bin/biome'
else
  let g:ale_biome_executable = '/usr/local/bin/biome'
endif
let g:ale_biome_use_global = 1

" textlint
call ale#linter#Define('shd', {
      \   'name': 'textlint',
      \   'executable': function('ale#handlers#textlint#GetExecutable'),
      \   'command': function('ale#handlers#textlint#GetCommand'),
      \   'callback': 'ale#handlers#textlint#HandleTextlintOutput',
      \})

nnoremap <Leader>[ :<C-u>ALEPrevious<CR>
nnoremap <Leader>] :<C-u>ALENext<CR>

