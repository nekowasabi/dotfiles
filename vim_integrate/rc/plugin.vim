" -----------------------------------------------------------
" vim-plug.vim

if g:IsMacNeovimInWork()
  let g:enable_coc = v:true
else
  let g:enable_coc = v:true
endif

" CoC: Disable automatic startup - start manually after VimEnter
" This MUST be set before coc.nvim plugin is loaded
let g:coc_start_at_startup = 0

" Start CoC after VimEnter with delay
augroup CocManualStart
  autocmd!
  autocmd VimEnter * call timer_start(100, {-> execute('CocStart')})
augroup END

" Completion system filetype configuration
" CoCのみ使用するfiletype（現在は空）
let g:coc_only_filetypes = [
      \ 'vim',
      \ 'typescript',
      \ 'php',
      \ 'json',
      \ 'go',
      \ 'lua',
      \ 'sh',
      \ 'python',
      \ 'javascript',
      \ 'vue',
      \ 'yaml',
      \ 'blade'
      \ ]

" CMPのみ使用するfiletype
let g:cmp_only_filetypes = [
      \ 'markdown',
      \ 'noice',
      \ 'changelog',
      \ 'text',
      \ 'gitcommit',
      \ 'copilot-chat',
      \ 'AvanteInput'
      \ ]

" 両方とも無効化するfiletype
let g:completion_disabled_filetypes = [
      \ 'ddu-ff',
      \ 'sql'
      \ ]

" CoC を完全に無効化する filetype（プラグインロード前に設定が必要）
" g:cmp_only_filetypes と同期させる
let g:coc_filetype_map = {}
for ft in g:cmp_only_filetypes
  let g:coc_filetype_map[ft] = ''
endfor

" init {{{1
if empty(g:GetAutoloadPath() . 'plug.vim')
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}1

call plug#begin(g:GetVimConfigRootPath() . 'plugged')

" ----- common {{{1
Plug 'AmaiSaeta/closesomewindow.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'Bakudankun/BackAndForward.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim'
Plug 'airblade/vim-rooter'
" Plug 'cohama/lexima.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'haya14busa/vim-edgemotion'
Plug 'itchyny/vim-parenmatch'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-gf-user'
Plug 'kana/vim-repeat'
Plug 'lambdalisue/gina.vim' " lightlineで使っている——ブランチ名を表示に仕様
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-swap'
Plug 'mattn/vim-oauth'
Plug 'mattn/webapi-vim'
Plug 'mmikeww/autohotkey.vim'
Plug 'nekowasabi/foldCC.vim'
Plug 'nekowasabi/nvimdoc-ja'
Plug 'nekowasabi/vim-sayonara'
Plug 'previm/previm', { 'on': 'PrevimOpen' }
Plug 'rhysd/clever-f.vim'
Plug 'rhysd/git-messenger.vim', { 'on': 'GitMessenger' }
Plug 'ryanoasis/vim-devicons'
Plug 't9md/vim-choosewin'
Plug 'termoshtt/curl.vim'
Plug 'thinca/vim-prettyprint' " PPでいい感じに変数の内容を出力
Plug 'thinca/vim-qfreplace'
Plug 'tyru/capture.vim' " コマンドラインの結果をバッファに出力
Plug 'tyru/current-func-info.vim'
Plug 'tyru/open-browser.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'vimpostor/vim-tpipeline'
Plug 'itchyny/vim-highlighturl'
Plug 'atusy/budouxify.nvim'
Plug 'atusy/budoux.lua'
Plug 'dnlhc/glance.nvim'
Plug 'yuki-yano/smart-i.nvim'
Plug 'sirasagi62/tinysegmenter.nvim'
Plug 'hrsh7th/nvim-insx'
Plug 'lambdalisue/vim-fern'
Plug 'lambdalisue/vim-glyph-palette'
Plug 'lambdalisue/vim-fern-renderer-nerdfont'
Plug 'lambdalisue/vim-fern-git-status'
Plug 'yuki-yano/fern-preview.vim'
Plug 'thinca/vim-themis'

" AI
 Plug 'github/copilot.vim'
