let g:ale_completion_enabled = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_delay = 1500
let g:ale_fix_on_save = 1
let g:ale_lint_on_insert_leave = 0

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
let g:ale_echo_delay = 0
let g:ale_lsp_suggestions = 0
let g:ale_set_highlights = 0
let g:ale_hover_cursor = 0

let g:ale_linters = {
      \   'shd': ['textlint'],
			\   'typescript': ['deno'],
			\   'javascript': ['eslint'],
		  \   'php': ['pint', 'intelephense'],
  		\   'http': ['kulala_fmt'],
      \   'python': ['flake8'],
      \}
let g:ale_fixers = {
    \   'typescript': ['deno'],
    \   'javascript': ['eslint'],
		\   'php': ['pint'],
    \   'python': ['autopep8', 'black', 'isort'],
    \}

let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_options = '-m flake8'
let g:ale_python_autopep8_executable = 'python3'
let g:ale_python_autopep8_options = '-m autopep8'
let g:ale_python_isort_executable = 'python3'
let g:ale_python_isort_options = '-m isort'
let g:ale_python_black_executable = 'python3'
let g:ale_python_black_options = '-m black'

" php
if g:IsMacNeovimInWork()
  let g:ale_php_pint_executable = $HOME.'/.config/coc/extensions/coc-php-cs-fixer-data/pint'
  let g:ale_php_phpstan_executable = $BACKEND_LARAVEL_DIR.'/vendor/bin/phpstan'
elseif g:IsWsl()
  let g:ale_php_pint_executable = $HOME.'/.config/coc/extensions/coc-php-cs-fixer-data/pint'
else
  let g:ale_php_pint_executable = '~/.config/coc/extensions/coc-php-cs-fixer-data/pint'
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

