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

  let wilder_search_renderer = wilder#wildmenu_renderer({
        \ 'highlighter': wilder#basic_highlighter(),
        \ 'separator': '  ',
        \ 'left': [' '],
        \ 'right': [' ', wilder#wildmenu_index()],
        \ })

  call wilder#setup({
        \ 'modes': [':', '/', '?'],
        \ 'accept_key': '<C-e>',
        \ })

  call wilder#set_option(
        \ 'renderer',
        \ wilder#renderer_mux({
        \   ':': wilder_cmd_line_renderer,
        \   '/': wilder_search_renderer,
        \   '?': wilder_search_renderer,
        \ })
        \ )
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
endfunction
call SetUpWilder()