" Plug 'zbirenbaum/copilot.lua'
Plug 'nekowasabi/aider.vim', { 'on': ['AiderStart', 'AiderSendPromptByCommandline'] }
" Plug 'Robitx/gp.nvim'
Plug 'frankroeder/parrot.nvim', { 'on': 'PrtAppend' }
Plug 'ravitemer/mcphub.nvim', {'do': 'npm install -g mcp-hub@latest'}
Plug 'nekowasabi/cross-channel.nvim'
Plug 'atusy/aibou.nvim'
Plug 'olimorris/codecompanion.nvim'
Plug 'nekowasabi/claudecode.vim'
Plug 'copilotlsp-nvim/copilot-lsp'

" denops
Plug 'hrsh7th/vim-searchx'
Plug 'lambdalisue/kensaku.vim'
Plug 'lambdalisue/mr.vim'
Plug 'lambdalisue/vim-mr'
Plug 'nekowasabi/rtm_deno'
" Plug 'nekowasabi/vim-rtm'
" Plug 'vim-jp/vital.vim'
Plug 'nekowasabi/nudge-two-hats.vim'
Plug 'vim-denops/denops.vim'
Plug 'lambdalisue/vim-deno-cache'
" Plug 'vim-denops/denops-helloworld.vim'
Plug 'vim-denops/denops-shared-server.vim'
Plug 'nekowasabi/hellshake-yano.vim'
Plug 'nekowasabi/ai-edit.vim'
Plug 'nekowasabi/sprit-reading.vim'

" textobj
Plug 'kana/vim-operator-user'
" Plug 'kana/vim-operator-replace'
Plug 'yuki-yano/vim-operator-replace'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-jabraces'
Plug 'kana/vim-textobj-underscore'

Plug 'kana/vim-textobj-user'
Plug 'machakann/vim-textobj-equation'
Plug 'machakann/vim-textobj-functioncall'
Plug 'osyo-manga/vim-textobj-blockwise'
Plug 'osyo-manga/vim-textobj-from_regexp'
Plug 'osyo-manga/vim-textobj-multiblock'
Plug 'osyo-manga/vim-textobj-multitextobj'
Plug 'sgur/vim-textobj-parameter'
Plug 'thalesmello/vim-textobj-methodcall'
Plug 'pocke/vim-textobj-markdown'

" ddc
function! g:SetDdc() abort
	Plug 'Shougo/ddc-source-mocword'
	Plug 'Shougo/ddc-source-rg'
  Plug 'LumaKernel/ddc-source-file'
  Plug 'Shougo/ddc-around'
  Plug 'Shougo/ddc-filter-converter_remove_overlap'
  Plug 'Shougo/ddc-matcher_head'
  Plug 'Shougo/ddc-sorter_rank'
  Plug 'Shougo/ddc-source-cmdline'
  Plug 'Shougo/ddc-source-cmdline-history'
  Plug 'Shougo/ddc-source-copilot'
  Plug 'Shougo/ddc-ui-native'
  Plug 'Shougo/ddc-ui-pum'
  Plug 'Shougo/ddc.vim'
  Plug 'Shougo/neco-vim'
  Plug 'Shougo/pum.vim'
  Plug 'fuenor/im_control.vim'
  Plug 'gamoutatsumi/ddc-emoji'
  Plug 'matsui54/ddc-buffer'
  Plug 'matsui54/denops-popup-preview.vim'
  Plug 'matsui54/denops-signature_help'
  Plug 'tani/ddc-fuzzy'

  if g:IsWindowsGvim()
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'Shougo/ddc-source-codeium'
    Plug 'mattn/vim-lsp-settings'
    Plug 'shun/ddc-source-vim-lsp'
  else
  endif

endfunction

