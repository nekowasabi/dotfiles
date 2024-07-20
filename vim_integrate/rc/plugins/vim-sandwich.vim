nmap S <Nop>
xmap S <Nop>
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

silent! nmap <unique> Sa <Plug>(operator-sandwich-add)
silent! xmap <unique> Sa <Plug>(operator-sandwich-add)
silent! omap <unique> Sa <Plug>(operator-sandwich-g@)

silent! nmap <unique> Sa <Plug>(operator-sandwich-add)
silent! nmap <unique><silent> Sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> Sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> Sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
silent! nmap <unique><silent> Srb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)


let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
\   {'buns': ['「', '」'], 'nesting': 1, 'input': ['j[', 'j]', 'J']},
\   {'buns': ['『', '』'], 'nesting': 1, 'input': ['j{', 'j}', 'j']},
\ ]

let g:sandwich#recipes += [
      \   {
      \     'buns': ['『', '』'],
      \     'filetype': ['changelog'],
      \     'nesting': 1,
      \     'input': ['j{', 'j}', '[']
      \   },
      \   {
      \     'buns': ['\(', '\)'],
      \     'filetype': ['vim'],
      \     'nesting': 1,
      \   },
      \
      \   {
      \     'buns': ['\%(', '\)'],
      \     'filetype': ['vim'],
      \     'nesting': 1,
      \   },
      \   {
      \     'buns': ['~~', '~~'],
      \     'filetype': ['vim'],
      \     'nesting': 1,
      \   },
      \   {
      \     'buns': ['**', '**'],
      \     'filetype': ['changelog'],
      \     'nesting': 1,
      \   },
      \   {
      \     'external': ["\<Plug>(textobj-parameter-i)", "\<Plug>(textobj-functioncall-a)"],
      \     'noremap': 0,
      \     'kind': ['delete', 'replace', 'query'],
      \     'input': ['f']
      \   },
      \ ]

