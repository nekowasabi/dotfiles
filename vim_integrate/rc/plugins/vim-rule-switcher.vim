if g:IsMacNeovim()
  let g:switch_rule = "/Users/takets/.config/nvim/rule_switch.json"
endif
if g:IsMacNeovimInWork()
  let g:switch_rule = "/Users/ttakeda/.config/nvim/rule_switch.json"
endif
if g:IsWsl()
  let g:switch_rule = "/home/takets/.config/nvim/rule_switch.json"
endif

nnoremap <leader>s :SelectSwitchRule<CR>
inoremap <C-s> <Esc>:SwitchFileByRule<CR>
nnoremap <C-s> :SwitchFileByRule<CR>

