" " minimal env {{{1
" if &compatible
"   set nocompatible               " Be iMproved
" endif
" 
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif
" 
" call plug#begin('~/.config/nvim/plugged')
" Plug 'vim-denops/denops.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'
" Plug 'Shougo/ddu.vim'
" Plug 'Shougo/ddu-ui-ff'
" Plug 'Shougo/ddu-kind-file'
" Plug 'Shougo/ddu-filter-matcher_substring'
" Plug 'uga-rosa/ddu-source-lsp'
" Plug 'kuuote/ddu-source-mr'
" Plug 'matsui54/ddu-source-help'
" 
" call plug#end()
" 
" " You must set the default ui.
" " NOTE: ff ui
" " https://github.com/Shougo/ddu-ui-ff
" call ddu#custom#patch_global(#{
" 			\   ui: 'ff',
" 			\ })
" 
" " You must set the default action.
" " NOTE: file kind
" " https://github.com/Shougo/ddu-kind-file
" call ddu#custom#patch_global(#{
" 			\   kindOptions: #{
" 			\     file: #{
" 			\       defaultAction: 'open',
" 			\     },
" 			\   }
" 			\ })
" 
" " Specify matcher.
" " NOTE: matcher_substring filter
" " https://github.com/Shougo/ddu-filter-matcher_substring
" call ddu#custom#patch_global(#{
" 			\   sourceOptions: #{
" 			\     _: #{
" 			\       matchers: ['matcher_substring'],
" 			\     },
" 			\   }
" 			\ })
" 
" let g:ddu_source_lsp_clientName = 'vim-lsp'
" call ddu#custom#patch_global(#{
"       \ kindOptions: #{
"       \   lsp: #{
"       \     defaultAction: 'open',
"       \   },
"       \   lsp_codeAction: #{
"       \     defaultAction: 'apply',
"       \   },
"       \ },
"       \})
" 
" nnoremap <silent> O 
"     \ <Cmd>call ddu#start(#{
"     \ sync: v:true,
"     \ sources: [#{
"     \   name: 'lsp_definition',
"     \ }],
"     \ uiParams: #{
"     \   ff: #{
"     \     immediateAction: 'open',
"     \   },
"     \ }
"     \})<CR>
" 
" " " }}}1

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
let g:denops_server_addr = '127.0.0.1:32123'
" let g:denops_disable_version_check = 0
" let g:denops#deno = '/Users/takets/.deno/bin/deno'

let g:chat_gpt_max_tokens=2000
let g:chat_gpt_model='gpt-4-1106-preview'
let g:chat_gpt_session_mode=1
let g:chat_gpt_temperature = 0.7
let g:chat_gpt_lang = 'Japanese'
" let g:chat_gpt_split_direction = 'vertical'

call ai_review#config({ 'chat_gpt': { 'model': 'gpt-4' } })

let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server', 'deno']

let g:gpt_commit_msg = {}
let g:gpt_commit_msg.api_key = $OPENAI_API_KEY

" vim-dadbod
let g:dbs = {
\  'dev': $DADBOD
\ }

" -----------------------------------------------------------
" lua
lua << EOF
--- for caw's workaround
local M = {}
---@param lnum integer
---@param col integer
---@return boolean
function M.has_syntax(lnum, col)
  local bufnr = vim.api.nvim_get_current_buf()
  local captures = vim.treesitter.get_captures_at_pos(bufnr, lnum - 1, col - 1)
  for _, capture in ipairs(captures) do
    if capture.capture == "comment" then
      return true
    end
  end
  return false
end
---@diagnostic disable-next-line: duplicate-set-field
_G.package.preload.caw = function() return M end

require("mason").setup()

require("lsp_lines").setup()
vim.diagnostic.config({
  virtual_text = false,
})
EOF


" END
