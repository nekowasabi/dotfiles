" " minimux setting {{{1
" if empty(glob('~/.vim/autoload/plug.vim'))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif
" 
" call plug#begin('~/.vim/plugged')
"   Plug 'vim-denops/denops.vim'
"   Plug 'Shougo/ddc.vim'
"   Plug 'Shougo/ddc-ui-native'
"   Plug 'Shougo/ddc-around'
"   Plug 'Shougo/ddc-matcher_head'
"   Plug 'Shougo/ddc-sorter_rank'
"   Plug 'Shougo/ddc-converter_remove_overlap' 
"   Plug 'Shougo/ddc-rg'
"   Plug 'shun/ddc-vim-lsp'
"   Plug 'fuenor/im_control.vim'
"   Plug 'matsui54/ddc-buffer'
"   Plug 'Shougo/pum.vim'
"   Plug 'Shougo/ddc-ui-pum'
"   Plug 'Shougo/neco-vim'
"   Plug 'prabirshrestha/vim-lsp'
"   Plug 'mattn/vim-lsp-settings'
"   Plug 'matsui54/denops-signature_help'
"   Plug 'LumaKernel/ddc-source-file'
"   Plug 'tani/ddc-fuzzy'
"   Plug 'matsui54/denops-popup-preview.vim'
"   Plug 'Shougo/ddc-source-cmdline-history'
"   Plug 'Shougo/ddc-source-cmdline'
"   Plug 'LumaKernel/ddc-source-file'
"   Plug 'Shougo/ddc-source-mocword'
"   Plug 'gamoutatsumi/ddc-emoji'
"   Plug 'cohama/lexima.vim'
" 
" 
" call plug#end()
" filetype plugin indent on
" syntax enable
" 
" 
" call ddc#custom#patch_global('ui','pum')
" call ddc#custom#patch_global('sources', ['around', 'buffer', 'neosnippet', 'vim-lsp', 'cmdline-history', 'file', 'emoji'])
" call popup_preview#enable()
" 
" " Add matching patterns
" call ddc#custom#patch_global('keywordPattern', '[a-zA-Z_:]\w*')
" 
" " Change source options
" call ddc#custom#patch_global('sourceOptions', {
"       \ 'emoji': {
"       \	  'mark': 'emoji',
"       \	  'matchers': ['emoji'],
"       \	  'sorters': [],
"       \	  },
"       \ })
" 
" " Change source options
" call ddc#custom#patch_global('sourceOptions', #{
"       \   around: #{ mark: 'A' },
"       \ })
" call ddc#custom#patch_global('sourceParams', #{
"       \   around: #{ maxSize: 500 },
"       \ })
" 
" 
" 
" call ddc#custom#patch_global('sourceOptions', #{
"   \   _: #{
"   \     matchers: ['matcher_fuzzy'],
"   \     sorters: ['sorter_fuzzy'],
"   \     converters: ['converter_fuzzy'],
" 	\     ignoreCase: v:true
"   \   },
"   \ })
" 
" call ddc#custom#patch_global('sources', ['vim-lsp'])
" inoremap <silent><expr> <TAB>
"      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
"      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
"      \ '<TAB>' : ddc#map#manual_complete()
" inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
" inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
" inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
" inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
" inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
" 
" " inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
" inoremap <expr><CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : lexima#expand('<CR>', 'i')
" " inoremap <silent><expr> <TAB>
" "	\ pumvisible() ? "\<C-n>" :
" "	\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
" "	\ "\<TAB>" : ddc#manual_complete()
" " 
" " inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"
" 
" set completeopt=noinsert
" 
" let g:signature_help_config = #{
"       \ contentsStyle: "full",
"       \ viewStyle: "floating"
"       \ }
" 
" call signature_help#enable()
" 
" " if you use with vim-lsp, disable vim-lsp's signature help feature
" let g:lsp_signature_help_enabled = 0
" 
" " Use ddc.
" call ddc#enable()
" 
" call ddc#custom#patch_global(#{
"       \   ui: 'pum',
"       \   autoCompleteEvents: [
"       \     'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged',
"       \   ],
"       \   cmdlineSources: {
"       \     ':': ['cmdline', 'cmdline-history', 'around'],
"       \     '/': ['around'],
"       \     '?': ['around'],
"       \   },
"       \ })
" nnoremap <Space>:       <Cmd>call CommandlinePre()<CR>:
" nnoremap /       <Cmd>call CommandlinePre()<CR>:SearchxForward<CR>
" nnoremap ?       <Cmd>call CommandlinePre()<CR>:SearchxBackrward<CR>
" 
" function CommandlinePre() abort
"   " cnoremap <expr> <Tab>
"   "      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
"   "      \ ddc#manual_complete()
"   cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
"   cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
"   cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
"   cnoremap <expr><CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" 
"   xnoremap <expr> <Tab>
"        \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
"        \ ddc#manual_complete()
"   xnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
"   xnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
"   xnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
"   xnoremap <expr><CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" 
" 
" 
"   autocmd User DDCCmdlineLeave ++once call CommandlinePost()
" 
"   " Enable command line completion for the buffer
"   call ddc#enable_cmdline_completion()
" endfunction
" function CommandlinePost() abort
"   silent! cunmap <Tab>
"   silent! cunmap <S-Tab>
"   silent! cunmap <C-n>
"   silent! cunmap <C-p>
"   silent! cunmap <C-y>
"   silent! cunmap <C-e>
"   silent! xunmap <Tab>
"   silent! xunmap <S-Tab>
"   silent! xunmap <C-n>
"   silent! xunmap <C-p>
"   silent! xunmap <C-y>
"   silent! xunmap <C-e>
" endfunction
" 
" 
" 
" 
" " }}}1

