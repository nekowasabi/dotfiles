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
Plug 'LeafCage/yankround.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/vimproc.vim'
Plug 'airblade/vim-rooter'
Plug 'cocopon/inspecthi.vim' " colorscheme inspector
Plug 'cohama/lexima.vim'
Plug 'deton/jasegment.vim'
Plug 'deton/jasentence.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'haya14busa/vim-edgemotion'
Plug 'itchyny/vim-gitbranch' " lightlineにブランチ名を表示
Plug 'itchyny/vim-parenmatch'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' 
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-gf-user'
Plug 'kana/vim-repeat'
Plug 'lambdalisue/gin.vim'
Plug 'lambdalisue/gina.vim' " lightlineにブランチ名を表示に仕様
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/vital-ArgumentParser'
Plug 'lambdalisue/vital-Whisky'
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
Plug 'rickhowe/wrapwidth'
Plug 'ryanoasis/vim-devicons'
Plug 't9md/vim-choosewin'
Plug 'termoshtt/curl.vim'
Plug 'thinca/vim-partedit'
Plug 'thinca/vim-prettyprint' " PPでいい感じに変数の内容を出力
Plug 'thinca/vim-qfreplace'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-fugitive'
Plug 'tyru/capture.vim' " コマンドラインの結果をバッファに出力
Plug 'tyru/columnskip.vim' 
Plug 'tyru/current-func-info.vim'
Plug 'tyru/open-browser.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'
Plug 'yuki-yano/lexima-alter-command.vim'
" AI

if g:IsWindowsGvim()
else
  Plug 'github/copilot.vim'
	Plug 'nekowasabi/aider.vim'
  Plug 'Robitx/gp.nvim'
endif

" denops
Plug 'hrsh7th/vim-searchx'
Plug 'lambdalisue/kensaku.vim'
Plug 'lambdalisue/mr.vim'
Plug 'lambdalisue/vim-kensaku-command'
Plug 'lambdalisue/vim-kensaku-search'
Plug 'nekowasabi/rtm_deno'
Plug 'vim-denops/denops-helloworld.vim'
Plug 'vim-denops/denops-shared-server.vim'
Plug 'vim-denops/denops.vim'

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

Plug 'wellle/targets.vim'
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
	Plug 'peacock0803sz/ddu-source-git_stash'
	Plug 'ryota2357/ddu-column-icon_filename'
	Plug 'shun/ddu-source-buffer'
	Plug 'shun/ddu-source-rg'
	Plug 'tamago3keran/ddu-column-devicon_filename'
	Plug 'uga-rosa/ddu-filter-converter_devicon'
  Plug '4513ECHO/ddu-source-emoji'
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
  Plug 'kamecha/ddu-source-jumplist'
  Plug 'matsui54/ddu-source-help'
  Plug 'mikanIchinose/ddu-source-markdown'
  Plug 'nekowasabi/ddu-ai-prompt-connecter'
  Plug 'uga-rosa/ddu-source-lsp'
  Plug 'yuki-yano/ddu-filter-fzf'
endfunction

function g:SetCoc()
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-neco'
  Plug 'antoinemadec/coc-fzf'
endfunction

" }}}1

" Windows Gvim {{{1
if g:IsWindowsGvim()
  Plug 'hail2u/vim-solarized-g'
  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'elzr/vim-json'
  Plug 'andymass/vim-matchup'
  Plug 'lifepillar/vim-solarized8' " colorscheme
  Plug 'vim-voom/VOoM' " outline
  Plug 'dense-analysis/ale' " textlint
  Plug 'maximbaz/lightline-ale'
  Plug 'Shougo/context_filetype.vim'
  Plug 'majutsushi/tagbar'
  Plug 'Shougo/defx.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'kristijanhusak/defx-icons'
  Plug 'MattesGroeger/vim-bookmarks'
  Plug 'dense-analysis/ale'
  Plug 'kyoh86/vim-ripgrep'
  Plug 'gelguy/wilder.nvim'
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
	Plug 'kana/vim-gf-user'
  Plug 'liuchengxu/vista.vim'
	Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
  Plug 'tyru/caw.vim' 
	Plug 'tennashi/gitsign.vim'
  Plug 'monaqa/dps-dial.vim'

	call g:SetDdc()
	call g:SetDdu()
