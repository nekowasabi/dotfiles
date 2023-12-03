" Vim syntax file
" Language:     text
" Maintainer:   nekowasabi <nolifeking00@gmail.com>
" Filenames:    *txt.
" Last Change:  2023/12/02

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'cutline'
endif

unlet! b:current_syntax

syn case ignore

syn match	shdText	"^・"
syn match	shdOutline "^[\t]*・"
syn match	shdOutline "^[+-] "
syn match	shdText	"^[\t\s]*[+-] "
syn match shdFold1 "\zs{{{[1-9]" conceal cchar=👎
syn match	shdMarkdownHeader	"^#\+"
syn region shdMarkdownBody matchgroup=shdMarkdownHeader start="^#\+\s\+" end="\s\|$"
syn match shdFold2 /}}}[0-9]/ conceal cchar=🖕
syn match	shdHeader2	"^\t・"
syn match	shdHeader2	"^\t- "
syn match	shdHeader3	"^\t\t・"
syn match	shdHeader3	"^\t\t- "
syn match	shdHeader1	"^・"
syn match	shdHeader1	"^- "
syn match shdComment6 "--------------------------------------- .*$"
syn match shdComment7 "----- .*$"
syn match	changelogHeader	"^\*"

hi def link shdComment1                        Comment
hi def link shdComment2                        Comment
hi def link shdComment3                        Comment
hi def link shdComment4                        Comment
hi def link shdComment5                        Comment
hi def link shdComment6                        Comment
hi def link shdComment7                        Comment
hi def link shdBrace1                          String
hi def link shdBrace2                          String
hi def link shdBrace3                          String
hi def link shdHeader1 												 Special
hi def link shdHeader2 												 Special
hi def link shdHeader3 												 Special
hi def link shdFold1 												   FoldHeader
hi def link shdFold2 												   FoldHeader
hi def link shdMarkdownHeader                  Comment
hi def link shdMarkdownBody 									 Special



"hi def link markdownH2                    htmlH2
"hi def link markdownH3                    htmlH3
"hi def link markdownH4                    htmlH4
"hi def link markdownH5                    htmlH5
"hi def link markdownH6                    htmlH6
"hi def link markdownH7                    htmlH7
"hi def link markdownHeadingRule           markdownRule
"hi def link markdownHeadingDelimiter      Delimiter
"hi def link markdownOrderedListMarker     markdownListMarker
"hi def link markdownListMarker            htmlTagName
"hi def link markdownBlockquote            Comment
"hi def link markdownRule                  PreProc
"
"hi def link markdownLinkText              htmlLink
"hi def link markdownIdDeclaration         Typedef
"hi def link markdownId                    Type
"hi def link markdownAutomaticLink         markdownUrl
"hi def link markdownUrl                   Float
"hi def link markdownUrlTitle              String
"hi def link markdownIdDelimiter           markdownLinkDelimiter
"hi def link markdownUrlDelimiter          htmlTag
"hi def link markdownUrlTitleDelimiter     Delimiter
"
"hi def link markdownItalic                htmlItalic
"hi def link markdownBold                  htmlBold
"hi def link markdownBoldItalic            htmlBoldItalic
"hi def link markdownCodeDelimiter         Delimiter
"
"hi def link markdownEscape                Special
"hi def link markdownError                 Error

let b:current_syntax = "outline"
if main_syntax ==# 'outline'
  unlet main_syntax
endif

" vim:set sw=2:
