" -----------------------------------------------------------
" neosnippet

if g:IsWindowsGvim()
	let g:neosnippet#snippets_directory = "c:/tools/vim/vim90/mysnippet"
endif

if g:IsMacGvim()
	let g:neosnippet#snippets_directory = "~/.vim/mysnippet"
endif


if g:IsMacNeovim()
	let g:neosnippet#snippets_directory = "~/.config/nvim/mysnippet"
endif

if g:IsWsl()
  let g:neosnippet#snippets_directory = '/home/takets/.config/nvim/mysnippet'
endif

let g:neosnippet#enable_completed_snippet = 1

" imap <C-s>     <Plug>(neosnippet_expand_or_jump)
" smap <C-s>     <Plug>(neosnippet_expand_or_jump)
" xmap <C-s>     <Plug>(neosnippet_expand_target)

" " SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif


 "ビジュアルモードで選択中のテクストを取得する {{{
 function! s:get_visual_text()
   try
     " ビジュアルモードの選択開始/終了位置を取得
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
     return selected
   catch
     return ''
   endtry
 endfunction
 " }}}
function! s:AddSnippetByFileType(snippet, abbr)
    " 選択範囲のテキストを取得
    let l:text = s:get_visual_text()
    if empty(l:text)
        echo "No text selected"
        return
    endif

    " 改行で分割し、各行の先頭にタブを追加
    let l:lines = []
    for line in split(l:text, '\n')
        call add(l:lines, "\t" . line)
    endfor
    " 最後の要素から改行文字を削除
    if len(l:lines) > 0
        let l:lines[-1] = substitute(l:lines[-1], '\n\+$', '', '')
    endif

    " スニペット定義を作成
    let l:snippet_def = ["snippet " . a:snippet, "abbr " . a:abbr] + l:lines + ['']

    " ファイルタイプとパスを取得
    let l:filetype = &filetype
    let l:snippet_file_path = g:neosnippet#snippets_directory.'/'.l:filetype.'.snip'
    let l:snippet_file_path = fnamemodify(l:snippet_file_path, ':p')

    " 既存のスニペットファイルを読み込み、新しいスニペットを追加
    let l:current_content = filereadable(l:snippet_file_path) ? readfile(l:snippet_file_path) : []
    let l:new_content = l:current_content + l:snippet_def

    " ファイルに書き込み
    call writefile(l:new_content, l:snippet_file_path)
    echo "Snippet added successfully"
endfunction

command! -range -nargs=+ AddSnippetByFileType call s:AddSnippetByFileType(<f-args>)
