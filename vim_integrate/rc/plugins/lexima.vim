let lexima_accept_pum_with_enter = 0

" iterm専用
if g:IsMacNeovim() && !g:IsMacNeovimInWork() && !g:IsMacNeovimInWezterm()
  call lexima#add_rule({
     \   'char': '<CR>',
     \   'at': '^「.*\%#.*」',
     \   'input': '<END><CR><CR>「」<LEFT>',
     \   'filetype': ['shd']
     \ })
endif

let s:rules = []

" changelog {{{1
call lexima#add_rule({
    \   'at'    : '\%#]',
    \   'char'  : ':',
    \   'input' : '<Right>:',
    \   'filetype': ['changelog']
    \   })

let s:rules += [
      \ { 'filetype': 'changelog', 'char': '#',       'at': '^\%#\%(#\)\@!',                  'input': '#<Space>'                           },
      \ { 'filetype': 'changelog', 'char': '#',       'at': '#\s\%#',                         'input': '<BS>#<Space>',                      },
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'changelog', 'char': '-',       'at': '^\s*\%#',                        'input': '-<Space>',                          },
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\%#',                     'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\w.*\%#',                 'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\%#',                    'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\w.*\%#',                'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^-\s\w.*\%#',                    'input': '',                                  },
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
      \ { 'filetype': 'changelog', 'char': '[',       'at': '^\s*-\s\%#',                     'input': '<Left><Space>[]<Left>',             },
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\[\%#\]\s',               'input': '<Home><Tab><End><Left><Left>',      },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^-\s\[\%#\]\s',                  'input': '',                                  },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\%#\]\s',              'input': '<Home><Del><Del><End><Left><Left>', },
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'changelog', 'char': '<Space>', 'at': '^\s*-\s\[\%#\]',                 'input': '<Space><End>',                      },
      \ { 'filetype': 'changelog', 'char': 'x',       'at': '^\s*-\s\[\%#\]',                 'input': 'x<End>',                            },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\%#',      'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\w.*\%#', 'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^-\s\[\(\s\|x\)\]\s\w.*\%#',     'input': '',                                  },
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
      \ ]

" }}}1

" php {{{1
call lexima#add_rule({
    \   'at'    : '->\%#',
    \   'char'  : '<BS>',
    \   'input' : '<BS><BS>',
    \   'filetype': ['php']
    \   })

call lexima#add_rule({
    \   'at'    : '^ *\%#',
    \   'char'  : '>',
    \   'input' : '->',
    \   'filetype': ['php']
    \   })

call lexima#add_rule({
    \   'at'    : ')\%#',
    \   'char'  : '>',
    \   'input' : '->',
    \   'filetype': ['php']
    \   })

let s:rules += [
      \ { 'filetype': 'php', 'char': '$' ,       'at': '$\%#',    'input': 'this->'                            },
      \ { 'filetype': 'php', 'char': '>' ,       'at': '$.*\%#',  'input': '->'                              },
      \ { 'filetype': 'php', 'char': '>' ,       'at': '.*)\%#',  'input': '->'                              },
      \ { 'filetype': 'php', 'char': '>' ,       'at': '.*\%#''', 'input': '<Right> => '                              },
      \ ]


" }}}1

