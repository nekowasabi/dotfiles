" Vim syntax file
" Language:     Markdown
" Maintainer:   Tim Pope <vimNOSPAM@tpope.org>
" Filenames:    *.markdown
" Last Change:  2013 May 30

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'cutline'
endif

unlet! b:current_syntax

syn case ignore

syn match markdownHeadingRule "^[=-]\+$" contained

syn match shdComment1 "^# .*$"
syn match shdFold ".* {{{[0-9]" keepend cchar=👎
syn match shdFold /}}}[0-9]/ conceal cchar=👆
syn match shdComment1 "^■.*$"
syn match shdComment1 "//.\{-}$"
syn match shdComment1 ";//.\{-}$"
syn match shdComment2 "## .*$"
syn match shdComment3 "### .*$"
syn match shdComment4 "#### .*$"
syn match shdComment5 "##### .*$"
syn match shdComment1 "[＜].\{-}.[＞】]"
syn match shdBrace1 "[【『「].\{-}.[』」 】]"
syn match	shdHeader1	"^・"
syn match	shdHeader1	"^- "
syn match	shdHeader1	"\[.\{-}.\]"
syn match	shdHeader2	"^\t・"
syn match	shdHeader2	"^\t- "
syn match	shdHeader3	"^\t\t・"
syn match	shdHeader3	"^\t\t- "

syn match shdComment6 "--------------------------------------- .*$"
syn match shdComment7 "----- .*$"

syn match shdBrace3   "○"
syn match	shdHeader1	"△"
syn match UtlUrl "×"

"syn region markdownH2 matchgroup=markdownHeadingDelimiter start="###\@!"     end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
"syn region markdownH3 matchgroup=markdownHeadingDelimiter start="####\@!"    end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
"syn region markdownH4 matchgroup=markdownHeadingDelimiter start="#####\@!"   end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
"syn region markdownH5 matchgroup=markdownHeadingDelimiter start="######\@!"  end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
"syn region markdownH6 matchgroup=markdownHeadingDelimiter start="#######\@!" end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
"syn region markdownH7 matchgroup=markdownHeadingDelimiter start="########\@!" end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained

"syn match markdownBlockquote ">\%(\s\|$\)" contained nextgroup=@markdownBlock
"
"syn region markdownCodeBlock start="    \|\t" end="$" contained
"
"" TODO: real nesting
"syn match markdownListMarker "\%(\t\| \{0,4\}\)[-*+]\%(\s\+\S\)\@=" contained
"syn match markdownOrderedListMarker "\%(\t\| \{0,4}\)\<\d\+\.\%(\s\+\S\)\@=" contained
"
"syn match markdownRule "\* *\* *\*[ *]*$" contained
"syn match markdownRule "- *- *-[ -]*$" contained
"
"syn match markdownLineBreak " \{2,\}$"
"
"syn region markdownIdDeclaration matchgroup=markdownLinkDelimiter start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=markdownUrl skipwhite
"syn match markdownUrl "\S\+" nextgroup=markdownUrlTitle skipwhite contained
"syn region markdownUrl matchgroup=markdownUrlDelimiter start="<" end=">" oneline keepend nextgroup=markdownUrlTitle skipwhite contained
"syn region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+"+ end=+"+ keepend contained
"syn region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+'+ end=+'+ keepend contained
"syn region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+(+ end=+)+ keepend contained
"
"syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" keepend nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart
"syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained
"syn region markdownId matchgroup=markdownIdDelimiter start="\[" end="\]" keepend contained
"syn region markdownAutomaticLink matchgroup=markdownUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline
"
"syn region markdownItalic start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" keepend contains=markdownLineStart
"syn region markdownItalic start="\S\@<=_\|_\S\@=" end="\S\@<=_\|_\S\@=" keepend contains=markdownLineStart
"syn region markdownBold start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend contains=markdownLineStart,markdownItalic
"syn region markdownBold start="\S\@<=__\|__\S\@=" end="\S\@<=__\|__\S\@=" keepend contains=markdownLineStart,markdownItalic
"syn region markdownBoldItalic start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend contains=markdownLineStart
"syn region markdownBoldItalic start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend contains=markdownLineStart
"syn region markdownCode matchgroup=markdownCodeDelimiter start="`" end="`" keepend contains=markdownLineStart
"syn region markdownCode matchgroup=markdownCodeDelimiter start="`` \=" end=" \=``" keepend contains=markdownLineStart
"syn region markdownCode matchgroup=markdownCodeDelimiter start="^\s*```.*$" end="^\s*```\ze\s*$" keepend
"
"if main_syntax ==# 'markdown'
"  for s:type in g:markdown_fenced_languages
"    exe 'syn region markdownHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' matchgroup=markdownCodeDelimiter start="^\s*```'.matchstr(s:type,'[^=]*').'\>.*$" end="^\s*```\ze\s*$" keepend contains=@markdownHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\.','','g')
"  endfor
"  unlet! s:type
"endif
"
"syn match markdownEscape "\\[][\\`*_{}()#+.!-]"
"syn match markdownError "\w\@<=_\w\@="

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
hi def link shdFold 												   FoldHeader

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