endif
" }}}1

" Mac Neovim {{{1
if g:IsMacNeovim() || g:IsWsl()
  " Plug 'puremourning/vimspector' 
  Plug 'kdheepak/lazygit.nvim'
  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'maximbaz/lightline-ale'
  Plug 'dense-analysis/ale' " textlint
  Plug 'pwntester/octo.nvim' " github操作
  Plug 'nvim-lua/plenary.nvim' " luaのライブラリ
  Plug 'nvim-telescope/telescope.nvim' " 普段は使わないけれど、プラグイン連携でたまに使う
  Plug 'elzr/vim-json'
  Plug 'Shougo/context_filetype.vim'
  Plug 'Shougo/defx.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'MattesGroeger/vim-bookmarks' " fzf-previewと連携して使う（単体でも一応使える）
  Plug 'tpope/vim-dadbod'  " DBクライアント
  Plug 'kristijanhusak/vim-dadbod-ui'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'overcache/NeoSolarized'
  Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }
  Plug 'rhysd/conflict-marker.vim'
  Plug 'folke/lsp-colors.nvim' " lspの色を変更する
  Plug 'MunifTanjim/nui.nvim' " おしゃれなコマンドライン変更
  Plug 'rcarriga/nvim-notify' " 通知（おしゃれだけれどバギー）
  Plug 'folke/trouble.nvim' " diagnoticを一覧表示する
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'nvimtools/none-ls.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'ErichDonGubler/lsp_lines.nvim'
  Plug 'HiPhish/rainbow-delimiters.nvim'
  Plug 'shellRaining/hlchunk.nvim'
  Plug 'rest-nvim/rest.nvim', { 'tag': '1ce984c694345f3801bc656072f9a8dd51286a04' }
  " Plug 'rest-nvim/rest.nvim'
	Plug 'vhyrro/luarocks.nvim'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'atusy/treemonkey.nvim'
  Plug 'uga-rosa/ddc-source-lsp-setup'
  Plug 'neovim/nvim-lspconfig'
  Plug 'vinnymeller/swagger-preview.nvim'
	Plug 'xiyaowong/telescope-emoji.nvim'
	Plug 'CopilotC-Nvim/CopilotChat.nvim', {'branch': 'canary'}
  Plug 'nvim-tree/nvim-web-devicons'
	Plug 'tani/dmacro.nvim'
  Plug 'nekowasabi/vim-rule-switcher'
  Plug 'Shougo/cmdline.vim'
  Plug 'FabijanZulj/blame.nvim'
  Plug 'linrongbin16/gitlinker.nvim'
  Plug 'Al0den/notion.nvim'
  Plug 'williamboman/mason.nvim'
  Plug 'Wansmer/treesj'
  Plug 'stevearc/oil.nvim'
  Plug 'vim-test/vim-test'
  Plug 'skywind3000/asyncrun.vim'
	Plug 'sigmaSd/deno-nvim'
  Plug 'mfussenegger/nvim-dap'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'theHamsta/nvim-dap-virtual-text'
  Plug 'numToStr/Comment.nvim'
  Plug 'monaqa/dial.nvim'
  Plug 'stevearc/dressing.nvim'
  " Plug 'yetone/avante.nvim'
  Plug 'HakonHarnes/img-clip.nvim'
  Plug 'MeanderingProgrammer/render-markdown.nvim'
  Plug 'mistweaverco/kulala.nvim'
	Plug 'heilgar/nvim-http-client'


  call g:SetDdu()

  if g:IsMacNeovimInWork() || g:IsWsl()
    Plug 'gelguy/wilder.nvim'
    Plug 'Shougo/ddc-source-lsp'
    " Plug 'hrsh7th/nvim-cmp'
    " Plug 'hrsh7th/cmp-buffer'
    " Plug 'hrsh7th/cmp-path'
    " Plug 'hrsh7th/cmp-cmdline'
    " Plug 'petertriho/cmp-git'
    call g:SetCoc()
  elseif g:IsWsl()
    Plug 'gelguy/wilder.nvim'
    Plug 'Shougo/ddc-source-lsp'
    call g:SetCoc()
  elseif g:IsMacNeovimInWezterm()
    Plug 'gelguy/wilder.nvim'
    Plug 'Shougo/ddc-source-lsp'
    " Plug 'hrsh7th/nvim-cmp'
    " Plug 'hrsh7th/cmp-buffer'
    " Plug 'hrsh7th/cmp-path'
    " Plug 'hrsh7th/cmp-cmdline'
    " Plug 'petertriho/cmp-git'
    call g:SetCoc()
  else
    Plug 'gelguy/wilder.nvim'
    Plug 'Shougo/ddc-source-lsp'
    call g:SetCoc()
  endif
