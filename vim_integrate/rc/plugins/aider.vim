if g:IsMacNeovim() || g:IsWsl()
	" sonnet
  let g:aider_command = 'aider --no-auto-commits --chat-language ja --no-stream --architect --model anthropic/claude-3-5-sonnet-20241022 --editor-model anthropic/claude-3-5-sonnet-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'
  " haiku
  " let g:aider_command = 'aider --no-auto-commits --chat-language=ja --no-stream --architect --model anthropic/claude-3-5-sonnet-20241022 --editor-model anthropic/claude-3-5-haiku-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'

  " gpt-4o
  " let g:aider_command = 'aider --no-auto-commits --chat-language ja --no-stream --architect --model  openai/gpt-4o --editor-model openai/gpt-4o --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'


  " vhs用
  " let g:aider_command = 'aider --no-auto-commits --chat-language --stream --chat-mode code --model openai/gpt-4o --editor-model anthropic/claude-3-5-sonnet-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'
  " let g:aider_command = 'aider --no-auto-commits --chat-language --no-stream --architect --model  openai/o1-mini --editor-model anthropic/claude-3-5-sonnet-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'
else
  let g:aider_command = 'aider --no-auto-commits --no-stream --chat-language --architect --model openai/o1-mini --editor-model anthropic/claude-3-5-sonnet-20241022 --cache-prompts --cache-keepalive-pings 6 --suggest-shell-commands'
endif
let g:aider_floatwin_width = 100
let g:aider_floatwin_height = 50
let g:aider_buffer_open_type = 'floating'
" let g:aider_buffer_open_type = 'split'
if g:IsMacNeovimInWezterm()
 let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsWsl()
 let g:convension_path = "~/.config/nvim/plugged/aider.vim/CONVENTION.md"
endif
if g:IsMacNeovimInWork()
 let g:convension_path = $BACKEND_LARAVEL_MAC_DIR . "/laravel/CONVENTION.md"
endif
nnoremap <silent> <leader>ae :AiderRun<CR>
nnoremap <silent> <leader>aR :AiderSilentRun<CR>
nnoremap <silent> <leader>aa :AiderAddIgnoreCurrentFile<CR>:AiderSilentAddCurrentFile<CR>
nnoremap <silent> <leader>aA :AiderAddIgnoreCurrentFile<CR>:AiderAddCurrentFile<CR>
nnoremap <silent> <leader>al :AiderAddIgnoreCurrentFile<CR>:AiderSilentAddCurrentFileReadOnly<CR>
nnoremap <silent> <leader>aL :AiderAddIgnoreCurrentFile<CR>:AiderAddCurrentFileReadOnly<CR>
nnoremap <silent> <leader>aw :AiderAddWeb<CR>
nnoremap <silent> <leader>ap :AiderSendPromptWithInput<CR>
nnoremap <silent> <leader>ax :AiderExit<CR>
nnoremap <silent> <leader>ai :AiderAddIgnoreCurrentFile<CR>
nnoremap <silent> <leader>aI :AiderOpenIgnore<CR>
nnoremap <silent> <leader>ah :AiderHide<CR>
vnoremap <silent> <leader>as :AiderAddSelected<CR>
vmap <leader>av :AiderVisualTextWithPrompt<CR>
nnoremap <leader>av :AiderVisualTextWithPrompt<CR>

let g:aider_additional_prompt = [
      \ "- quoteで囲まれたところに対象コードがある場合は、それを出力コードに置き換えます。",
      \ "- 選択された範囲のコードのみが変更対象であり、その他のコードを変更することは禁止されています。",
      \ "- 編集の説明を日本語で1つ1つステップごとに説明します。",
      \ "- コードはシンプルに保ちます。"
      \]

augroup AiderOpenGroup
  autocmd!
  autocmd User AiderOpen call s:AiderOpenHandler()
augroup END

function! s:AiderOpenHandler() abort
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-x><C-x> <C-\><C-n><C-\><C-n><ESC>:AiderHide<CR>
  tnoremap <C-x><C-c> <Esc> <C-\><C-n><C-w>w
  nnoremap <C-x><C-x> :AiderHide<CR>
endfunction


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
function! s:AiderAddSelected()
    " 選択範囲のテキストを取得
    let l:text = s:get_visual_text()
    if empty(l:text)
      let l:lines = [getline('.')]
    else
      let l:lines = []
      for line in split(l:text, '\n')
          call add(l:lines, "\t" . line)
      endfor
    endif

    let l:lines = map(l:lines, 'substitute(v:val, "[, ]*$", "", "g")')
    let l:lines = map(l:lines, 'substitute(v:val, "^[ ]*", "", "g")')

		" 各行からファイルパスを抽出
		for l:line in l:lines
		  let l:path_pattern = '[~/]\?[a-zA-Z0-9_/.-]\+'
		  let l:matched_path = matchstr(l:line, l:path_pattern)
		  
		  if !empty(l:matched_path)
		    execute "AiderAddFile " . l:matched_path
		  endif
		endfor
endfunction

command! -range -nargs=0 AiderAddSelected call s:AiderAddSelected()

