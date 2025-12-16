" Test for completion engine switching
" Run with: themis rc/test/completion_test.vim

let s:suite = themis#suite('completion')
let s:assert = themis#helper('assert')

" Test: CoC filetypes should return 'coc'
function! s:suite.coc_filetypes() abort
  let l:coc_filetypes = ['vim', 'typescript', 'php', 'json', 'go', 'lua', 'sh', 'python', 'javascript', 'vue', 'yaml', 'blade']
  for ft in l:coc_filetypes
    call s:assert.equals(completion#get_engine(ft), 'coc', ft . ' should use coc')
  endfor
endfunction

" Test: cmp filetypes should return 'cmp'
function! s:suite.cmp_filetypes() abort
  let l:cmp_filetypes = ['markdown', 'changelog', 'text', 'gitcommit', 'copilot-chat', 'AvanteInput', 'noice']
  for ft in l:cmp_filetypes
    call s:assert.equals(completion#get_engine(ft), 'cmp', ft . ' should use cmp')
  endfor
endfunction

" Test: Disabled filetypes should return 'none'
function! s:suite.disabled_filetypes() abort
  let l:disabled_filetypes = ['ddu-ff', 'sql']
  for ft in l:disabled_filetypes
    call s:assert.equals(completion#get_engine(ft), 'none', ft . ' should be disabled')
  endfor
endfunction

" Test: Unknown filetypes should default to 'cmp'
function! s:suite.default_to_cmp() abort
  call s:assert.equals(completion#get_engine('unknown'), 'cmp', 'unknown should default to cmp')
  call s:assert.equals(completion#get_engine(''), 'cmp', 'empty should default to cmp')
  call s:assert.equals(completion#get_engine('rust'), 'cmp', 'rust should default to cmp')
endfunction
