" function! GitBash()
"     " 日本語Windowsの場合`ja`が設定されるので、入力ロケールに設定しなおす
"     let l:oldlang = $LANG
"     let $LANG = systemlist('"C:/Program Files/Git/usr/bin/locale.exe" -iU')[0]
"
"     " remote連携のための設定
"     let l:oldgvim = $GVIM
"     let l:oldvimserver = $VIM_SERVERNAME
"     let $GVIM = $VIMRUNTIME
"     let $VIM_SERVERNAME = v:servername
"
"     " Git for Windowsに同梱されたvimで誤作動するのでvimが設定する環境変数を削除する
"     let l:oldvim = $VIM
"     let l:oldvimruntime = $VIMRUNTIME
"     let l:oldmyvimrc = $MYVIMRC
"     let l:oldmygvimrc = $MYGVIMRC
"     let $VIM = ''
"     let $VIMRUNTIME = ''
"     let $MYVIMRC = ''
"     let $MYGVIMRC = ''
"
"     " :terminalを実行したvimのservernameを設定する
"     if has('clientserver')
"         let $VIM_SERVERNAME = v:servername
"     endif
"
"     " ホームディレクトリに移動する
"     lcd $USERPROFILE
"     " :terminalでgit for windowsのbashを実行する
"     terminal ++close ++curwin C:/Program Files/Git/bin/bash.exe -l
"
"     " 環境変数とカレントディレクトリを元に戻す
"     let $LANG = l:oldlang
"     let $GVIM = l:oldgvim
"     let $VIM_SERVERNAME = l:oldvimserver
"     let $VIM = l:oldvim
"     let $VIMRUNTIME = l:oldvimruntime
"     let $MYVIMRC = l:oldmyvimrc
"     let $MYGVIMRC = l:oldmygvimrc
"     lcd -
" endfunction

function! GitBash()
    " 日本語Windowsの場合`ja`が設定されるので、入力ロケールに合わせたUTF-8に設定しなおす
    let l:env = {
                \ 'LANG': systemlist('"C:/Program Files/Git/usr/bin/locale.exe" -iU')[0],
                \ }

    " remote連携のための設定
    if has('clientserver')
        call extend(l:env, {
                    \ 'GVIM': $VIMRUNTIME,
                    \ 'VIM_SERVERNAME': v:servername,
                    \ })
    endif

    " term_startでgit for windowsのbashを実行する
    call term_start(['C:/Program Files/Git/bin/bash.exe', '-l'], {
                \ 'term_name': 'Git',
                \ 'term_finish': 'close',
                \ 'curwin': v:true,
                \ 'cwd': $USERPROFILE,
                \ 'env': l:env,
                \ })

endfunction

nnoremap <Leader>g :<C-u>call GitBash()<CR>

nnoremap <Leader>B :<C-u>call GitBash()<CR>

tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <silent> jj <C-\><C-n>

