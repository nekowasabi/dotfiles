" -----------------------------------------------------------
" TweetVim

if has('win32') || has('win64')
 let g:openbrowser_browser_commands = [
 \   {
 \       "name": "C:\\Program\ Files\ (x86)\\Google\\Chrome\\Application\\chrome.exe",
 \       "args": ["{browser}", "{uri}"]
 \   }
 \ ]
endif


" 1ページのツイート数
let g:tweetvim_tweet_per_page = 200

" スクリーンネームを表示
let g:tweetvim_display_username = 1

let g:tweetvim_buffer_name = 'Twitter'

let g:tweetvim_include_rts    = 1

" 時間の表示
let g:tweetvim_display_time   = 1

" 投稿時は非同期
let g:tweetvim_async_post = 1

" キャッシュサイズ
let g:tweetvim_cache_size = 0

let g:tweetvim_display_icon = 0

let g:tweetvim_empty_separator = 1

nnoremap <Leader>S :<C-u>TweetVimSay<CR>

augroup TweetVimSetting
    autocmd!
    " マッピング
    " 挿入・通常モードでsayバッファを閉じる
    autocmd FileType tweetvim_say nnoremap <buffer><silent><C-g>    :<C-u>q!<CR>
    autocmd FileType tweetvim_say inoremap <buffer><silent><C-g>    <C-o>:<C-u>q!<CR><Esc>
    " 各種アクション
    autocmd FileType tweetvim     nnoremap <buffer>S                :<C-u>TweetVimSay<CR>
    autocmd FileType tweetvim     nnoremap <buffer>s                :<C-u>call <SID>tweetvim_easymotion()<CR>
		autocmd FileType tweetvim     nnoremap <buffer><Leader><Leader>		          :<C-u>Unite -silent buffer file_mru<CR>
    autocmd FileType tweetvim     nnoremap <buffer>m                :<C-u>TweetVimMentions<CR>
    autocmd FileType tweetvim     nmap     <buffer>c                <Plug>(tweetvim_action_in_reply_to)
    autocmd FileType tweetvim     nnoremap <buffer>t                :<C-u>Unite tweetvim -no-start-insert -quick-match<CR>
    autocmd FileType tweetvim     nmap     <buffer><Leader>F        <Plug>(tweetvim_action_remove_favorite)
		autocmd FileType tweetvim     nmap <silent> <buffer> <leader>f  <Plug>(tweetvim_action_favorite)
		autocmd FileType tweetvim     nmap     <buffer><Leader>d        <Plug>(tweetvim_action_remove_status)
		autocmd FileType tweetvim     nmap <silent> <buffer> <leader>r  <Plug>(tweetvim_action_retweet)
		autocmd FileType tweetvim     nmap <silent> <buffer> <leader>Q  <Plug>(tweetvim_action_qt)
    " リロード
    autocmd FileType tweetvim     nmap     <buffer><Tab>            <Plug>(tweetvim_action_reload)
    " ページの先頭に戻ったときにリロード
    autocmd FileType tweetvim     nmap     <buffer><silent>gg       gg<Plug>(tweetvim_action_reload)
    " ページ移動を ff/bb から f/b に
    autocmd FileType tweetvim     nmap     <buffer>f                <Plug>(tweetvim_action_page_next)
    autocmd FileType tweetvim     nmap     <buffer>b                <Plug>(tweetvim_action_page_previous)
    " favstar や web UI で表示
    " autocmd FileType tweetvim     nnoremap <buffer><Leader><Leader> :<C-u>call <SID>tweetvim_favstar()<CR>
    " ブラウザで対象ユーザのホームを開く
    autocmd FileType tweetvim     nnoremap <buffer><Leader>u        :<C-u>call <SID>tweetvim_open_home()<CR>
    " 縦移動（カーソルを常に中央にする）
    autocmd FileType tweetvim     nnoremap <buffer><silent>j        :<C-u>call <SID>tweetvim_vertical_move("gj")<CR>
    autocmd FileType tweetvim     nnoremap <buffer><silent>k        :<C-u>call <SID>tweetvim_vertical_move("gk")<CR>
    " 不要なマップを除去
    autocmd FileType tweetvim     nunmap   <buffer>ff
    autocmd FileType tweetvim     nunmap   <buffer>bb
    " " tweetvim バッファに移動したときに自動リロード
    " autocmd BufEnter * call <SID>tweetvim_reload()
augroup END

" セパレータを飛ばして移動する
" ページの先頭や末尾でそれ以上 上/下 に移動しようとしたらページ移動する
function! s:tweetvim_vertical_move(cmd)
    execute "normal! ".a:cmd
    let end = line('$')
    while getline('.') =~# '^[-~]\+$' && line('.') != end
        execute "normal! ".a:cmd
    endwhile
    " 一番下まで来たら次のページに進む
    let line = line('.')
    if line == end
        call feedkeys("\<Plug>(tweetvim_action_page_next)")
    elseif line == 1
        call feedkeys("\<Plug>(tweetvim_action_page_previous)")
    endif
endfunction

" filetype が tweetvim ならツイートをリロード
function! s:tweetvim_reload()
    if &filetype ==# "tweetvim"
        call feedkeys("\<Plug>(tweetvim_action_reload)")
    endif
endfunction

function! s:tweetvim_easymotion()
		call feedkeys("\<Plug>(easymotion-s2)")
endfunction



" カーソル行のツイートをしたユーザの favstar を開く
function! s:tweetvim_favstar()
    let screen_name = matchstr(getline('.'),'^\s\zs\w\+')
    let path = empty(screen_name) ? "/me" : "/users/" . screen_name

    execute "OpenBrowser http://ja.favstar.fm" . path
endfunction

" カーソル下のユーザを favstar で開く
function! s:open_favstar()
    let username = expand('<cword>')
    if empty(username)
        OpenBrowser http://ja.favstar.fm/me
    else
        execute "OpenBrowser http://ja.favstar.fm/users/" . username
    endif
endfunction
command! Favstar call <SID>open_favstar()

" ツイートしたユーザのホームを開く
function! s:tweetvim_open_home()
    let username = expand('<cword>')
    if username =~# '^[a-zA-Z0-9_]\+$'
        execute "OpenBrowser https://twitter.com/" . username
    endif
endfunction