endif

" }}}1

" Linux {{{1
if g:IsLinux()  && !g:IsWsl()
  Plug 'pwntester/octo.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'elzr/vim-json'
  Plug 'andymass/vim-matchup'
  Plug 'Shougo/context_filetype.vim'
  Plug 'majutsushi/tagbar'
  Plug 'Shougo/defx.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'MattesGroeger/vim-bookmarks'
  Plug 'tpope/vim-dadbod' 
  Plug 'kristijanhusak/vim-dadbod-ui' 
  Plug 'github/copilot.vim'
  Plug 'liuchengxu/vista.vim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
  Plug 'shaunsingh/solarized.nvim'
  Plug 'overcache/NeoSolarized'
  Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }
  Plug 'akinsho/git-conflict.nvim'
  Plug 'folke/lsp-colors.nvim'
  Plug 'stevearc/aerial.nvim'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'rcarriga/nvim-notify'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'folke/trouble.nvim'
  Plug 'EthanJWright/toolwindow.nvim'
  Plug 'akinsho/nvim-toggleterm.lua'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'puremourning/vimspector' 
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'gelguy/wilder.nvim'
	Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
  Plug 'tyru/caw.vim' 
  Plug 'yuki-yano/ai-review.vim'
  Plug 'lambdalisue/gin.vim'
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'

  " coc
  Plug 'lifepillar/vim-solarized8' " colorscheme
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc-neco'
  Plug 'wellle/tmux-complete.vim'
  Plug 'antoinemadec/coc-fzf'
  Plug 'josa42/vim-lightline-coc'
  Plug 'lighttiger2505/sqls.vim'
  Plug 'prabirshrestha/async.vim'
  Plug '2072/PHP-Indenting-for-VIm'
  Plug 'captbaritone/better-indent-support-for-php-with-html'
  Plug 'yaegassy/coc-marksman', {'do': 'yarn install --frozen-lockfile'}

  call g:SetDdu()
endif
" }}}1

" Mac Gvim {{{1
if g:IsMacGvim()
  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'maximbaz/lightline-ale'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'elzr/vim-json'
  Plug 'andymass/vim-matchup'
  Plug 'lifepillar/vim-solarized8' " colorscheme
  Plug 'vim-voom/VOoM' " outline
  Plug 'dense-analysis/ale' " textlint
  Plug 'Shougo/context_filetype.vim'
  Plug 'majutsushi/tagbar'
  Plug 'Shougo/defx.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'kristijanhusak/defx-icons'
  Plug 'MattesGroeger/vim-bookmarks'
  Plug 'kyoh86/vim-ripgrep'
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'github/copilot.vim'
 
  call g:SetDcc()
  call g:SetDdu()

  " coc {{{2
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Plug 'neoclide/coc-neco'
  " Plug 'wellle/tmux-complete.vim'
  " Plug 'antoinemadec/coc-fzf'
  " Plug 'josa42/vim-lightline-coc'
  " Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
  " " }}}2
