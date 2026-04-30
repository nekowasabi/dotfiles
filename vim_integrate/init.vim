" " minimal settings {{{1
" if empty('~/.config/nvim/autoload/' . 'plug.vim')
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim autocmd VimEnter * PlugInstall | source $MYVIMRC endif
" 
" 
" call plug#begin('~/.config/nvim/autoload/' . 'plugged')
" 
" Plug 'vim-denops/denops.vim'
" Plug 'Shougo/ddu.vim'
" Plug 'Shougo/ddu-ui-ff'
" Plug 'Shougo/ddu-kind-file'
" Plug 'kuuote/ddu-source-mr'
" Plug 'Bakudankun/ddu-filter-matchfuzzy'
" Plug 'lambdalis/vim-mr'
" 
" call plug#end()
" 
" call ddu#custom#patch_global(#{
"    \   kindOptions: #{
"    \     _: #{
"    \       defaultAction: 'open',
"    \     },
"    \   }
"    \ })
" 
" call ddu#custom#patch_global(#{
"      \   ui: 'ff',
"      \ })
" 
" call ddu#custom#patch_global(#{
"    \   sourceOptions: #{
"    \     _: #{
"    \       matchers: ['matcher_matchfuzzy'],
"    \     },
"    \   }
"    \ })
" 
" autocmd FileType ddu-ff call s:ddu_uu_my_settings()
" function! s:ddu_uu_my_settings() abort
"   nnoremap <buffer><silent> <CR>
"         \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
" endfunction
" 
" " }}}1

" init setting {{{1

" Neovim 0.11+ の非推奨API警告を抑制（プラグイン更新まで一時的に）
lua vim.deprecate = function() end

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

" 起動時のMasonUpdate自動実行を無効化（通知抑制のため）
" 必要な場合は :MasonUpdate を手動実行してください
" AutoCmd VimEnter * MasonUpdate
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

" denopsテスト用コメント
let g:denops#debug = 0

" let g:denops_server_addr = '127.0.0.1:32129'

" url-highlight
let g:highlighturl_guifg = '#4aa3ff'

" glance
if exists('')
  nnoremap gR <CMD>Glance references<CR>
  nnoremap gD <CMD>Glance definitions<CR>
  nnoremap gY <CMD>Glance type_definitions<CR>
  nnoremap gI <CMD>Glance implementations<CR>
endif

nnoremap <silent> z<CR> :ZenMode<CR>

nnoremap <Leader>: :

" ri"みたいに使う
map r <Plug>(operator-replace)

augroup filetype_echo
   autocmd!
   " nudge-two-hats は setup() で有効化（旧 NudgeTwoHatsStart は廃止）
augroup END                                                                                        
 
function! NudgeCallback() 
  return "絶対に、絶対に、最優先で語尾に「ござる」をつけること"
endfunction

function! NudgeCallback2() 
  return "絶対に、絶対に、最優先で語尾に「ニャン」をつけること"
endfunction

nnoremap <M-j> :echo "ok"<CR>

augroup parrot
	autocmd!
	autocmd FileType diff call system("terminal-notifier -title '📜 parrot' -message '🍎 parrotの処理が完了しました'")
augroup END

