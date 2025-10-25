" ============================================================================
" nvim-insx configuration
" Migrated from lexima.vim on 2025-10-25
" ============================================================================
"
" This file contains input assistance rules using nvim-insx plugin.
" Original settings were in rc/plugins/lexima.vim
"
" nvim-insx repository: https://github.com/hrsh7th/nvim-insx
"
" ============================================================================

lua << EOF
local insx = require('insx')

-- ============================================================================
-- Helper Functions
-- ============================================================================

-- Create a substitute recipe with filetype restriction
local function ft_substitute(char, pattern, replace, filetypes)
  insx.add(
    char,
    insx.with(
      require('insx.recipe.substitute')({
        pattern = pattern,
        replace = replace
      }),
      {
        insx.with.filetype(filetypes)
      }
    )
  )
end

-- Create a simple action recipe with filetype restriction
local function ft_action(char, pattern, action_fn, filetypes)
  insx.add(
    char,
    insx.with(
      {
        enabled = function(ctx)
          return ctx.match(pattern) ~= nil
        end,
        action = action_fn
      },
      {
        insx.with.filetype(filetypes)
      }
    )
  )
end

-- ============================================================================
-- Filetype: changelog, octo, markdown, text
-- ============================================================================

-- # のスペース自動挿入
-- 行頭で # を入力すると "# " に展開
ft_substitute(
  '#',
  [[^\%#\%(#\)\@!]],
  [[#<Space>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)

-- ## の連続入力サポート
-- "# " の状態で再度 # を入力すると "## " に変換
ft_substitute(
  '#',
  [[#\s\%#]],
  [[##<Space>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)


-- # の削除（Backspace）
-- "# " の状態で Ctrl-h を押すと完全削除
ft_substitute(
  '<C-h>',
  [[^#\s\%#]],
  [[\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)

-- ## の削除（Backspace） - 1段階戻す
ft_substitute(
  '<C-h>',
  [[##\s\%#]],
  [[#<Space>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)

-- # の削除（BS キー）
ft_substitute(
  '<BS>',
  [[^#\s\%#]],
  [[\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)
ft_substitute(
  '<BS>',
  [[##\s\%#]],
  [[#<Space>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)

-- [ の自動ペア
-- [ を入力すると "[]" になり、カーソルが中に配置される
insx.add(
  '[',
  insx.with(
    require('insx.recipe.auto_pair')({
      open = '[',
      close = ']'
    }),
    {
      insx.with.filetype({'changelog', 'octo', 'markdown', 'text'})
    }
  )
)

-- ] の自動スキップ
-- カーソルが ] の直前にあるときに ] を入力すると、] をスキップする
insx.add(
  ']',
  insx.with(
    require('insx.recipe.jump_next')({
      jump_pattern = [=[\]]=]
    }),
    {
      insx.with.filetype({'changelog', 'octo', 'markdown', 'text'})
    }
  )
)

-- [] のBackspace削除
-- カーソルが [] の間にあるときにBackspaceを押すと、両方削除
insx.add(
  '<BS>',
  insx.with(
    require('insx.recipe.delete_pair')({
      open_pat = [=[\[]=],
      close_pat = [=[\]]=]
    }),
    {
      insx.with.filetype({'changelog', 'octo', 'markdown', 'text'})
    }
  )
)

-- - のリスト入力補助
-- 行頭で - を入力すると "- " に展開
ft_substitute(
  '-',
  [[^\s*\%#]],
  [[-<Space>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)

-- Backspace でリストマーカー削除
ft_substitute(
  '<C-h>',
  [[^-\s\%#]],
  [[<C-w>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)
ft_substitute(
  '<C-h>',
  [[^\s+-\s\%#]],
  [[<C-w><C-w>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)
ft_substitute(
  '<BS>',
  [[^-\s\%#]],
  [[<C-w>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)
ft_substitute(
  '<BS>',
  [[^\s+-\s\%#]],
  [[<C-w><C-w>\%#]],
  { 'changelog', 'octo', 'markdown', 'text' }
)

-- Enter でリスト継続（カスタムアクション版）
-- カーソル位置に関わらず、元の行のテキストを保持したまま新しい行に「- 」を挿入
insx.add(
  '<CR>',
  insx.with(
    {
      enabled = function(ctx)
        local line = vim.api.nvim_get_current_line()
        -- "- " の後に空白以外の文字がある行
        return line:match('^%s*-%s%S') ~= nil
      end,
      action = function(ctx)
        -- 行末に移動してから改行し、新しい行に「- 」を挿入
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<End><CR>-<Space>', true, false, true),
          'n',
          false
        )
      end
    },
    {
      insx.with.filetype({'changelog', 'octo', 'markdown', 'text'})
    }
  )
)

-- チェックボックス（チェック済み/未チェック）での Enter（リスト継続）
-- カーソル位置に関わらず、元の行のテキストを保持したまま新しい行に「- [ ] 」を挿入
insx.add(
  '<CR>',
  insx.with(
    {
      enabled = function(ctx)
        local line = vim.api.nvim_get_current_line()
        -- "- [ ]" または "- [x]" の後に空白以外の文字がある行
        return line:match('^%s*-%s%[[ x]%]%s%S') ~= nil
      end,
      action = function(ctx)
        -- 行末に移動してから改行し、新しい行に「- [ ] 」を挿入、カーソルを[]内に配置
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<End><CR>-<Space>[]<Space><Left><Left>', true, false, true),
          'n',
          false
        )
      end
    },
    {
      insx.with.filetype({'changelog', 'octo', 'markdown', 'text'})
    }
  )
)

-- 「・」の改行継続（カスタムアクション版）
-- カーソル位置に関わらず、元の行のテキストを保持したまま新しい行に「・」を挿入
insx.add(
  '<CR>',
  insx.with(
    {
      enabled = function(ctx)
        local line = vim.api.nvim_get_current_line()
        return line:match('^%s*・') ~= nil
      end,
      action = function(ctx)
        -- 行末に移動してから改行し、新しい行に「・」を挿入
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<End><CR>・', true, false, true),
          'n',
          false
        )
      end
    },
    {
      insx.with.filetype({'changelog','text'})
    }
  )
)

-- ]の直前で:を入力すると]の後ろにコロンを配置
insx.add(
  ':',
  insx.with(
    {
      enabled = function(ctx)
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        -- カーソル位置の次の文字が ] かどうか
        return col < #line and line:sub(col + 1, col + 1) == ']'
      end,
      action = function(ctx)
        -- ]をスキップしてコロンを入力
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<Right>:', true, false, true),
          'n',
          false
        )
      end
    },
    {
      insx.with.filetype({'changelog', 'octo', 'markdown', 'text'})
    }
  )
)

-- ============================================================================
-- Filetype: text
-- ============================================================================


-- ============================================================================
-- Filetype: markdown
-- ============================================================================


-- ============================================================================
-- Filetype: octo
-- ============================================================================


-- ============================================================================
-- Filetype: php
-- ============================================================================

-- -> の削除（Backspace）
ft_substitute(
  '<BS>',
  [[->\%#]],
  [[<BS><BS>\%#]],
  { 'php' }
)

-- 行頭スペース後の > で -> を挿入
ft_substitute(
  '>',
  [[^ *\%#]],
  [[->\%#]],
  { 'php'  }
)

-- ) の直後で > を入力すると -> を挿入
ft_substitute(
  '>',
  [[)\%#]],
  [[->\%#]],
  { 'php'  }
)

-- $ の直後で $ を入力すると $this-> を挿入
ft_substitute(
  '$',
  [[$\%#]],
  [[this->\%#]],
  { 'php'  }
)

-- $ の後（文字がある状態）で > を入力すると -> を挿入
ft_substitute(
  '>',
  [[$.*\%#]],
  [[->\%#]],
  { 'php'  }
)

-- ) の後で > を入力すると -> を挿入
ft_substitute(
  '>',
  [[.*)\%#]],
  [[->\%#]],
  { 'php'  }
)

-- ' の直後で > を入力すると => を挿入
ft_substitute(
  '>',
  [=[\%#']=],
  [[<Right> => \%#]],
  { 'php'  }
)

-- ============================================================================
-- General (all filetypes)
-- ============================================================================

-- セミコロンの自動配置

-- ) の直後でセミコロンを入力すると、) の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [[\%#)]],
    replace = [[<Right>;\%#]]
  })
)

-- ] の直後でセミコロンを入力すると、] の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#]]=],
    replace = [[<Right>;\%#]]
  })
)

-- '' の直後でセミコロンを入力すると、' の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#'']=],
    replace = [[<Right><Right>;\%#]]
  })
)

-- " 内でセミコロンを入力すると、" の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[".*\%#"]=],
    replace = [[<Right>;\%#]]
  })
)

-- ' の直後でセミコロンを入力すると、' の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#']=],
    replace = [[<Right>;\%#]]
  })
)

-- ") でセミコロンを入力すると、) の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#")]=],
    replace = [[<Right><Right>;\%#]]
  })
)

-- "] でセミコロンを入力すると、] の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#"]=],
    replace = [[<Right><Right>;\%#]]
  })
)

-- ') でセミコロンを入力すると、) の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#')]=],
    replace = [[<Right><Right>;\%#]]
  })
)

-- '] でセミコロンを入力すると、] の右にセミコロンを配置
-- (注: この設定は '] の組み合わせに対応)
-- 実際には不要かもしれないが、lexima.vimにあったため追加

-- 演算子の自動スペース挿入

-- = のトグル：= → " = " → "==" → "===" → "="
insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [=[\%#]]=],
    replace = [[ = \%#]]
  })
)

insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [[ = \%#]],
    replace = [[<BS><BS><BS>=\%#]]
  })
)

insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [[=\%#]],
    replace = [[<BS> == \%#]]
  })
)

insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [[ == \%#]],
    replace = [[<BS><BS><BS>=== \%#]]
  })
)

insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [[ === \%#]],
    replace = [[<BS><BS><BS><BS>= \%#]]
  })
)

-- ' の後で = を入力すると " = " を挿入
insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [=[\%#']=],
    replace = [[<Right> = \%#]]
  })
)

-- ') の後で = を入力すると " = " を挿入
insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [=[\%#')]=],
    replace = [[<Right><Right> = \%#]]
  })
)

-- ") の後で = を入力すると " = " を挿入
insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [=[\%#")]=],
    replace = [[<Right><Right> = \%#]]
  })
)

-- '] の後で = を入力すると " = " を挿入
insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [=[\%#']=],
    replace = [[<Right><Right> = \%#]]
  })
)

-- "] の後で = を入力すると " = " を挿入
insx.add(
  '=',
  require('insx.recipe.substitute')({
    pattern = [=[\%#"]=],
    replace = [[<Right><Right> = \%#]]
  })
)

-- % のトグル：% → " % " → "%"
insx.add(
  '%',
  require('insx.recipe.substitute')({
    pattern = [=[\%#]]=],
    replace = [[ % \%#]]
  })
)

insx.add(
  '%',
  require('insx.recipe.substitute')({
    pattern = [[ % \%#]],
    replace = [[<BS><BS><BS>%\%#]]
  })
)

insx.add(
  '%',
  require('insx.recipe.substitute')({
    pattern = [[%\%#]],
    replace = [[<BS> % \%#]]
  })
)

-- & のトグル：& → " & " → " && " → "&"
insx.add(
  '&',
  require('insx.recipe.substitute')({
    pattern = [=[\%#]]=],
    replace = [[ & \%#]]
  })
)

insx.add(
  '&',
  require('insx.recipe.substitute')({
    pattern = [[ & \%#]],
    replace = [[<BS><BS><BS> && \%#]]
  })
)

insx.add(
  '&',
  require('insx.recipe.substitute')({
    pattern = [[ && \%#]],
    replace = [[<BS><BS><BS><BS>&\%#]]
  })
)

insx.add(
  '&',
  require('insx.recipe.substitute')({
    pattern = [[&\%#]],
    replace = [[<BS> & \%#]]
  })
)

-- , のトグル：, → ", " → ","
insx.add(
  ',',
  require('insx.recipe.substitute')({
    pattern = [=[\%#]]=],
    replace = [[, \%#]]
  })
)

insx.add(
  ',',
  require('insx.recipe.substitute')({
    pattern = [[, \%#]],
    replace = [[<BS><BS>,\%#]]
  })
)

insx.add(
  ',',
  require('insx.recipe.substitute')({
    pattern = [[,\%#]],
    replace = [[<BS>, \%#]]
  })
)

-- ' の直後で < を入力すると ", " を挿入（lexima.vimのルールより）
insx.add(
  '<',
  require('insx.recipe.substitute')({
    pattern = [=[\%#']=],
    replace = [[<Right>, \%#]]
  })
)

-- ! のトグル：! → " !== " → "!"
insx.add(
  '!',
  require('insx.recipe.substitute')({
    pattern = [=[\%#]]=],
    replace = [[!\%#]]
  })
)

insx.add(
  '!',
  require('insx.recipe.substitute')({
    pattern = [[!\%#]],
    replace = [[<BS> !== \%#]]
  })
)

insx.add(
  '!',
  require('insx.recipe.substitute')({
    pattern = [[ !== \%#]],
    replace = [[<BS><BS><BS><BS><BS>!\%#]]
  })
)

-- + のトグル：+ → " + " → "++" → "+"
insx.add(
  '+',
  require('insx.recipe.substitute')({
    pattern = [=[\%#]]=],
    replace = [[+\%#]]
  })
)

insx.add(
  '+',
  require('insx.recipe.substitute')({
    pattern = [[+\%#]],
    replace = [[<BS> + \%#]]
  })
)

insx.add(
  '+',
  require('insx.recipe.substitute')({
    pattern = [[ + \%#]],
    replace = [[<BS><BS><BS>++\%#]]
  })
)

insx.add(
  '+',
  require('insx.recipe.substitute')({
    pattern = [[++\%#]],
    replace = [[<BS><BS>+\%#]]
  })
)

-- / のトグル：/ → " / " → "// " → "//" → "/"
insx.add(
  '/',
  require('insx.recipe.substitute')({
    pattern = [=[\%#]]=],
    replace = [[/\%#]]
  })
)

insx.add(
  '/',
  require('insx.recipe.substitute')({
    pattern = [[/\%#]],
    replace = [[<BS> / \%#]]
  })
)

insx.add(
  '/',
  require('insx.recipe.substitute')({
    pattern = [[ / \%#]],
    replace = [[<BS><BS><BS>// \%#]]
  })
)

insx.add(
  '/',
  require('insx.recipe.substitute')({
    pattern = [[// \%#]],
    replace = [[<BS><BS><BS>//\%#]]
  })
)

insx.add(
  '/',
  require('insx.recipe.substitute')({
    pattern = [[//\%#]],
    replace = [[<BS><BS>/\%#]]
  })
)

-- ) の直後で > を入力すると " => " を挿入
insx.add(
  '>',
  require('insx.recipe.substitute')({
    pattern = [[)\%#]],
    replace = [[ => \%#]]
  })
)

EOF

