nnoremap ,p :call print_debug#print_debug()<cr>

let g:print_debug_default = '"{}"'

let g:print_debug_templates = {
      \   'php':         'echo "+++ {}\n";',
      \   'javascript': 'console.log(`+++ {}`);',
      \ }

