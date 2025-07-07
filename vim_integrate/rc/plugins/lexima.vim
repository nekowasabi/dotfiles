" Enterキーで補完候補を選択する際のlexima.vimの動作を無効化
let lexima_accept_pum_with_enter = 0

" iterm専用
if g:IsMacNeovim() && !g:IsMacNeovimInWork() && !g:IsMacNeovimInWezterm()
  " 「」で囲まれた行でEnterを押すと、改行して新しい「」ペアを作成
  " at: 行頭(^)から「で始まり、カーソル位置(\%#)があり、」で終わる
  " input: 行末へ移動→改行2回→「」を挿入→カーソルを左へ
  call lexima#add_rule({
     \   'char': '<CR>',
     \   'at': '^「.*\%#.*」',
     \   'input': '<END><CR><CR>「」<LEFT>',
     \   'filetype': ['shd']
     \ })
endif

let s:rules = []

" changelog {{{1
" ]の直前でコロンを入力すると、]の後ろにコロンを配置
" 例: [issue\%#] → [issue]:  (\%#はカーソル位置)
call lexima#add_rule({
    \   'at'    : '\%#]',
    \   'char'  : ':',
    \   'input' : '<Right>:',
    \   'filetype': ['changelog']
    \   })

" 行頭（タブ考慮）に『・』があるときの改行
" at: 行頭(^)、任意の空白(\s*)、・があり、カーソル(\%#)が行末($)にある
" input: 改行して新しい・を自動挿入
call lexima#add_rule({
      \ 'char': '<CR>',
      \ 'at': '^\s*・.*\%#$',
      \ 'input': '<CR>・',
      \ 'filetype': 'changelog',
      \ })


let s:rules += [
      " 行頭で#を入力すると、自動的にスペースを追加（見出し用）
      " at: 行頭(^)でカーソル(\%#)の位置、かつ次の文字が#でない(\%(#\)\@!)
      \ { 'filetype': 'changelog', 'char': '#',       'at': '^\%#\%(#\)\@!',                  'input': '#<Space>'                           },
      " # の後のスペースで再度#を入力すると、##として見出しレベルを上げる
      \ { 'filetype': 'changelog', 'char': '#',       'at': '#\s\%#',                         'input': '<BS>#<Space>',                      },
      " # の後のスペースでBackspace/C-hを押すと、# とスペースを一緒に削除
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      " ## の後でBackspace/C-hを押すと、一つのレベルを下げて # に戻す
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
      " 行頭で - を入力すると、リスト項目として自動的にスペースを追加
      \ { 'filetype': 'changelog', 'char': '-',       'at': '^\s*\%#',                        'input': '-<Space>',                          },
      " リスト項目でTabを押すと、インデントレベルを上げる
      " 行頭に移動→Tab挿入→行末に戻る
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\%#',                     'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\w.*\%#',                 'input': '<Home><Tab><End>',                  },
      " Shift+Tabでインデントレベルを下げる
      " 行頭の空白を2文字削除（インデント解除）
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\%#',                    'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\w.*\%#',                'input': '<Home><Del><Del><End>',             },
      " インデントなしのリスト項目では何もしない
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^-\s\w.*\%#',                    'input': '',                                  },
      " リスト項目の開始位置でBackspace/C-hを押すと、リスト記号と空白を削除
      " C-wで単語単位の削除を利用
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      " インデントされたリスト項目では、インデントも含めて削除
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      " 空のリスト項目でEnterを押すと、リストを終了
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
      " リスト項目の途中でEnterを押すと、新しいリスト項目を作成
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
      " リスト項目の開始で [ を入力すると、チェックボックス [] を作成
      " カーソルは [] の中に配置
      \ { 'filetype': 'changelog', 'char': '[',       'at': '^\s*-\s\%#',                     'input': '<Left><Space>[]<Left>',             },
      " チェックボックス付きリスト項目でTab/Shift+Tabを押したときのインデント制御
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\[\%#\]\s',               'input': '<Home><Tab><End><Left><Left>',      },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^-\s\[\%#\]\s',                  'input': '',                                  },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\%#\]\s',              'input': '<Home><Del><Del><End><Left><Left>', },
      " 空のチェックボックスでBackspaceを押すと、チェックボックスを削除
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      " 空のチェックボックス内でスペースまたはxを入力すると、それを挿入してカーソルを行末へ
      " チェック状態の切り替えに使用
      \ { 'filetype': 'changelog', 'char': '<Space>', 'at': '^\s*-\s\[\%#\]',                 'input': '<Space><End>',                      },
      \ { 'filetype': 'changelog', 'char': 'x',       'at': '^\s*-\s\[\%#\]',                 'input': 'x<End>',                            },
      " 空のチェックボックスでEnterを押すと、チェックボックス付きリストを終了
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
      " チェックボックス（空またはチェック済み）付きリスト項目のインデント制御
      " \(\s\|x\) はスペースまたはxにマッチ
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\%#',      'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'changelog', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<Home><Tab><End>',                  },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\w.*\%#', 'input': '<Home><Del><Del><End>',             },
      \ { 'filetype': 'changelog', 'char': '<S-Tab>', 'at': '^-\s\[\(\s\|x\)\]\s\w.*\%#',     'input': '',                                  },
      " チェックボックス付きリストで内容が空のときにBackspaceを押すと、リストを削除
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'changelog', 'char': '<C-h>',   'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      \ { 'filetype': 'changelog', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      " チェックボックス付きリストで内容が空のときにEnterを押すと、リストを終了
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
      " チェックボックス付きリストの内容があるときにEnterを押すと、新しいチェックボックス付きリストを作成
      \ { 'filetype': 'changelog', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
      \ ]

" }}}1

" php {{{1
" ->をまとめて削除（メソッドチェイン用）
call lexima#add_rule({
    \   'at'    : '->\%#',
    \   'char'  : '<BS>',
    \   'input' : '<BS><BS>',
    \   'filetype': ['php']
    \   })

