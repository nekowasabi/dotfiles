" minimum setting {{{1
source ~/.config/nvim/rc/env.vim
if empty(g:GetAutoloadPath() . 'plug.vim')
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(g:GetVimConfigRootPath() . 'plugged')
  Plug 'kdheepak/lazygit.nvim'
call plug#end()

" }}}1

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

" lazygit
nnoremap <silent> <leader>lg :LazyGit<CR>
let g:lazygit_floating_window_use_plenary = 1 " use plenary.nvim to manage floating window if available

" keybind
nnoremap <silent> <Tab> <C-w>w
nnoremap <silent> <CR> :w!<CR>

" aider.vim
let g:aider_command = 'aider --no-auto-commits --4turbo'
let g:aider_split_direction = 'vsplit'
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 20

" keymap
tnoremap ll <C-\><C-n>

autocmd FileType ddu-ff call timer_start(1, {-> ddu#ui#do_action('openFilterWindow')})


call setcellwidths([
  \ [ 0x2500, 0x257f, 1 ],
  \ [ 0x2100, 0x214d, 2 ],
  \ [ 0x26A0, 0x26A0, 2 ],
  \ [ 0x2014, 0x2014, 2 ],
  \ ])

" -----------------------------------------------------------
" lua
lua << EOF
-- Lazygit起動時にESCを無効化する
vim.api.nvim_create_augroup("LazygitKeyMapping", {})
-- TermEnterでは起動されたバッファではなく、起動したバッファが対象になってしまう
local bkey = vim.api.nvim_buf_set_keymap
vim.api.nvim_create_autocmd("TermOpen", {
  group = "LazygitKeyMapping",
  pattern = "*",
  callback = function()
  local filetype = vim.bo.filetype
  -- filetypeにはlazygitが渡る。空文字ではない
  if filetype == "lazygit" then
    -- このkeymapが肝。なんでこれで動くのかは謎
    bkey(0, "t", "<ESC>", "<ESC>", { silent = true })
    -- <C-\><C-n>がNeovimとしてのESC。<ESC>はLazygitが奪う
    bkey(0, "t", "<C-x><C-x>", [[<C-\><C-n>]], { silent = true })
    bkey(0, "t", "jj", "<Down><Down>", { silent = true })
    end
  end,
})

-- local null_ls = require("null-ls")
-- null_ls.setup({
--     sources = {
--       null_ls.builtins.formatting.deno_fmt, 
--       null_ls.builtins.diagnostics.deno_lint,
--     },
-- })
-- vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true } end)

-- require("toggleterm").setup({
-- 
-- })

EOF

" END