endif
" }}}1

" Wsl {{{1
" if g:IsWsl()
"   " Plug 'puremourning/vimspector' 
"   Plug 'itchyny/lightline.vim'
"   Plug 'mengelbrecht/lightline-bufferline'
"   Plug 'maximbaz/lightline-ale'
"   Plug 'dense-analysis/ale' " textlint
"   Plug 'pwntester/octo.nvim' " github操作
"   Plug 'nvim-lua/plenary.nvim' " luaのライブラリ
"   Plug 'nvim-tree/nvim-web-devicons'
"   Plug 'nvim-telescope/telescope.nvim' " 普段は使わないけれど、プラグイン連携でたまに使う
"   Plug 'elzr/vim-json'
"   Plug 'andymass/vim-matchup'
"   Plug 'Shougo/context_filetype.vim'
"   Plug 'Shougo/defx.nvim'
"   Plug 'kristijanhusak/defx-git'
"   Plug 'kristijanhusak/defx-icons'
"   Plug 'MattesGroeger/vim-bookmarks' " fzf-previewと連携して使う（単体でも一応使える）
"   Plug 'tpope/vim-dadbod'  " DBクライアント
"   Plug 'kristijanhusak/vim-dadbod-ui' 
"   Plug 'lewis6991/gitsigns.nvim'
"   Plug 'overcache/NeoSolarized'
"   Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }
"   Plug 'akinsho/git-conflict.nvim'
"   Plug 'folke/lsp-colors.nvim' " lspの色を変更する
"   Plug 'MunifTanjim/nui.nvim' " おしゃれなコマンドライン変更
"   Plug 'rcarriga/nvim-notify' " 通知（おしゃれだけれどバギー）
"   Plug 'nvim-tree/nvim-web-devicons'
"   Plug 'folke/trouble.nvim' " diagnoticを一覧表示する
"   " Plug 'adoy/vim-php-refactoring-toolbox'
"   Plug 'dhruvasagar/vim-table-mode'
"   Plug 'nvimtools/none-ls.nvim'
"   Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"   Plug 'kdheepak/lazygit.nvim'
"   Plug 'williamboman/mason.nvim'
"   Plug 'williamboman/mason-lspconfig.nvim'
"   Plug 'ErichDonGubler/lsp_lines.nvim'
"   Plug 'lukas-reineke/indent-blankline.nvim'
"   Plug 'rest-nvim/rest.nvim'
"   Plug 'HiPhish/rainbow-delimiters.nvim'
"   Plug 'gelguy/wilder.nvim'
"   Plug 'atusy/treemonkey.nvim'
"   Plug 'linrongbin16/gitlinker.nvim'
"
"   call g:SetCoc()
"   call g:SetDdu()
"
" endif
" }}}1

" Windows Neovim {{{1
if g:IsWindowsNeovim()
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
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/quickrun.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/easyalign.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-rtm.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/searchx.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-sandwich.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lexima.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gin.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/easymotion.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/edgemotion.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/surround.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/deepl.vim'
execute 'source '.g:GetVimConfigRootPath().'rc/plugins/sayonara.vim'
" }}}1

