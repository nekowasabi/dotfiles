
" init setting {{{1

" 環境ごとの設定ディレクトリパスを取得
set runtimepath+=/usr/local/opt/fzf
source ~/.config/nvim/rc/env.vim
source ~/.config/nvim/rc/plugin.vim
" }}}1

" Easy autocmd {{{1
augroup MyVimrc
  autocmd!
augroup END

command! -nargs=* AutoCmd autocmd MyVimrc <args>
" }}}1

" colorscheme {{{1
set termguicolors
colorscheme NeoSolarized
set background=dark

let g:neosolarized_contrast = "low"
let g:neosolarized_visibility = "normal"
let g:neosolarized_vertSplitBgTrans = 1
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0
let g:neosolarized_termBoldAsBright = 1

set t_8f=^[[38;2;%lu;%lu;%lum
set t_8b=^[[48;2;%lu;%lu;%lum

" }}}1

let g:denops#debug = 0 
" let g:denops_server_addr = '127.0.0.1:32123'
" let g:denops_disable_version_check = 0
" let g:denops#deno = '/Users/takets/.deno/bin/deno'

" let g:denops#server#deno_args = get(g:,
"      \ 'denops#server#service#deno_args', [
"      \ '-q',
"      \ '--no-check',
"      \ '--unstable',
"      \ '-A',
"      \ '--inspect-brk',
"      \ ])


call ai_review#config({ 'chat_gpt': { 'model': 'gpt-4' } })

" vim-perplexity
let g:perplexity_token = $PERPLEXITY_TOKEN
let g:perplexity_model = 'llama-2-70b-chat'
let g:perplexity_log_directory = '/tmp/perplexity'

"hell
" lazygit
nnoremap <silent> <leader>lg :LazyGit<CR>

" keybind
nnoremap <silent> <Tab> <C-w>w
nnoremap <silent> <CR> :w!<CR>

" aider.vim
let g:aider_command = 'aider --no-auto-commits --4turbo'
let g:aider_split_direction = 'vsplit'
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 20

" keymap
tnoremap jj <C-\><C-n>

" -----------------------------------------------------------
" lua
lua << EOF
-- local null_ls = require("null-ls")
-- null_ls.setup({
--     sources = {
--       null_ls.builtins.formatting.deno_fmt, 
--       null_ls.builtins.diagnostics.deno_lint,
--     },
-- })
-- vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true } end)

EOF

" END
