function! g:GetVimConfigRootPath() abort
  " mac gvim
  if has('mac') && has('gui')
    return '/Users/'.$USER.'/.vim/'
  endif
  " mac neovim
  if has('mac') && has('nvim')
    return '/Users/'.$USER.'/.config/nvim/'
  endif
  " windows gvim
  if has('win32') && has('gui')
    return 'c:/tools/vim/vim90/'
  endif
  " windows neovim
  if has('win32') && has('nvim')
    return 'c:¥¥takeda¥¥neovim_config¥¥nvim¥¥'
  endif
  " Linux
  if has('wsl')
    return '/home/'.$USER.'/.config/nvim/'
  endif
  return '/Users/'.$USER.'/.vim/'
endfunction

" 環境フラグ作成
function! g:IsMacGvim() abort
  if has('mac') && has('gui')
    return v:true
  endif
  return v:false
endfunction

function! g:IsMacNeovim() abort
  if has('mac') && has('nvim')
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
  if has('win32') && has('nvim')
    return v:true
  endif
  return v:false
endfunction

function! g:IsLinux() abort
  if !has('mac')  && !has('win32') && has('nvim')
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

function! g:IsVimR() abort
  if has('gui_vimr')
    return v:true
  endif
  return v:false
endfunction

function! g:IsMacNeovimInWezterm() abort
  if g:IsMacNeovim() && index(v:argv, '/Users/takets/wezterm') >= 0
    return v:true
  else
    return v:false
  endif
endfunction

function! g:IsMacNeovimInWork() abort
  if g:IsMacNeovim() && index(v:argv, '/Users/ttakeda/work') >= 0
    return v:true
  else
    return v:false
  endif
endfunction

" 環境ごとのautoloadディレクトリパスを取得
function! g:GetAutoloadPath() abort
  " mac gvim
  if has('mac') && has('gui')
    return '/Users/'.$USER.'/.vim/autoload/'
  endif
  " mac neovim
  if has('mac') && has('cui')
    return '/Users/'.$USER.'/.config/nvim/autoload/'
  endif
  " windows gvim
  if has('win32') && has('gui')
    return 'c:/tools/vim/vim90/autoload/'
  endif
  " windows neovim
  if has('win32') && has('cui')
    return 'c:/takeda/neovim_config/nvim¥¥autoload/'
  endif
  " Linux

  " Linux
  if has('wsl')
    return '/home/'.$USER.'/.config/nvim/autoload/'
  endif

  return '/Users/'.$USER.'/.vim/autoload/'

endfunction

function! g:GetUserName() abort
  return '$USER'
endfunction

if g:IsMacGvim()
  :set viminfo="/Users/'.$USER.'/.viminfo_nvim"
endif

if g:IsWsl()
endif

if g:IsMacNeovimInWezterm()
  " call coc#config('suggest.autoTrigger', 'none')
endif

function! GetDotfilesDirectory() abort
  if g:IsWindowsGvim()
    return 'c:/takeda/repos/dotfiles'
  endif
  if g:IsMacNeovim()
    return '~/repos/dotfiles'
  endif
endfunction

function! g:GetChangelogDirectory() abort
  if g:IsWindowsGvim()
    return 'c:/takeda/repos/changelog'
  endif
  if g:IsMacNeovim() || g:IsWsl()
    return '~/repos/changelog'
  endif
endfunction

if g:IsMacNeovimInWork()
  let g:python3_host_prog = '/opt/homebrew/bin/python3.11'
elseif g:IsMacNeovim()
  let g:python3_host_prog = '/usr/local/opt/python@3.11/bin/python3.11'
endif


