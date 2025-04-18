if g:IsMacNeovim()
  let g:switch_rule = "/Users/takets/.config/nvim/rule_switch.json"
endif
if g:IsMacNeovimInWork()
  " let g:switch_rule = "/Users/ttakeda/.config/nvim/rule_switch.json"
  let g:switch_rule = "/Users/ttakeda/.config/nvim/test_switch.json"
endif
if g:IsWsl()
  let g:switch_rule = "/home/takets/.config/nvim/rule_switch.json"
endif

function! s:SwitchRule()
  execute 'silent! :SwitchFileByRule'
endfunction
command! SwitchRule call s:SwitchRule() 

function! s:OpenSwitchRule()
  execute 'silent! :e ' . g:switch_rule
endfunction
command! OpenSwitchRule call s:OpenSwitchRule()

nnoremap <silent> ,s <Esc>:OpenSwitchRule<CR>
nnoremap <silent> <leader>s <Esc>:SelectSwitchRule<CR>
" inoremap <silent> <C-s> <Esc>:SwitchRule<CR>
nnoremap <silent> <C-s> <Esc>:SwitchRule<CR>