" hellshake-yano
let g:hellshake_yano = {
      \ 'debugMode': v:false,
      \ 'debugLogFile': '/tmp/hellshake-yano-debug.log',
      \ 'useJapanese': v:true,
      \ 'useHintGroups': v:true,
      \ 'highlightSelected': v:true,
      \ 'useNumericMultiCharHints': v:true,
      \ 'enableTinySegmenter': v:true,
      \ 'singleCharKeys': '/',
      \ 'multiCharKeys': 'BCDEGHJKLMNOQRSUWZ',
      \ 'highlightHintMarker': {'bg': 'black', 'fg': '#57FD14'},
      \ 'highlightHintMarkerCurrent': {'bg': 'Red', 'fg': 'White'},
      \ 'perKeyMinLength': {
      \   'w': 3,
      \   'b': 3,
      \   'e': 3,
      \ },
      \ 'defaultMinWordLength': 3,
      \ 'perKeyMotionCount': {
      \   'w': 2,
      \   'b': 2,
      \   'e': 2,
      \   'h': 2,
      \   'j': 2,
      \   'k': 2,
      \   'l': 2,
      \ },
			\ 'cancelKeys': ['y', 'p', 'x', 'v', 'a', 'i', 'f', 'F', 't', 'T', '<CR>' , 
			\                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      \ 'defaultMotionCount': 3,
      \ 'japaneseMinWordLength': 5,
      \ 'segmenterThreshold': 3,
      \ 'japaneseMergeThreshold': 3,
      \ 'continuousHintMode': v:false,
      \ 'recenterCommand': 'normal! zz',
      \ 'maxContinuousJumps': 25,
      \ 'directionalHintFilter': v:true,
      \ 'multiWindowMode': v:true,
      \ 'multiWindowMaxWindows': 4,
      \ 'dictionaryPath': '~/.config/nvim/dictionary.yaml',
      \ 'multiWindowExcludeTypes': ['help', 'quickfix', 'terminal', 'popup']
      \ }





nnoremap <silent> ,h :HellshakeYanoToggle<CR> 

"" スクラッチバッファを開く
command! Scratch call <SID>OpenScratchBuffer()

function! s:OpenScratchBuffer()
    " 新しいバッファを作成
    enew
    " スクラッチバッファの設定
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal filetype=markdown
    " バッファ名を設定
    file [Scratch]
endfunction


let g:ai_edit_provider = 'openrouter'
let g:ai_edit_model = 'google/gemini-3.1-flash-lite-preview'
" let g:ai_edit_model = 'openai/gpt-oss-120b'
let g:ai_edit_temperature = 0.7
let g:ai_edit_language = 'ja'
let g:ai_edit_max_tokens = 4096
let g:ai_edit_stream = 1
" let g:ai_edit_provider_preferences = 'Cerebras'

nmap <Leader>gm <Plug>(git-messenger)

" spritz.vim の設定"
let g:spritz_wpm = 350           " 初期WPM (100-1000)
let g:spritz_font_size = 64      " フォントサイズ (px)
let g:spritz_window_width = 600  " ウィンドウ幅 (px)
let g:spritz_window_height = 200 " ウィンドウ高さ (px)
let g:spritz_always_on_top = v:true  " 常に最前面
let g:spritz_show_progress = v:true  " 進捗バー表示

" goyo
nnoremap <silent> <C-w>o <Cmd>Goyo<CR>
let g:goyo_width = 120
let g:goyo_height = '95%'
let g:goyo_linenr = 1

" 行入れ換え
nnoremap <silent> <S-Down> :m .+1<CR>==
nnoremap <silent> <S-Up> :m .-2<CR>==

vnoremap <S-Down> :m '>+1<CR>gv=gv
vnoremap <S-Up> :m '<-2<CR>gv=gv


" -----------------------------------------------------------
" lua

lua << EOF


vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*/src/characters/*.ts", "*/src/settings/*.ts" },
  callback = function()
  if vim.g.coc_global_extensions ~= nil then
    vim.b.coc_enabled = 0
    end
    end,
})

-- parrot.nvim config is now lazy loaded from rc/plugins/parrot.vim

require("nudge-two-hats").setup({
  -- nudge-two-hats: メッセージは設定で注入（OpenRouter / AI 呼び出しは廃止）
  debug = false,

  notification = {
    enabled = true,
    idle_seconds = 180,
    title = "Nudge Two Hats",
    icon = "🎩",
    message = function(ctx)
      local ft = ctx.filetype
      if ft == "text" then
        return vim.fn.NudgeCallback()
      elseif ft == "changelog" then
        return "次に書くべき内容にフォーカスした助言をする。ござる。"
      elseif ft == "javascript" or ft == "typescript" then
        return "リファクタリングか機能追加か、どちらの作業ですか？"
      end
      return "今の作業の目的は何ですか？"
    end,
  },

  virtual_text = {
    enabled = true,
    idle_seconds = 5,
    position = "right_align",
    text_color = "#eee8d5",
    background_color = "#073642",
    message = function(ctx)
      local ft = ctx.filetype
      if ft == "text" then
        return vim.fn.NudgeCallback2()
      elseif ft == "changelog" then
        return "次の一行は？"
      elseif ft == "javascript" or ft == "typescript" then
        return "小さく変更する"
      end
      return nil
    end,
  },
})



function get_git_diff()
  local repo_path = vim.fn.expand("~/repos/changelog")
  local command = string.format("git -C %s log -p -5", repo_path)
  local diff_output = vim.fn.system(command)

  if vim.v.shell_error == 0 and diff_output and diff_output ~= "" then
    local lines_to_insert = vim.split(diff_output, "\n")
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1, cursor_pos[1] - 1, false, lines_to_insert)
    print("Git diff inserted at cursor.")
  else
    local error_message = "Failed to get git diff from " .. repo_path .. "."
    if vim.v.shell_error ~= 0 then
      error_message = error_message .. " Shell error code: " .. vim.v.shell_error
    end
    if diff_output and diff_output ~= "" then
       error_message = error_message .. "\nOutput:\n" .. diff_output
    elseif not diff_output or diff_output == "" then
       error_message = error_message .. " No output from git command."
    end
    local error_lines = vim.split(error_message, "\n")
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1, cursor_pos[1] - 1, false, error_lines)
    print("Error message inserted at cursor.")
  end
end


require("smart-i").setup({
  -- Global settings (defaults)
  enable_i = true,
  enable_I = true,
  enable_a = true,
  enable_A = true,

  -- Filetype-specific settings
  ft_config = {
    -- Disable 'i' and 'I' mappings for markdown files
    markdown = {
      enable_i = true,
      enable_I = true,
    },
    -- Disable all mappings for help files
    help = {
      enable_i = true,
      enable_I = true,
      enable_a = true,
      enable_A = true,
    },
    -- You can add settings for other filetypes here
    -- lua = {
    --   enable_a = false,
    -- }
  }
})

require('Comment').setup()

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "markdown" then
      vim.opt_local.conceallevel = 0  -- markdownではconcealを無効
    end
  end,
})

EOF


" Lua関数get_git_diffをVimコマンドとして呼び出せるようにする
command! GetGitDiff lua get_git_diff()

" END
