let g:lsp_diagnostics_signs_error = {'text': ''}
let g:lsp_diagnostics_signs_warning = {'text': ''}
let g:lsp_diagnostics_signs_hint = {'text': ''}
" let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_enabled = 1

function! s:on_lsp_buffer_enabled() abort
  setlocal signcolumn=yes
  let g:lsp_diagnostics_signs_enabled  = 1
  " nmap <buffer> <Leader>cd <plug>(lsp-definition)
  nmap <buffer> <Leader>cs <plug>(lsp-workspace-symbol-search)
  nmap <buffer> <Leader>cn <plug>(lsp-rename)
  nmap <buffer> <Leader>c[ <plug>(lsp-previous-diagnostic)
  nmap <buffer> <Leader>c] <plug>(lsp-next-diagnostic)
  nmap <buffer> <Leader>ck <plug>(lsp-hover)

  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000

  autocmd! BufWritePre *.js,*.ts,*.php call execute('LspDocumentFormatSync')

  " refer to doc to add more commands
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


