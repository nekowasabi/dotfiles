" -----------------------------------------------------------
" smartchar
inoremap <expr> % smartchr#one_of(' % ', '%')
inoremap <expr> & smartchr#one_of(' & ', ' && ', '&')
inoremap <expr> , smartchr#one_of(', ', ',')
inoremap <expr> = smartchr#one_of(' = ', '=', ' == ', ' === ')
inoremap <expr> ! smartchr#one_of('!', ' != ')
inoremap <expr> + smartchr#one_of('+', ' + ', '++')
inoremap <expr> / smartchr#one_of('/', ' / ', '// ', '//')
inoremap <expr> . smartchr#loop('.', '..', '->', ' => ')
inoremap <expr> ~ smartchr#loop('~', '=~', ' => ')
inoremap <expr> > smartchr#loop('>', ' => ')