" ddu
function g:SetDdu()
	Plug 'Bakudankun/ddu-filter-matchfuzzy'
	Plug 'Milly/ddu-filter-kensaku'
	Plug 'Shougo/ddc-filter-converter_truncate_abbr'
	Plug 'Shougo/ddu-column-filename'
	Plug 'Shougo/ddu-commands.vim'
	Plug 'Shougo/ddu-source-line'
	Plug 'Shougo/ddu-ui-filer'
	Plug 'kuuote/ddu-source-git_diff'
	Plug 'kuuote/ddu-source-mr'
	Plug 'kyoh86/ddu-filter-converter_hl_dir'
	Plug 'matsui54/ddu-source-command_history'
	Plug 'matsui54/ddu-source-file_external'
	Plug 'nabezokodaikon/ddu-source-file_fd'
	Plug 'nekowasabi/ddu-source-vim-bookmark'
	Plug 'ryota2357/ddu-column-icon_filename'
	Plug 'shun/ddu-source-buffer'
	Plug 'shun/ddu-source-rg'
	Plug 'tamago3keran/ddu-column-devicon_filename'
  Plug 'Shougo/ddu-filter-matcher_ignores'
  Plug 'Shougo/ddu-filter-matcher_substring'
  Plug 'Shougo/ddu-kind-word'
  Plug 'Shougo/ddu-source-action'
  Plug 'Shougo/ddu-kind-file'
  Plug 'Shougo/ddu-source-file'
  Plug 'Shougo/ddu-source-file_rec'
  Plug 'Shougo/ddu-ui-ff'
  " Plug 'Shougo/ddu-ui-ff', { 'commit': 'adf9ab0df52ad7c638cd67f9cff709c19cf768ba' }
  Plug 'Shougo/ddu.vim'
  Plug 'kamecha/ddu-filter-converter_file_icon'
  Plug 'kamecha/ddu-filter-converter_file_info'
  Plug 'matsui54/ddu-source-help'
  Plug 'nekowasabi/ddu-ai-prompt-connecter'
  Plug 'liquidz/ddu-source-custom-list'
  Plug 'kuuote/ddu-filter-fuse'
endfunction

function g:SetCoc()
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
  Plug 'antoinemadec/coc-fzf'
endfunction

" }}}1

" Mac Neovim {{{1
if g:IsMacNeovim() || g:IsWsl()
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'maximbaz/lightline-ale'
  Plug 'dense-analysis/ale' " textlint
	Plug 'pwntester/octo.nvim', { 'on': 'Octo' } " github操作
  Plug 'nvim-lua/plenary.nvim' " luaのライブラリ
  Plug 'nvim-telescope/telescope.nvim' " 普段は使わないけれど、プラグイン連携でたまに使う
  Plug 'elzr/vim-json'
  Plug 'MattesGroeger/vim-bookmarks', { 'on': 'BookmarkToggle' }
  Plug 'tpope/vim-dadbod'  " DBクライアント
  Plug 'kristijanhusak/vim-dadbod-ui', { 'on': 'DBUI' }
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'overcache/NeoSolarized'
  Plug 'rhysd/conflict-marker.vim'
  Plug 'rcarriga/nvim-notify' " 通知
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'HiPhish/rainbow-delimiters.nvim'
  Plug 'shellRaining/hlchunk.nvim'
  Plug 'atusy/treemonkey.nvim'
	Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'on': 'CopilotChat' }
	Plug 'tani/dmacro.nvim'
  Plug 'nekowasabi/vim-rule-switcher'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'Wansmer/treesj'
  Plug 'vim-test/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }
  Plug 'skywind3000/asyncrun.vim'
  Plug 'mfussenegger/nvim-dap'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'theHamsta/nvim-dap-virtual-text'
	Plug 'nvim-telescope/telescope-dap.nvim'
  Plug 'numToStr/Comment.nvim'
  Plug 'monaqa/dial.nvim'
  Plug 'stevearc/dressing.nvim'
  " Plug 'HakonHarnes/img-clip.nvim'
  Plug 'MeanderingProgrammer/render-markdown.nvim'
  Plug 'mistweaverco/kulala.nvim'
  Plug 'gbprod/yanky.nvim'
  Plug 'folke/zen-mode.nvim'
  Plug 'folke/twilight.nvim'
	Plug 'folke/which-key.nvim'
  Plug 'nekowasabi/nudge-two-hats.vim'
  Plug 'PaysanCorrezien/yazi.nvim'
  Plug 'basyura/dsky.vim'
  Plug 'gw31415/mstdn.vim'
  Plug 'gw31415/mstdn-editor.vim'
	" Plug 'tochikuji/cr-remover.nvim'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'napisani/context-nvim'
  Plug 'folke/noice.nvim'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'dmitmel/cmp-cmdline-history'
  Plug 'petertriho/cmp-git'
  Plug 'hrsh7th/cmp-emoji'
  Plug 'hrsh7th/cmp-calc'
  Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'biosugar0/cmp-claudecode'
  Plug 'amarz45/nvim-cmp-buffer-lines'
  Plug 'chrisgrieser/cmp_yanky'
  Plug 'notomo/cmp-neosnippet'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
  Plug 'onsails/lspkind.nvim'
  Plug 'folke/snacks.nvim'
  Plug 'SmiteshP/nvim-navic'
  Plug 'nekowasabi/vim-syntax-tyranoscript'
  Plug 'nvimdev/lspsaga.nvim'
  call g:SetDdu()

  if g:IsWsl()
    Plug 'MunifTanjim/nui.nvim', { 'commit': '8d3bce9764e627b62b07424e0df77f680d47ffdb' }
  else
    Plug 'MunifTanjim/nui.nvim'
  endif

  if g:IsMacNeovimInWork()
    call g:SetCoc()
  elseif g:IsMacNeovim()
    call g:SetCoc()
    Plug 'nekowasabi/street-storyteller.vim'
    Plug 'abzcoding/lsp_lines.nvim'
  elseif g:IsWsl()
    Plug 'Shougo/ddc-source-lsp'
    Plug 'nekowasabi/street-storyteller.vim'
  elseif g:IsMacNeovimInWezterm()
    call g:SetCoc()
    Plug 'nekowasabi/street-storyteller.vim'
  else
    call g:SetCoc()
  endif

	if g:enable_coc
		call g:SetCoc()
	endif