" 行頭で > を入力すると -> に変換（PHPのメソッドチェイン用）
call lexima#add_rule({
    \   'at'    : '^ *\%#',
    \   'char'  : '>',
    \   'input' : '->',
    \   'filetype': ['php']
    \   })

" )の後で > を入力すると -> に変換
call lexima#add_rule({
    \   'at'    : ')\%#',
    \   'char'  : '>',
    \   'input' : '->',
    \   'filetype': ['php']
    \   })

let s:rules += [
      " $$と入力すると $this-> に変換（PHPのインスタンス変数アクセス）
      \ { 'filetype': 'php', 'char': '$' ,       'at': '$\%#',    'input': 'this->'                            },
      " 変数名の後で > を入力すると -> に変換
      \ { 'filetype': 'php', 'char': '>' ,       'at': '$.*\%#',  'input': '->'                              },
      " )の後で > を入力すると -> に変換
      \ { 'filetype': 'php', 'char': '>' ,       'at': '.*)\%#',  'input': '->'                              },
      " 'の前で > を入力すると => に変換（連想配列用）
      \ { 'filetype': 'php', 'char': '>' ,       'at': '.*\%#''', 'input': '<Right> => '                              },
      \ ]


" }}}1

" text {{{1
" textファイルのMarkdown風記法サポート
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
" Markdownファイル用のリストと見出しの自動整形
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
      \ ]

      " コメントアウトされたチェックボックス関連のルール（Markdownの標準チェックボックスは [x] 形式）
      " \ { 'filetype': 'markdown', 'char': '[',       'at': '^\s*-\s\%#',                     'input': '[<Space>]<Left><Left>',             },
      " \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\%#\]\s',               'input': '<Home><Tab><End><Left><Left>',      },
      " \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^-\s\[\%#\]\s',                  'input': '',                                  },
      " \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\%#\]\s',              'input': '<Home><Del><Del><End><Left><Left>', },
      " \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
      " \ { 'filetype': 'markdown', 'char': '<Space>', 'at': '^\s*-\s\[\%#\]',                 'input': '<Space><End>',                      },
      " \ { 'filetype': 'markdown', 'char': 'x',       'at': '^\s*-\s\[\%#\]',                 'input': 'x<End>',                            },
      " \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
      " \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
      " \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\%#',      'input': '<Home><Tab><End>',                  },
      " \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<Home><Tab><End>',                  },
      " \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<Home><Del><Del><End>',             },
      " \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\w.*\%#', 'input': '<Home><Del><Del><End>',             },
      " \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^-\s\[\(\s\|x\)\]\s\w.*\%#',     'input': '',                                  },
      " \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      " \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w>',               },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w>',          },
      " \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
      " \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
      " \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
      " \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },

" }}}1

