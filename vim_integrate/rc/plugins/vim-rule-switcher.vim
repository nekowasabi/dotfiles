if g:IsMacNeovim()
  let g:switch_rule = "/Users/takets/.config/nvim/rule_switch.json"
endif
if g:IsMacNeovimInWork()
  let g:switch_rule = "/Users/ttakeda/.config/nvim/rule_switch.json"
endif
if g:IsWsl()
  let g:switch_rule = "/home/takets/.config/nvim/rule_switch.json"
endif

" nnoremap <silent> ,j :SwitchFileByRule<CR>
nnoremap <silent> ,J :SwitchFileByRule git<CR>
nnoremap <silent> ,j :SwitchFuzzyRule<CR>
inoremap <C-s> <Esc>:SwitchFuzzyRule<CR>
nnoremap <C-s> :SwitchFuzzyRule<CR>

command! SwitchFuzzyRule call s:switch_fuzzy() 
function! s:switch_fuzzy()
  let l:now_file = expand('%')
  try
    execute('SwitchFileByRule')
  catch
    echo 'Error: SwitchFileByRule command not found.'
  endtry
  if l:now_file == expand('%')
    execute('SwitchFileByRule git')
  endif
  return
endfunction


