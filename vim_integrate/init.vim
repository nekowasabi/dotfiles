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

if g:IsMacNeovim()
  let g:switch_rule = "/Users/takets/.config/nvim/rule_switch.json"
endif
if g:IsMacNeovimInMfs()
  let g:switch_rule = "/Users/ttakeda/.config/nvim/rule_switch.json"
endif
if g:IsWsl()
  let g:switch_rule = "/home/takets/.config/nvim/rule_switch.json"
endif

nnoremap <silent> ,j :SwitchFileByRule<CR>
nnoremap <silent> ,J :SwitchFileByRule git<CR>

nnoremap <silent> ,uu :TestNearest<CR>
nnoremap <silent> ,uf :TestFile<CR>
nnoremap <silent> ,ul :TestLast<CR>
nnoremap <silent> ,us :TestSuite<CR>
nnoremap <silent> ,uv :TestVisit<CR>

let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'neovim_sticky',
  \ 'suite':   'basic',
\}

let s:term_win_id = v:null
let s:term_buf_id = v:null

function! OpenTerminalInFloatingWindow()
    " ウィンドウが開いていて有効であれば、閉じる
    if s:term_win_id != v:null && nvim_win_is_valid(s:term_win_id)
        call nvim_win_close(s:term_win_id, v:true)
        let s:term_win_id = v:null
        return
    endif

    " フローティングウィンドウのサイズを定義
    let width = float2nr(&columns * 0.8)
    let height = float2nr(&lines * 0.8)

    " 中央に位置するように計算
    let col = float2nr((&columns - width) / 2)
    let row = float2nr((&lines - height) / 2)

    " ウィンドウオプションを定義
    let opts = {'relative': 'editor', 'width': width, 'height': height, 'row': row, 'col': col, 'style': 'minimal'}

    " バッファがまだ存在しない場合、または有効でない場合に新しいバッファを作成
    if s:term_buf_id == v:null || !nvim_buf_is_valid(s:term_buf_id)
        let s:term_buf_id = nvim_create_buf(v:false, v:true)
    endif
    let s:term_win_id = nvim_open_win(s:term_buf_id, v:true, opts)

    " ターミナルを開始（既に開始されていない場合）
    echo 
    if (&buftype != 'terminal')
      call termopen('bash', {'buffer': s:term_buf_id})
    endif
endfunction
tnoremap <Esc> <C-\><C-n>:close!<CR>

" -----------------------------------------------------------
" lua
lua << EOF

require('Comment').setup()

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

" END