" text {{{1
let s:rules += [
      \ { 'filetype': 'text', 'char': '#',       'at': '^\%#\%(#\)\@!',                  'input': '#<Space>'                           },
      \ { 'filetype': 'text', 'char': '#',       'at': '#\s\%#',                         'input': '<BS>#<Space>',                      },
      \ { 'filetype': 'text', 'char': '<C-h>',   'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'text', 'char': '<C-h>',   'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'text', 'char': '<BS>',    'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'text', 'char': '<BS>',    'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'text', 'char': '-',       'at': '^\s*\%#',                        'input': '-<Space>',                          },
      \ { 'filetype': 'text', 'char': '<Tab>',   'at': '^\s*-\s\%#',                     'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'text', 'char': '<Tab>',   'at': '^\s*-\s\w.*\%#',                 'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'text', 'char': '<S-Tab>', 'at': '^\s\+-\s\%#',                    'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'text', 'char': '<S-Tab>', 'at': '^\s\+-\s\w.*\%#',                'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'text', 'char': '<S-Tab>', 'at': '^-\s\w.*\%#',                    'input': '',                                  },
      \ { 'filetype': 'text', 'char': '<C-h>',   'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      \ { 'filetype': 'text', 'char': '<C-h>',   'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      \ { 'filetype': 'text', 'char': '<BS>',    'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      \ { 'filetype': 'text', 'char': '<BS>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      \ { 'filetype': 'text', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
      \ { 'filetype': 'text', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
      \ { 'filetype': 'text', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
      \ { 'filetype': 'text', 'char': '[',       'at': '^\s*-\s\%#',                     'input': '<Left><Space>[]<Left>',             },
      \ { 'filetype': 'text', 'char': '<Tab>',   'at': '^\s*-\s\[\%#\]\s',               'input': '<Home><Tab><End><Left><Left>',      },
      \ { 'filetype': 'text', 'char': '<S-Tab>', 'at': '^-\s\[\%#\]\s',                  'input': '',                                  },
      \ { 'filetype': 'text', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\%#\]\s',              'input': '<Home><Del><Del><End><Left><Left>', },
      \ { 'filetype': 'text', 'char': '<C-h>',   'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'text', 'char': '<BS>',    'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'text', 'char': '<Space>', 'at': '^\s*-\s\[\%#\]',                 'input': '<Space><End>',                      },
      \ { 'filetype': 'text', 'char': 'x',       'at': '^\s*-\s\[\%#\]',                 'input': 'x<End>',                            },
      \ { 'filetype': 'text', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'text', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
      \ { 'filetype': 'text', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\%#',      'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'text', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'text', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'text', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\w.*\%#', 'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'text', 'char': '<S-Tab>', 'at': '^-\s\[\(\s\|x\)\]\s\w.*\%#',     'input': '',                                  },
      \ { 'filetype': 'text', 'char': '<C-h>',   'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'text', 'char': '<C-h>',   'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      \ { 'filetype': 'text', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'text', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      \ { 'filetype': 'text', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
      \ { 'filetype': 'text', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'text', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
      \ ]



" }}}1

" markdown {{{1
let s:rules += [
      \ { 'filetype': 'markdown', 'char': '#',       'at': '^\%#\%(#\)\@!',                  'input': '#<Space>'                           },
      \ { 'filetype': 'markdown', 'char': '#',       'at': '#\s\%#',                         'input': '<BS>#<Space>',                      },
      \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'markdown', 'char': '-',       'at': '^\s*\%#',                        'input': '-<Space>',                          },
      \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\%#',                     'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\w.*\%#',                 'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\%#',                    'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\w.*\%#',                'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^-\s\w.*\%#',                    'input': '',                                  },
      \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\%#',                        'input': '<C-w>',                         },
      \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w>',                    },
      \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
      \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
      \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
      \ { 'filetype': 'markdown', 'char': '[',       'at': '^\s*-\s\%#',                     'input': '<Left><Space>[]<Left>',             },
      \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\%#\]\s',               'input': '<Home><Tab><End><Left><Left>',      },
      \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^-\s\[\%#\]\s',                  'input': '',                                  },
      \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\%#\]\s',              'input': '<Home><Del><Del><End><Left><Left>', },
      \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'markdown', 'char': '<Space>', 'at': '^\s*-\s\[\%#\]',                 'input': '<Space><End>',                      },
      \ { 'filetype': 'markdown', 'char': 'x',       'at': '^\s*-\s\[\%#\]',                 'input': 'x<End>',                            },
      \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
      \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\%#',      'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\w.*\%#', 'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^-\s\[\(\s\|x\)\]\s\w.*\%#',     'input': '',                                  },
      \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w>',               },
      \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w>',          },
      \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
      \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
      \ ]

      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },

      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },

" }}}1

" octo {{{1
 let s:rules += [
      \ { 'filetype': 'octo', 'char': '#',       'at': '^\%#\%(#\)\@!',                  'input': '#<Space>'                           },
      \ { 'filetype': 'octo', 'char': '#',       'at': '#\s\%#',                         'input': '<BS>#<Space>',                      },
      \ { 'filetype': 'octo', 'char': '<C-h>',   'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'octo', 'char': '<C-h>',   'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'octo', 'char': '<BS>',    'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'octo', 'char': '<BS>',    'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'octo', 'char': '-',       'at': '^\s*\%#',                        'input': '-<Space>',                          },
      \ { 'filetype': 'octo', 'char': '<Tab>',   'at': '^\s*-\s\%#',                     'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'octo', 'char': '<Tab>',   'at': '^\s*-\s\w.*\%#',                 'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'octo', 'char': '<S-Tab>', 'at': '^\s\+-\s\%#',                    'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'octo', 'char': '<S-Tab>', 'at': '^\s\+-\s\w.*\%#',                'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'octo', 'char': '<S-Tab>', 'at': '^-\s\w.*\%#',                    'input': '',                                  },
      \ { 'filetype': 'octo', 'char': '<C-h>',   'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      \ { 'filetype': 'octo', 'char': '<C-h>',   'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      \ { 'filetype': 'octo', 'char': '<BS>',    'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      \ { 'filetype': 'octo', 'char': '<BS>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      \ { 'filetype': 'octo', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
      \ { 'filetype': 'octo', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
      \ { 'filetype': 'octo', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
      \ { 'filetype': 'octo', 'char': '[',       'at': '^\s*-\s\%#',                     'input': '<Left><Space>[]<Left>',             },
      \ { 'filetype': 'octo', 'char': '<Tab>',   'at': '^\s*-\s\[\%#\]\s',               'input': '<Home><Tab><End><Left><Left>',      },
      \ { 'filetype': 'octo', 'char': '<S-Tab>', 'at': '^-\s\[\%#\]\s',                  'input': '',                                  },
      \ { 'filetype': 'octo', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\%#\]\s',              'input': '<Home><Del><Del><End><Left><Left>', },
      \ { 'filetype': 'octo', 'char': '<C-h>',   'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'octo', 'char': '<BS>',    'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'octo', 'char': '<Space>', 'at': '^\s*-\s\[\%#\]',                 'input': '<Space><End>',                      },
      \ { 'filetype': 'octo', 'char': 'x',       'at': '^\s*-\s\[\%#\]',                 'input': 'x<End>',                            },
      \ { 'filetype': 'octo', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'octo', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
      \ { 'filetype': 'octo', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\%#',      'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'octo', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'octo', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'octo', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\w.*\%#', 'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'octo', 'char': '<S-Tab>', 'at': '^-\s\[\(\s\|x\)\]\s\w.*\%#',     'input': '',                                  },
      \ { 'filetype': 'octo', 'char': '<C-h>',   'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'octo', 'char': '<C-h>',   'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      \ { 'filetype': 'octo', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'octo', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      \ { 'filetype': 'octo', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
      \ { 'filetype': 'octo', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'octo', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
      \ ]


" }}}1

for s:rule in s:rules
  call lexima#add_rule(s:rule)
endfor

" general {{{
call lexima#add_rule({
    \   'at'    : '\%#)',
    \   'char'  : ';',
    \   'input' : '<Right>;',
    \   })
call lexima#add_rule({
    \   'at'    : ')\%#',
    \   'char'  : '>',
    \   'input' : ' => ',
    \   })

call lexima#add_rule({
    \   'at'    : '\%#]',
    \   'char'  : ';',
    \   'input' : '<Right>;',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#'']',
    \   'char'  : ';',
    \   'input' : '<Right><Right>;',
    \   })

call lexima#add_rule({
    \   'at'    : '".*\%#"',
    \   'char'  : ';',
    \   'input' : '<Right>;',
    \   })
call lexima#add_rule({
    \   'at'    : "\%#'",
    \   'char'  : ';',
    \   'input' : '<Right>;',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#")',
    \   'char'  : ';',
    \   'input' : '<Right><Right>;',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#"]',
    \   'char'  : ';',
    \   'input' : '<Right><Right>;',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#''',
    \   'char'  : ';',
    \   'input' : '<Right>;',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#'')',
    \   'char'  : ';',
    \   'input' : '<Right><Right>;',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#''',
    \   'char'  : '<',
    \   'input' : '<Right>, ',
    \   })

call lexima#add_rule({
    \   'at'    : '\%#''',
    \   'char'  : '=',
    \   'input' : '<Right> = ',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#'')',
    \   'char'  : '=',
    \   'input' : '<Right><Right> = ',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#")',
    \   'char'  : '=',
    \   'input' : '<Right><Right> = ',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#'']',
    \   'char'  : '=',
    \   'input' : '<Right><Right> = ',
    \   })
call lexima#add_rule({
    \   'at'    : '\%#"]',
    \   'char'  : '=',
    \   'input' : '<Right><Right> = ',
    \   })

call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '=',
    \   'input' : ' = ',
    \   })
call lexima#add_rule({'char': '=', 'at': ' = \%#',    'input': '<BS><BS><BS>='})
call lexima#add_rule({'char': '=', 'at': '=\%#',    'input': '<BS> == '})
call lexima#add_rule({'char': '=', 'at': ' == \%#',    'input': '<BS><BS><BS>=== '})
call lexima#add_rule({'char': '=', 'at': ' === \%#',    'input': '<BS><BS><BS><BS>= '})

call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '%',
    \   'input' : ' % ',
    \   })
call lexima#add_rule({'char': '%', 'at': ' % \%#',   'input': '<BS><BS><BS>%'})
call lexima#add_rule({'char': '%', 'at': '%\%#',    'input': '<BS> % '})

call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '&',
    \   'input' : ' & ',
    \   })
call lexima#add_rule({'char': '&', 'at': ' & \%#',   'input': '<BS><BS><BS> && '})
call lexima#add_rule({'char': '&', 'at': ' && \%#',    'input': '<BS><BS><BS><BS>&'}) 
call lexima#add_rule({'char': '&', 'at': '&\%#',    'input': '<BS> & '}) 

call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : ',',
    \   'input' : ', ',
    \   })
call lexima#add_rule({'char': ',', 'at': ', \%#',   'input': '<BS><BS>,'})
call lexima#add_rule({'char': ',', 'at': ',\%#',    'input': '<BS>, '})


call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '!',
    \   'input' : '!',
    \   })