endif

" }}}1

call plug#end()

" setting common {{{1
execute 'source '.g:GetVimConfigRootPath().'rc/general.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/keybind.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/neosnippet.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/folding.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/my-filetype.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/misc.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/colorscheme.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/abbrev.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/clever-f.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/switch.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/openbrowser.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/choosewin.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/easyalign.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-rtm.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-sandwich.vim'
" execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lexima.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/easymotion.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/edgemotion.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/surround.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/sayonara.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/searchx.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/insx.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fern.vim'
" }}}1

" setting Mac Neovim {{{1


if g:IsMacNeovim() || g:IsWsl()
  execute 'source '.g:GetVimConfigRootPath().'rc/mark.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treesitter.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/neosnippet.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-bookmark.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/devicons.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-dadbod.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/denops-gh.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-vue.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gitsign.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddu.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lightline.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ale.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp-lines.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gp.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/telescope.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/hlchunk.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treemonkey.vim'
  " Lazy loading: aider.vim config is loaded on :Aider* command
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/aider.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/dmacro.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treesj.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/nvim-dap.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-rule-switcher.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-test.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/dial.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/kulala.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/BackAndForward.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/noice.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/which-key.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/yazi.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/yanky.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/sns.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/snacks.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/context.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cr-remover.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/render-markdown.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/previm.vim'
  " Lazy loading: copilot-chat.vim config is loaded on :CopilotChat* command
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot-chat.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/codecompanion.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cmp.vim'
  " Lazy loading: octo.vim config is loaded on :Octo* command
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/octo.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cross-channel.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/claudecode.vim'
endif

if g:enable_coc
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'
endif

if g:IsMacNeovimInWork()
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'
endif

" Lazy Plugin Config {{{1
" 遅延読み込みプラグインの設定を、コマンド実行時に読み込む
augroup LazyPluginConfig
  autocmd!
  " CopilotChat.nvim: :CopilotChat* コマンド実行時に設定を読み込み
  autocmd CmdUndefined CopilotChat* call s:LoadCopilotChatConfig()
  " parrot.nvim: :Prt* コマンド実行時に設定を読み込み
  autocmd CmdUndefined Prt* call s:LoadParrotConfig()
  " octo.nvim: :Octo* コマンド実行時に設定を読み込み
  autocmd CmdUndefined Octo* call s:LoadOctoConfig()
  " aider.vim: :Aider* コマンド実行時に設定を読み込み
  autocmd CmdUndefined Aider* call s:LoadAiderConfig()
augroup END

" 各プラグインの設定を読み込む関数
function! s:LoadCopilotChatConfig()
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot-chat.vim'
  autocmd! LazyPluginConfig CmdUndefined CopilotChat*
endfunction

function! s:LoadParrotConfig()
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/parrot.vim'
  autocmd! LazyPluginConfig CmdUndefined Prt*
endfunction

function! s:LoadOctoConfig()
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/octo.vim'
  autocmd! LazyPluginConfig CmdUndefined Octo*
endfunction

function! s:LoadAiderConfig()
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/aider.vim'
  autocmd! LazyPluginConfig CmdUndefined Aider*
endfunction
" }}}1

" highlightyank
let g:highlightedyank_highlight_duration = 100

" END
