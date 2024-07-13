 " -----------------------------------------------------------
 " dein.vim

if has('vim_starting')
  set nocompatible
endif

if has("mac")
	let g:rc_dir = expand('/Users/takets/.vim/dein')  "設定ディレクトリ
	let s:dein_dir = expand('/Users/takets/.vim/dein') " deinディレクトリ
	let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim' " deinリポジトリ
else
	let g:rc_dir = expand('C:\takeda\tools\vim\vim80\dein')  "設定ディレクトリ
	let s:dein_dir = expand('C:\takeda\tools\vim\vim80\dein') " deinディレクトリ
	let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim' " deinリポジトリ
endif

" dein.vim がないときgit clone
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute	'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if has("mac")
	set runtimepath^=/Users/takets/.vim/dein/repos/github.com/Shougo/dein.vim
else
	set runtimepath^=C:\takeda\tools\vim\vim80\dein\repos\github.com\Shougo\dein.vim
endif

" プラグイン設定
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

		call dein#add('Shougo/vimproc', {
					\ 'build': {
					\     'windows': 'tools\\update-dll-mingw',
					\     'cygwin': 'make -f make_cygwin.mak',
					\     'mac': 'make -f make_mac.mak',
					\     'linux': 'make',
					\     'unix': 'gmake'}})

		" プラグインリストの場所
		if has("mac")
				let s:toml      = g:rc_dir . '/dein.toml'
		else
				let s:toml      = g:rc_dir . '/dein.toml'
		endif
    " let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
    " プラグインリストのロード
    call dein#load_toml(s:toml,      {'lazy': 0})
    " call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#end()
    call dein#save_state()
endif
" 未インストールのものをインストール
if dein#check_install()
   call dein#install()
endif
