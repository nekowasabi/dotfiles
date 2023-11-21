let g:deepl#endpoint = "https://api-free.deepl.com/v2/translate"
let g:deepl#auth_key = "74c16012-bb47-0639-8421-69926eab39dd:fx"

" Translate the current line and display it on a new line.
vmap t<C-e> <Cmd>call deepl#v("EN")<CR>
vmap t<C-j> <Cmd>call deepl#v("JA")<CR>

" aranslate a current line and display on a new line
nmap t<C-e> yypV<Cmd>call deepl#v("EN")<CR>
nmap t<C-j> yypV<Cmd>call deepl#v("JA")<CR>

" specify the source language
" translate from FR to EN
nmap t<C-e> yypV<Cmd>call deepl#v("EN", "FR")<CR>
