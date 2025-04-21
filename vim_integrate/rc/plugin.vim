" -----------------------------------------------------------
" vim-plug.vim

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
Plug 'cohama/lexima.vim'
" Plug 'deton/jasegment.vim'
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
Plug 'previm/previm'
Plug 'rhysd/clever-f.vim'
Plug 'rhysd/git-messenger.vim'
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

" AI
Plug 'github/copilot.vim'
Plug 'nekowasabi/aider.vim'
Plug 'Robitx/gp.nvim'
Plug 'ravitemer/mcphub.nvim', {'do': 'npm install -g mcp-hub@latest'}
Plug 'azorng/goose.nvim'
Plug 'nekowasabi/cross-channel.nvim'
Plug 'augmentcode/augment.vim'
" Plug 'frankroeder/parrot.nvim'

" denops
Plug 'hrsh7th/vim-searchx'
Plug 'lambdalisue/kensaku.vim'
Plug 'lambdalisue/mr.vim'
Plug 'lambdalisue/vim-mr'
Plug 'nekowasabi/rtm_deno'
Plug 'nekowasabi/nudge-two-hats.vim'
Plug 'vim-denops/denops.vim'
" Plug 'vim-denops/denops-helloworld.vim'
Plug 'vim-denops/denops-shared-server.vim'

" textobj
Plug 'kana/vim-operator-user'
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
  Plug 'Shougo/ddu-kind-file'
  Plug 'Shougo/ddu-kind-word'
  Plug 'Shougo/ddu-source-action'
  Plug 'Shougo/ddu-source-file'
  Plug 'Shougo/ddu-source-file_rec'
  Plug 'Shougo/ddu-ui-ff'
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
	" Plug 'pwntester/octo.nvim', {'commit': '9ccdfccb4ae5f2d5e6c8df01f0298a4bdfb4999e'} " github操作
	Plug 'pwntester/octo.nvim' " github操作
  Plug 'nvim-lua/plenary.nvim' " luaのライブラリ
  Plug 'nvim-telescope/telescope.nvim' " 普段は使わないけれど、プラグイン連携でたまに使う
  Plug 'elzr/vim-json'
  Plug 'MattesGroeger/vim-bookmarks'
  Plug 'tpope/vim-dadbod'  " DBクライアント
  Plug 'kristijanhusak/vim-dadbod-ui'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'overcache/NeoSolarized'
  Plug 'rhysd/conflict-marker.vim'
  Plug 'MunifTanjim/nui.nvim' " おしゃれなコマンドライン変更
  Plug 'rcarriga/nvim-notify' " 通知
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'HiPhish/rainbow-delimiters.nvim'
  Plug 'shellRaining/hlchunk.nvim'
  Plug 'atusy/treemonkey.nvim'
	Plug 'CopilotC-Nvim/CopilotChat.nvim'
	Plug 'tani/dmacro.nvim'
  Plug 'nekowasabi/vim-rule-switcher'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'Wansmer/treesj'
  Plug 'vim-test/vim-test'
  Plug 'skywind3000/asyncrun.vim'
  Plug 'mfussenegger/nvim-dap'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'theHamsta/nvim-dap-virtual-text'
	Plug 'nvim-telescope/telescope-dap.nvim'
  Plug 'numToStr/Comment.nvim'
  Plug 'monaqa/dial.nvim'
  Plug 'stevearc/dressing.nvim'
  Plug 'olimorris/codecompanion.nvim'
  Plug 'HakonHarnes/img-clip.nvim'
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
	Plug 'tochikuji/cr-remover.nvim'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'napisani/context-nvim'
  Plug 'folke/noice.nvim'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'petertriho/cmp-git'
  Plug 'hrsh7th/cmp-emoji'
  Plug 'hrsh7th/cmp-calc'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'amarz45/nvim-cmp-buffer-lines'
  Plug 'chrisgrieser/cmp_yanky'
  Plug 'notomo/cmp-neosnippet'
  Plug 'onsails/lspkind.nvim'
  Plug 'folke/snacks.nvim'
  Plug 'SmiteshP/nvim-navic'
  Plug 'nekowasabi/vim-syntax-tyranoscript'

  call g:SetDdu()

  if g:IsMacNeovimInWork() || g:IsWsl()
    call g:SetCoc()
  elseif g:IsMacNeovim()
    call g:SetCoc()
    Plug 'abzcoding/lsp_lines.nvim'
    Plug 'augmentcode/augment.vim'
  elseif g:IsWsl()
    Plug 'Shougo/ddc-source-lsp'
    call g:SetCoc()
  elseif g:IsMacNeovimInWezterm()
    call g:SetCoc()
  else
    Plug 'gelguy/wilder.nvim'
    Plug 'Shougo/ddc-source-lsp'
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
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/searchx.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-sandwich.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lexima.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/easymotion.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/edgemotion.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/surround.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/sayonara.vim'
" }}}1

" setting Mac Neovim {{{1
if g:IsMacNeovim() || g:IsWsl()
  execute 'source '.g:GetVimConfigRootPath().'rc/mark.vim'
   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treesitter.vim'

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
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp-lines.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gp.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/telescope.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/hlchunk.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treemonkey.vim'
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
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cr-remover.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/render-markdown.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/previm.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot-chat.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/codecompanion.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cmp.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/octo.vim'
endif
" }}}1

" highlightyank
let g:highlightedyank_highlight_duration = 100

" END