" setting Mac Neovim {{{1
if g:IsMacNeovim() || g:IsWsl()
  execute 'source '.g:GetVimConfigRootPath().'rc/mark.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/neosnippet.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/defx.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/phpunit.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vimspector.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-bookmark.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/devicons.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-dadbod.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/denops-gh.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-vue.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gitsign.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp-color.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddu.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lightline.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ale.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treesitter.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp-lines.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gp.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot-chat.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/telescope.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/rest.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/hlchunk.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treemonkey.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/swagger-preview.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/null-ls.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/aider.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lazygit.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/dmacro.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/notion.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treesj.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/oil.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/table-mode.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/blame.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gitlinker.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/nvim-dap.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-rule-switcher.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-test.vim'

  if g:IsMacNeovimInWork() || g:IsWsl()
		execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'
    execute 'source '.g:GetVimConfigRootPath().'rc/plugins/wilder.vim'
    execute 'source '.g:GetVimConfigRootPath().'rc/plugins/octo.vim'
		"execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddc.vim'
    " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cmp.vim'
  elseif g:IsMacNeovimInWezterm()
		"execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-lsp.vim'
		execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'
    execute 'source '.g:GetVimConfigRootPath().'rc/plugins/wilder.vim'
    execute 'source '.g:GetVimConfigRootPath().'rc/plugins/octo.vim'
    " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/completion-keybind.vim'
    " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cmp.vim'
		" execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddc.vim'
  else
		execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'
    execute 'source '.g:GetVimConfigRootPath().'rc/plugins/wilder.vim'
    execute 'source '.g:GetVimConfigRootPath().'rc/plugins/octo.vim'
		" execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-lsp.vim'
		" execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddc-source-lsp.vim'
  endif
endif
" }}}1

" setting Windows Gvim {{{1
if g:IsWindowsGvim()
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lightline.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/mark.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/voom.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/defx.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ale.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fern.vim'
	execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddc.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/user-gf.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddu.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-lsp.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/codeium.vim'
	execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-ai.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/leaderf.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gvim-gitsign.vim'

  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-ambiwidth.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/wilder.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/wilder.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/syntax.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vimfiler.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/echodoc.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/calendar.vim'
endif
" }}}1

" setting Windows Neovim {{{1
if g:IsWindowsNeovim()
endif
" }}}1

" setting Linux {{{1
if g:IsLinux() && !g:IsWsl()
  execute 'source '.g:GetVimConfigRootPath().'rc/mark.vim'

  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/neosnippet.vim'

  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fzf-preview.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/defx.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/phpunit.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vimspector.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-bookmark.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/devicons.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-dadbod.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/octo.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fern.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-vue.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-print-debug.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gitsign.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/git-conflict.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp-color.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/trouble.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lualine.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/wilder.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddu.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'

  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/denops-gh.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddc.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/noice.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/aerial.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treesitter.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/nvim-context-vt.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cmp.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vsnip.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp.vim'
endif
" }}}1

" setting Mac Gvim {{{1
if g:IsMacGvim()
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lightline.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/wilder.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/mark.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/voom.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/defx.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ale.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fern.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/user-gf.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/neosnippet.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddc.vim'
  execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddu.vim'
	execute 'source '.g:GetVimConfigRootPath().'rc/plugins/caw.vim'

  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/leaderf.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fzf-preview.vim'
  " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'
endif
" }}}1

" setting Wsl {{{1
" if g:IsWsl()
"   execute 'source '.g:GetVimConfigRootPath().'rc/mark.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/neosnippet.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fzf-preview.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/defx.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/phpunit.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vimspector.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-bookmark.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/devicons.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-dadbod.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fern.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/denops-gh.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-vue.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-print-debug.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/gitsign.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp-color.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddu.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lightline.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ale.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vim-ambiwidth.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vista.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treesitter.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/coc.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/wilder.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/octo.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/copilot.vim'
"   execute 'source '.g:GetVimConfigRootPath().'rc/plugins/caw.vim'
" 
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/git-conflict.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddc.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/fzf-preview.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lualine.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/ddc.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/noice.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/aerial.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/treesitter.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/nvim-context-vt.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/cmp.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/vsnip.vim'
"   " execute 'source '.g:GetVimConfigRootPath().'rc/plugins/lsp.vim'
" endif
" }}}1

" vimproc 
let g:vimproc#download_windows_dll = 1

" highlightyank
let g:highlightedyank_highlight_duration = 100

" END