" octo {{{1
" GitHub Issues/PR編集用のoctoファイルタイプ向け設定
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
" )の前でセミコロンを入力すると、)の後にセミコロンを配置
call lexima#add_rule({
    \   'at'    : '\%#)',
    \   'char'  : ';',
    \   'input' : '<Right>;',
    \   })
" )の後で > を入力すると => に変換（アロー関数や連想配列用）
call lexima#add_rule({
    \   'at'    : ')\%#',
    \   'char'  : '>',
    \   'input' : ' => ',
    \   })

" ]の前でセミコロンを入力すると、]の後にセミコロンを配置
call lexima#add_rule({
    \   'at'    : '\%#]',
    \   'char'  : ';',
    \   'input' : '<Right>;',
    \   })
" ']の前でセミコロンを入力すると、']の後にセミコロンを配置
call lexima#add_rule({
    \   'at'    : '\%#'']',
    \   'char'  : ';',
    \   'input' : '<Right><Right>;',
    \   })

" 文字列リテラルの中または終了引用符の前でセミコロンを入力すると、引用符の外にセミコロンを配置
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
" 'の前で < を入力すると、'の後にカンマとスペースを挿入
call lexima#add_rule({
    \   'at'    : '\%#''',
    \   'char'  : '<',
    \   'input' : '<Right>, ',
    \   })

" 引用符の前で = を入力すると、引用符の後に = を配置（代入式用）
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

" =を入力するとスペース付きの代入演算子に、繰り返し入力で==、===に変換
call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '=',
    \   'input' : ' = ',
    \   })
call lexima#add_rule({'char': '=', 'at': ' = \%#',    'input': '<BS><BS><BS>='})
call lexima#add_rule({'char': '=', 'at': '=\%#',    'input': '<BS> == '})
call lexima#add_rule({'char': '=', 'at': ' == \%#',    'input': '<BS><BS><BS>=== '})
call lexima#add_rule({'char': '=', 'at': ' === \%#',    'input': '<BS><BS><BS><BS>= '})

" %を入力するとスペース付きのモジュロ演算子に変換
call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '%',
    \   'input' : ' % ',
    \   })
call lexima#add_rule({'char': '%', 'at': ' % \%#',   'input': '<BS><BS><BS>%'})
call lexima#add_rule({'char': '%', 'at': '%\%#',    'input': '<BS> % '})

" &を入力するとスペース付きの演算子に、繰り返し入力で&&に変換
call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '&',
    \   'input' : ' & ',
    \   })
call lexima#add_rule({'char': '&', 'at': ' & \%#',   'input': '<BS><BS><BS> && '})
call lexima#add_rule({'char': '&', 'at': ' && \%#',    'input': '<BS><BS><BS><BS>&'}) 
call lexima#add_rule({'char': '&', 'at': '&\%#',    'input': '<BS> & '}) 

" ,を入力すると自動的にスペースを追加
call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : ',',
    \   'input' : ', ',
    \   })
call lexima#add_rule({'char': ',', 'at': ', \%#',   'input': '<BS><BS>,'})
call lexima#add_rule({'char': ',', 'at': ',\%#',    'input': '<BS>, '})


" !を繰り返し入力すると !== に変換（厳密不一致演算子）
call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '!',
    \   'input' : '!',
    \   })
call lexima#add_rule({'char': '!', 'at': '!\%#',   'input': '<BS> !== '})
call lexima#add_rule({'char': '!', 'at': ' !== \%#',    'input': '<BS><BS><BS><BS><BS>!'})

" +を繰り返し入力すると加算演算子とインクリメント演算子を切り替え
call lexima#add_rule({
    \   'at'    : '\%#',
    \   'char'  : '+',
    \   'input' : '+',
    \   })
call lexima#add_rule({'char': '+', 'at': '+\%#',   'input': '<BS> + '})
call lexima#add_rule({'char': '+', 'at': ' + \%#',    'input': '<BS><BS><BS>++'}) 
call lexima#add_rule({'char': '+', 'at': '++\%#',    'input': '<BS><BS>+'}) 

" /を繰り返し入力すると除算演算子とコメントを切り替え
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

" コマンドラインで特定のコマンドを別のコマンドに置き換える関数
" 例: omm → OpenMindMap
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

" コマンドエイリアスを定義するためのコマンド
command! -nargs=+ LeximaAlterCommand call <SID>lexima_alter_command(<f-args>)

" omm を OpenMindMap に変換するエイリアス
LeximaAlterCommand omm OpenMindMap
