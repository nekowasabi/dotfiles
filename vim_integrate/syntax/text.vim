" Vim syntax file
" Language:     Markdown
" Maintainer:   Tim Pope <vimNOSPAM@tpope.org>
" Filenames:    *.markdown
" Last Change:  2013 May 30

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'outline'
endif

unlet! b:current_syntax

syn case ignore

syn match shdComment1 "^■.*$"

syn match shdComment6 "--------------------------------------- .*$"
syn match shdComment7 "----- .*$"

syn match shdComment1 "[＜].\{-}.[＞】]"
syn match shdBrace1 "[【『「].\{-}.[』」 】]"
" syn match shdBrace2 "[「].*\n.*[」】]"
syn match	shdHeader1	"^[\t]*・"
syn match	shdHeader1	"\[.\{-}.\]"
" syn match	shdHeader1	"^.*→"
syn match	shdHeader1	"→"

syn match shdBrace3   "[〇○]"
syn match	shdHeader1	"[Δ△]"
syn match UtlUrl "×"

hi def link shdComment1                        Comment
hi def link shdComment6                        Comment
hi def link shdComment7                        Comment
hi def link shdBrace1                          String
hi def link shdBrace2                          String
hi def link shdBrace3                          String
hi def link shdHeader1 												 Special

let b:current_syntax = "outline"
if main_syntax ==# 'outline'
  unlet main_syntax
endif

" vim:set sw=2:
