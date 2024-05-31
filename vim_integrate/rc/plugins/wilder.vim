function! SetUpWilder() abort
	let wilder_cmd_line_renderer = wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
				\ 'winblend': 20,
				\ 'highlighter': wilder#basic_highlighter(),
				\ 'highlights': {
				\   'accent': wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#e27878', 'bold': v:true, 'underline': v:true}]),
				\   'selected_accent': wilder#make_hl('WilderSelectedAccent', 'PmenuSel', [{}, {}, {'foreground': '#e27878', 'bold': v:true, 'underline': v:true}]),
				\ },
				\ 'left': [wilder#popupmenu_devicons({'get_hl': wilder#devicons_get_hl_from_glyph_palette_vim()}), wilder#popupmenu_buffer_flags({'flags': ' '})],
				\ }))

  " Create the WilderAccent highlight by overriding the guifg attribute of Pmenu
  " and return the name of the highlight
  let l:hl = wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}])

	call wilder#setup({
				\ 'modes': [':'],
				\ 'accept_key': '<C-y>',
				\ 'enable_cmdline_enter': 1,
				\ })

  call wilder#set_option('renderer',
        \ wilder#popupmenu_renderer(wilder#popupmenu_palette_theme({
        \ 'border': 'double',
        \ 'empty_message': wilder#popupmenu_empty_message_with_spinner(),
        \ 'highlighter': wilder#basic_highlighter(),
        \ 'highlights': {
        \   'accent': l:hl,
        \ },
        \ 'separator': '  ',
        \ 'left': [
        \   ' ', wilder#popupmenu_devicons(),
        \ ],
        \ 'right': [
        \   ' ', wilder#popupmenu_scrollbar(),
        \ ],
        \ 'max_height': '55%',
        \ 'min_height': 0,
        \ 'prompt_position': 'top',
        \ 'reverse': 0,
        \ })))

	call wilder#set_option('pipeline', [
				\   wilder#branch(
				\     wilder#cmdline_pipeline({
				\       'language': 'python',
				\       'fuzzy': 1,
				\     }),
				\     wilder#python_search_pipeline({
				\       'pattern': wilder#python_fuzzy_pattern(),
				\       'sorter': wilder#python_difflib_sorter(),
				\       'engine': 're',
				\     }),
				\   ),
				\ ])

  cmap <expr> <C-e> wilder#in_context() ?
        \ WilderEnter() :
        \ "<Down>"

  function! WilderEnter() abort
    call wilder#next()
    call wilder#accept_completion()
    call feedkeys("\<CR>")
  endfunction
endfunction
call SetUpWilder()
