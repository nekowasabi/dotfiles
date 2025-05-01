" " Vim syntax file
" Language:	generic ChangeLog file
" Written By:	Gediminas Paulauskas <menesis@delfi.lt>
" Maintainer:	Corinna Vinschen <vinschen@redhat.com>
" Last Change:	June 1, 2003

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'changelog'
endif

syn case ignore

if exists('b:changelog_spacing_errors')
  let s:spacing_errors = b:changelog_spacing_errors
elseif exists('g:changelog_spacing_errors')
  let s:spacing_errors = g:changelog_spacing_errors
else
  let s:spacing_errors = 1
endif

if s:spacing_errors
  syn match	changelogError "^ \+"
endif

syn match	changelogText	"^\s.*$" contains=changelogMail,changelogNumber,changelogMonth,changelogDay,changelogError
syn match	changelogText	"^■.*$"
syn match	changelogText	"^・"
syn match	changelogHeader	"^\*"
syn match	changelogHeader	"^*"
syn match	changelogOutline "^[\t]*・"
syn match	changelogOutline "^[+-] "
syn match	changelogText	"^[\t\s]*[+-] "
syn match	changelogHeader	"^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].*$"
syn match	changelogHeader	"^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] .*$"
syn match	changelogHeader	"^\s[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] .*$"
syn match	changelogHeader	"^\s[0-9][0-9][0-9][0-9].*$"
syn match       changelogHeader "○"
syn match       changelogHeaderCompleted "済／.*$"
syn match	changelogText   "△"
syn match	changelogText   "→"

hi def link changelogDelimiter     Delimiter
syn region changelogText matchgroup=changelogDelimiter start="\[" end="\]"
syn match changelogMarkdownHeader "^# .*$" contains=changelogFoldStart1
syn match changelogMarkdownHeader "^## .*$" contains=changelogFoldStart2
syn match changelogMarkdownHeader "^### .*$" contains=changelogFoldStart3
syn match changelogMarkdownHeader "^#### .*$" contains=changelogFoldStart4

syn match changelogFoldStart1 "\zs{{{[1]" conceal cchar=👎
syn match changelogFoldClose1 /}}}[1]/ conceal cchar=🖕
syn match changelogFoldStart2 "\zs{{{[2]" conceal cchar=🐶
syn match changelogFoldClose2 /}}}[2]/ conceal cchar=🐶
syn match changelogFoldStart3 "\zs{{{[3]" conceal cchar=🐱
syn match changelogFoldClose3 /}}}[3]/ conceal cchar=🐱

syn match changelogText /CL\C:/ conceal cchar=📝
syn match changelogText /CLO\C:/ conceal cchar=📚

" normal
syntax match changelogBrace /『[^』]*』/
syntax match changelogBrace /「[^」]*」/
syntax match changelogBrace /`[^`]*`/

syn region markdownCode matchgroup=markdownCodeDelimiter start="^\s*```.*$" end="^\s*```\ze\s*$" keepend contains=@markdownHighlight
syn region markdownCodeInline matchgroup=markdownCodeDelimiter start="`" end="`" keepend contains=@markdownHighlight
syn cluster markdownHighlight add=markdownCode,markdownCodeInline

hi link markdownCodeDelimiter Delimiter
hi link markdownCode String
hi link markdownCodeInline String

if version < 600
"  syn region	changelogFiles	start="^\s\+[+*]\s" end=":\s" end="^$" contains=changelogBullet,changelogColon,changelogError keepend
"  syn region	changelogFiles	start="^\s\+[([]" end=":\s" end="^$" contains=changelogBullet,changelogColon,changelogError keepend
"  syn match	changelogColon	contained ":\s"
else
  syn region	changelogFiles	start="^[*]\s" end=":\n" end="^$" contains=changelogBullet,changelogColon,changelogFuncs,changelogError keepend
  syn region	changelogFiles	start="^\s[([]" end=":\n" end="^$" contains=changelogBullet,changelogColon,changelogFuncs,changelogError keepend
  syn match	changelogFuncs  contained "(.\{-})" extend
  syn match	changelogFuncs  contained "\[.\{-}]" extend
  syn match	changelogColon	contained ":"
endif
syn match	changelogBullet	contained "^[*]\s" contains=changelogError
syn match	changelogMail	contained "<[A-Za-z0-9\._:+-]\+@[A-Za-z0-9\._-]\+>"
syn keyword	changelogMonth	contained jan feb mar apr may jun jul aug sep oct nov dec
syn keyword	changelogDay	contained mon tue wed thu fri sat sun
syn match	changelogNumber	contained "[.-]*[0-9]\+"

" 言語シンタックスの読み込み
syntax include @markdownPhp syntax/php.vim
syntax include @markdownVim syntax/vim.vim
syntax include @markdownTs syntax/typescript.vim

" コードブロックの定義
syntax region changelogCode
      \ start="^```\(php\|vim\|typescript\|js\)\?\s*$"
      \ end="^```\s*$"
      \ keepend
      \ contains=@NoSpell
      \ containedin=changelogText

" ハイライトの設定
hi def link changelogCode String

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_changelog_syntax_inits")
  if version < 508
    let did_changelog_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink changelogBrace         String
  HiLink changelogText		Special
  HiLink changelogBullet	Type
  HiLink changelogColon		Type
  HiLink changelogFiles		Comment
  if version >= 600
    HiLink changelogFuncs	Comment
  endif
  HiLink changelogHeader	Comment
  HiLink changelogMarkdownHeader	Comment
  HiLink changelogMarkdownBody  Special
  HiLink changelogOutline	Special
  HiLink changelogMail		Special
  HiLink changelogNumber	Number
  HiLink changelogMonth		Number
  HiLink changelogDay		Number
  HiLink changelogError		Folded
  HiLink changelogFoldStart1		FoldType
  HiLink changelogFoldStart2		FoldType
  HiLink changelogFoldStart3		FoldType
  HiLink changelogFoldClose1	FoldType
  HiLink changelogFoldClose2		FoldType
  HiLink changelogFoldClose3		FoldType
  HiLink changelogMarker	FoldTColumn
  HiLink changelogHeaderCompleted WarningMsg

  delcommand HiLink
endif

let b:current_syntax = "changelog"

" vim: ts=8
