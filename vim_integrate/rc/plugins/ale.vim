let g:ale_completion_enabled = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_delay = 100

" neovimのvirtual textでlintのメッセージを表示
let g:ale_virtualtext_cursor = 0

let g:ale_linters = {
      \   'shd': ['textlint'],
			\   'typescript': ['deno']
      \}
let g:ale_fixers = {
    \   'typescript': ['deno'],
    \}

let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''

" エラー表示の列を常時表示
let g:ale_sign_column_always = 0

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0 
let g:ale_disable_lsp = 1

call ale#linter#Define('shd', {
      \   'name': 'textlint',
      \   'executable': function('ale#handlers#textlint#GetExecutable'),
      \   'command': function('ale#handlers#textlint#GetCommand'),
      \   'callback': 'ale#handlers#textlint#HandleTextlintOutput',
      \})

nnoremap <Leader>[ :<C-u>ALEPrevious<CR>
nnoremap <Leader>] :<C-u>ALENext<CR>

