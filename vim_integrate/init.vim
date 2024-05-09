" minimum setting {{{1
source ~/.config/nvim/rc/env.vim
if empty(g:GetAutoloadPath() . 'plug.vim')
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd  VimEnter * PlugInstall | source $MYVIMRC
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

if g:IsMacNeovim() || !g:IsMacNeovimInMfs()
  let g:switch_rule = "/Users/takets/.config/nvim/rule_switch.json"
elseif g:IsMacNeovimInMfs()
  let g:switch_rule = "/Users/ttakeda/.config/nvim/rule_switch.json"
elseif g:IsWsl()
  let g:switch_rule = "/home/takets/.config/nvim/rule_switch.json"
endif

nnoremap <silent> ,j :SwitchFileByRule<CR>
nnoremap <silent> ,J :SwitchFileByRule git<CR>

" function! s:enable_coc_for_type()
"   let l:filesuffix_whitelist = ['php', 'ts', 'vim', 'sh', 'py', 'shd', 'json', 'changelog']
"   if index(l:filesuffix_whitelist, expand('%:e')) == -1
"     echo 'ok'
"     let b:coc_enabled = 0
"   endif
" endfunction
" autocmd BufRead,BufNewFile * call s:enable_coc_for_type()

autocmd FileType changelog let g:coc_disabled_sources = ['file']

" -----------------------------------------------------------
" lua
lua << EOF

-- for navic
require("mason").setup()

local navic = require("nvim-navic")

require("lspconfig").vimls.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}

require("lspconfig").denols.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}

require("lspconfig").intelephense.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}

EOF



"vim.keymap.set('n', '<Char-0xAA>', '<cmd>write<cr>', {
"  desc = 'N: Save current file by <command-s>',
"})

" END
