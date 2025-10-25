" ============================================================================
" lexima.vim configuration (Minimal - Command Mode Aliases Only)
" ============================================================================
"
" Most input assistance features have been migrated to nvim-insx.
" See: rc/plugins/insx.vim
"
" This file now only contains:
" - Command mode aliases (LeximaAlterCommand)
" - Environment-specific settings that are difficult to implement in nvim-insx
"
" Migration date: 2025-10-25
" ============================================================================

" Enterキーで補完候補を選択する際のlexima.vimの動作を無効化
let lexima_accept_pum_with_enter = 0

" ============================================================================
" Environment-Specific Settings
" ============================================================================

" iterm専用 - 「」の入力補助
" Note: This is environment-specific and remains in lexima.vim
if g:IsMacNeovim() && !g:IsMacNeovimInWork() && !g:IsMacNeovimInWezterm()
  " 「」で囲まれた行でEnterを押すと、改行して新しい「」ペアを作成
  " at: 行頭(^)から「で始まり、カーソル位置(\%#)があり、」で終わる
  " input: 行末へ移動→改行2回→「」を挿入→カーソルを左へ
  call lexima#add_rule({
     \   'char': '<CR>',
     \   'at': '^「.*\%#.*」',
     \   'input': '<END><CR><CR>「」<LEFT>',
     \   'filetype': ['shd']
     \ })
endif

" ============================================================================
" Command Mode Aliases
" ============================================================================
" nvim-insxではコマンドモードの高度な操作が困難なため、
" この機能のみlexima.vimで維持

function! s:lexima_alter_command(original, altanative) abort
  let input_space = '<C-w>' .. a:altanative .. '<Space>'
  let input_cr    = '<C-w>' .. a:altanative .. '<CR>'

  let rule = {
        \ 'mode': ':',
        \ 'at': '^\(''<,''>\ )\?' .. a:original .. '\%#',
        \ }

  call lexima#add_rule(extend(rule, { 'char': '<Space>', 'input': input_space }))
  call lexima#add_rule(extend(rule, { 'char': '<CR>',    'input': input_cr    }))
endfunction

command! -nargs=+ LeximaAlterCommand call <SID>lexima_alter_command(<f-args>)

" Command aliases
LeximaAlterCommand omm OpenMindMap

" ============================================================================
" Migration Note
" ============================================================================
"
" All filetype-specific input assistance and general operator spacing have
" been migrated to nvim-insx. To restore the old lexima.vim configuration,
" check git history before 2025-10-25.
"
" Migrated features:
" - changelog/text/markdown/octo filetype rules
" - PHP filetype rules
" - General operator spacing (=, +, /, &, %, !, ,)
" - Semicolon auto-placement
"
" ============================================================================
