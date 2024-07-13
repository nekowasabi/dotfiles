let g:vimspector_enable_mappings = 'HUMAN'
function! s:SetVimspectorWatch()
  let l:variable = s:get_visual_text()
  exe 'VimspectorWatch '.l:variable
endfunction
command! -range SetVimspectorWatch call s:SetVimspectorWatch() 
vnoremap <silent> <Leader>vw :SetVimspectorWatch<CR>
nnoremap <silent> <Leader>vr :VimspectorReset<CR>

" Set the basic sizes
let g:vimspector_sidebar_width = 200
let g:vimspector_code_minwidth = 150
let g:vimspector_terminal_minwidth = 150

sign define vimspectorBP text=BP texthl=Normal
sign define vimspectorBPDisabled text=DD texthl=Normal
sign define vimspectorPC text=->  texthl=SpellBad

"ビジュアルモードで選択中のテクストを取得する {{{
function! s:get_visual_text()
  try
    let pos = getpos('')
    normal `<
    let start_line = line('.')
    let start_col = col('.')
    normal `>
    let end_line = line('.')
    let end_col = col('.')
    call setpos('.', pos)

    let tmp = @@
    silent normal gvy
    let selected = @@
    let @@ = tmp
    let @@ = ''
    let splitted = split(selected, '\zs')
    return join(splitted[0:-2], '')
  catch
    return ''
  endtry
endfunction
" }}}
