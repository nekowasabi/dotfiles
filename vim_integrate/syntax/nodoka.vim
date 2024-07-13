" vim syntax file
" Filename:     nodoka.vim
" Language:     nodoka
" Maintainer:   janus_wel <janus.wel.3@gmail.com>
" Version:      0.33
" License:      New BSD License
"   See under URL.  Note that redistribution is permitted with LICENSE.
"   http://github.com/januswel/dotfiles/vimfiles/LICENSE


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif
let b:current_syntax = "nodoka"

" includes
syntax keyword  nodokaInclude include

" conditionals
syntax keyword  nodokaConditional if else endif

" operators
syntax match    nodokaOperator    /\%(=\|:\|+=\|-=\)/

" numbers
syntax match    nodokaNumberDecimal        /[+-]\=\<\d\+\%(\.\d\+\)\=\>/ display
syntax match    nodokaNumberHexadecimal    /\<0x\x\+\>/ display

" strings
syntax region   nodokaStringDoubleQuote   start=/"/ skip=/\\\\\|\\$"/ end=/"/
syntax region   nodokaStringSingleQuote   start=/'/ skip=/\\\\\|\\$'/ end=/'/

" regular expression
syntax region   nodokaRegexpString    start=+/\%(\*\|/\)\@!+ skip=+\\\\\|\\/+ end=+/[gim]\{-,3}+ oneline contained

" functions
syntax match    nodokaFunction        /&\a\+\>/ contains=nodokaFunctionName
syntax keyword  nodokaFunctionName
            \ WindowVMaximize WindowToggleTopMost WindowSetAlpha
            \ WindowResizeTo WindowRedraw WindowRaise WindowMoveVisibly
            \ WindowMoveTo WindowMove WindowMonitorTo WindowMonitor
            \ WindowMinimize WindowMaximize WindowLower WindowIdentify
            \ WindowHVMaximize WindowHMaximize WindowClose WindowClingToTop
            \ WindowClingToRight WindowClingToLeft WindowClingToBottom Wait
            \ Variable VK Undefined Toggle Sync ShellExecute SetImeStatus
            \ SetForegroundWindow Repeat Recenter Prefix PostMessage PlugIn
            \ OtherWindowClass MouseWheel MouseMove nodokaDialog LogClear
            \ LoadSetting KeymapWindow KeymapPrevPrefix KeymapParent Keymap
            \ InvestigateCommand Ignore HelpVariable HelpMessage
            \ EmacsEditKillLinePred EmacsEditKillLineFunc EditNextModifier
            \ DirectSSTP DescribeBindings Default ClipboardUpcaseWord
            \ ClipboardDowncaseWord ClipboardCopy ClipboardChangeCase
            \ contained transparent

" definitions
syntax keyword  nodokaDefine
            \ keymap keymap2 key event mod def keyseq sync alias
            \ subst define
syntax keyword  nodokaDefineWindowKeyword window contained containedin=nodokaDefineWindow
syntax region   nodokaDefineWindow start=/window/ end=/$/ contains=nodokaDefineWindowKeyword,nodokaOperator,nodokaRegexpString

" options
syntax keyword  nodokaOption option
syntax match    nodokaOption /\%(delay-of\s\+!!!\|sts4nodoka\|cts4nodoka\)/

" key sequenses
syntax match    nodokaKeySequense /\$[A-Za-z\-_]\+/

" special keys
syntax match    nodokaSpecialKeys /\%([\*~]\=\%(C\|M\|A\|S\|W\|NL\|CL\|SL\|KL\|IL\|IC\|MAX\|MIN\|MMAX\|MMIN\|T\|TS\|L[0-9]\)-\)\+\*\=\S\+/ contains=nodokaSpecialKeysPrefix
syntax keyword  nodokaSpecialKeysPrefix
            \ C M A S W NL CL SL KL IL IC
            \ MAX MIN MMAX MMIN T TS
            \ L0 L1 L2 L3 L4 L5 L6 L7 L8 L9
            \ contained transparent

" scancodes
syntax match    nodokaScanCodeDecimal      /\<E[01]\-\d\+\>/ contains=nodokaExtendedKeyFlag
syntax match    nodokaScanCodeHexadecimal  /\<E[01]\-0x\x\+\>/ contains=nodokaExtendedKeyFlag
syntax keyword  nodokaExtendedKeyFlag E0 E1 contained transparent

" comments
syntax keyword  nodokaCommentTodo TODO FIXME XXX TBD contained
syntax region   nodokaComment     start=/#/ end=/$/ contains=nodokaCommentTodo keepend oneline

" all
syntax cluster  nodokaAll contains=ALL

" highlighting
if version >= 508 || !exists("did_nodoka_syntax_inits")
    if version < 508
        let did_nodoka_syntax_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink nodokaInclude              Include
    HiLink nodokaConditional          Conditional
    HiLink nodokaOperator             Operator

    HiLink nodokaNumberDecimal        Number
    HiLink nodokaNumberHexadecimal    Number
    HiLink nodokaScanCodeDecimal      Number
    HiLink nodokaScanCodeHexadecimal  Number

    HiLink nodokaStringDoubleQuote    String
    HiLink nodokaStringSingleQuote    String
    HiLink nodokaRegexpString         String

    HiLink nodokaFunction             Function

    HiLink nodokaDefine               Statement
    HiLink nodokaDefineWindowKeyword  Statement
    HiLink nodokaOption               Keyword

    HiLink nodokaKeySequense          Identifier
    HiLink nodokaSpecialKeys          Special

    HiLink nodokaComment              Comment
    HiLink nodokaCommentTodo          Todo

    delcommand HiLink
endif

" vim: ts=4 sts=4 sw=4 et