" init settings {{{1
if has('python3_host_prog')
endif

let g:python3_host_prog = "/usr/local/Cellar/python@3.11/3.11.3/bin/python3"

let g:denops#deno = '/Users/takets/.deno/bin/deno'

" set runtimepath^=~/dps-helloworld
" set runtimepath+=~/.vim/plugged/rtm_deno
set runtimepath+=/usr/local/opt/fzf
" let g:denops_server_addr = '127.0.0.1:32123'
let g:denops_disable_version_check = 1

" 環境ごとの設定ディレクトリパスを取得
function! g:GetVimConfigRootPath() abort
  " mac gvim
  if has('mac') && has('gui')
    return '/Users/takets/.vim/'
  endif
  " mac neovim
  if has('mac') && has('cui')
    return '/Users/takets/.config/nvim/'
  endif
  " windows gvim
  if has('win32') && has('gui')
    return 'c:¥¥takeda¥¥tools¥¥vim¥¥'
  endif
  " windows neovim
  if has('win32') && has('cui')
    return 'c:¥¥takeda¥¥neovim_config¥¥nvim¥¥'
  endif
  " Linux
  if has('wsl')
    return '/home/takets/.config/nvim/'
  endif
  return '/home/kf/.config/nvim/'

endfunction

" 環境フラグ作成
function! g:IsMacGvim() abort
  if has('mac') && has('gui')
    return v:true
  endif
  return v:false
endfunction

function! g:IsMacNeovim() abort
  if has('mac') && has('cui')
    return v:true
  endif
  return v:false
endfunction

function! g:IsWindowsGvim() abort
  if has('win32') && has('gui')
    return v:true
  endif
  return v:false
endfunction

function! g:IsWindowsNeovim() abort
  if has('win32') && has('cui')
    return v:true
  endif
  return v:false
endfunction

function! g:IsLinux() abort
  if !has('win32') && has('cui')
    return v:true
  endif
  return v:false
endfunction

function! g:IsWsl() abort
  if has('wsl')
    return v:true
  endif
  return v:false
endfunction

" 環境ごとのautoloadディレクトリパスを取得
function! g:GetAutoloadPath() abort
  " mac gvim
  if has('mac') && has('gui')
    return '/Users/takets/.vim/autoload/'
  endif
  " mac neovim
  if has('mac') && has('cui')
    return '/Users/takets/.config/nvim/autoload/'
  endif
  " windows gvim
  if has('win32') && has('gui')
    return 'c:/takeda/tools/vim/autoload/'
  endif
  " windows neovim
  if has('win32') && has('cui')
    return 'c:/takeda/neovim_config/nvim¥¥autoload/'
  endif
  " Linux
  if has('wsl')
    return '/home/takets/.config/nvim/autoload/'
  endif

  return '/home/kf/.config/nvim/autoload/'
endfunction

source ~/.vim/rc/plugin.vim

function Init() abort
		redraw
endfunction

call Init()

" deno
" let g:denops#deno ="/Users/takets/.deno/bin/deno"
" let g:denops#debug = 0

" }}}1

" Easy autocmd {{{1
augroup MyVimrc
  autocmd!
augroup END

command! -nargs=* AutoCmd autocmd MyVimrc <args>
" }}}1

autocmd FileType voomtree noremap <C-o> <CR><Tab><C-l>

call MarkdownSetupFolds()

 " END