call lexima#add_rule({'char': '!', 'at': '!\%#',   'input': '<BS> !== '})
call lexima#add_rule({'char': '!', 'at': ' !== \%#',    'input': '<BS><BS><BS><BS><BS>!'})

call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '+',
    \   'input' : '+',
    \   })
call lexima#add_rule({'char': '+', 'at': '+\%#',   'input': '<BS> + '})
call lexima#add_rule({'char': '+', 'at': ' + \%#',    'input': '<BS><BS><BS>++'}) 
call lexima#add_rule({'char': '+', 'at': '++\%#',    'input': '<BS><BS>+'}) 

call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '/',
    \   'input' : '/',
    \   })
call lexima#add_rule({'char': '/', 'at': '/\%#',    'input': '<BS> / '})
call lexima#add_rule({'char': '/', 'at': ' / \%#',    'input': '<BS><BS><BS>// '})
call lexima#add_rule({'char': '/', 'at': '// \%#',    'input': '<BS><BS><BS>//'})
call lexima#add_rule({'char': '/', 'at': '//\%#',    'input': '<BS><BS>/'})

" }}}1

function! s:lexima_alter_command(original, altanative) abort
  let input_space = '<C-w>' .. a:altanative .. '<Space>'
  let input_cr    = '<C-w>' .. a:altanative .. '<CR>'

  let rule = {
        \ 'mode': ':',
        \ 'at': '^\(''<,''>\)\?' .. a:original .. '\%#',
        \ }

  call lexima#add_rule(extend(rule, { 'char': '<Space>', 'input': input_space }))
  call lexima#add_rule(extend(rule, { 'char': '<CR>',    'input': input_cr    }))
endfunction

command! -nargs=+ LeximaAlterCommand call <SID>lexima_alter_command(<f-args>)

LeximaAlterCommand omm OpenMindMap
