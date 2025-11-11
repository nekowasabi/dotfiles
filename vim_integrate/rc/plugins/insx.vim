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
-- ただしチェックボックス行では無効
insx.add(
  '[',
  insx.with(
    {
      enabled = function(ctx)
        local line = vim.api.nvim_get_current_line()
        -- 完全なチェックボックス行（- [ ] または - [x] の後に内容がある）では無効化
        if line:match('^%s*-%s%[[ x]%]%s') then
          return false
        end
        -- auto_pairのデフォルト条件を実行
        return require('insx.recipe.auto_pair')({
          open = '[',
          close = ']'
        }).enabled(ctx)
      end,
      action = function(ctx)
        return require('insx.recipe.auto_pair')({
          open = '[',
          close = ']'
        }).action(ctx)
      end
    },
    {
      insx.with.filetype({'changelog', 'octo', 'markdown', 'text', 'php', 'vim', 'typescript', 'javascript'})
    }
  )
)

-- ] の自動スキップ
-- カーソルが ] の直前にあるときに ] を入力すると、] をスキップする
-- ただしチェックボックス行では無効
insx.add(
  ']',
  insx.with(
    {
      enabled = function(ctx)
        local line = vim.api.nvim_get_current_line()
        -- 完全なチェックボックス行（- [ ] または - [x] の後に内容がある）では無効化
        if line:match('^%s*-%s%[[ x]%]%s') then
          return false
        end
        -- jump_nextのデフォルト条件を実行
        return require('insx.recipe.jump_next')({
          jump_pattern = [=[\]]=]
        }).enabled(ctx)
      end,
      action = function(ctx)
        return require('insx.recipe.jump_next')({
          jump_pattern = [=[\]]=]
        }).action(ctx)
      end
    },
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
        -- "- " の後に空白以外の文字がある行、ただしチェックボックスは除外
        return line:match('^%s*-%s%S') ~= nil
           and line:match('^%s*-%s%[[ x]%]') == nil
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
        -- "- [ ]" または "- [x]" の後に文字がある行（スペースは任意）
        return line:match('^%s*-%s%[[ x]%].*%S') ~= nil
      end,
      action = function(ctx)
        -- 行末に移動してから改行
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<End><CR>', true, false, true),
          'n',
          false
        )
        -- Luaで直接テキストを挿入（自動ペアを回避）
        vim.schedule(function()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, {'- [ ] '})
          vim.api.nvim_win_set_cursor(0, {row, col + 6})
        end)
      end
    },
    {
      insx.with.filetype({'changelog', 'octo', 'markdown', 'text'}),
      insx.with.priority(100)
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
  [[\%#]],
  { 'php' }
)

-- 行頭スペース後の > で -> を挿入
ft_substitute(
  '>',
  [[^\(\s*\)\%#]],
  [[\1->\%#]],
  { 'php'  }
)

-- ) の直後で > を入力すると -> を挿入
ft_substitute(
  '>',
  [[\()\)\%#]],
  [[\1->\%#]],
  { 'php'  }
)

-- $ の直後で $ を入力すると $this-> を挿入
ft_substitute(
  '$',
  [[\$\%#]],
  [[$this->\%#]],
  { 'php' }
)

-- $ の後（文字がある状態）で > を入力すると -> を挿入
ft_substitute(
  '>',
  [[\($.*\)\%#]],
  [[\1->\%#]],
  { 'php'  }
)

-- ' の直後で > を入力すると => を挿入
ft_substitute(
  '>',
  [=[\%#\ze']=],
  [[' => \%#]],
  { 'php' }
)

-- ============================================================================
-- General (all filetypes)
-- ============================================================================

-- セミコロンの自動配置

-- ) の直後でセミコロンを入力すると、) の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [[\%#\()\)]],
    replace = [[\1;\%#]]
  })
)

-- ] の直後でセミコロンを入力すると、] の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#\(]\)]=],
    replace = [=[\1;\%#]=]
  })
)

-- '' の直後でセミコロンを入力すると、' の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#\(''\)]=],
    replace = [=[\1;\%#]=]
  })
)

-- " 内でセミコロンを入力すると、" の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\(".*\)\%#"]=],
    replace = [=[\1";\%#]=]
  })
)

-- ' の直後でセミコロンを入力すると、' の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#\('\)]=],
    replace = [=[\1;\%#]=]
  })
)

-- ") でセミコロンを入力すると、) の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#\(")\)]=],
    replace = [=[\1;\%#]=]
  })
)

-- "] でセミコロンを入力すると、] の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#\("]\)]=],
    replace = [=[\1;\%#]=]
  })
)

-- ') でセミコロンを入力すると、) の右にセミコロンを配置
insx.add(
  ';',
  require('insx.recipe.substitute')({
    pattern = [=[\%#\(')\)]=],
    replace = [=[\1;\%#]=]
  })
)

-- '] でセミコロンを入力すると、] の右にセミコロンを配置
-- (注: この設定は '] の組み合わせに対応)
-- 実際には不要かもしれないが、lexima.vimにあったため追加

-- 演算子の自動スペース挿入

-- = のトグル：" = " → " === " → "="
-- 優先度を明示的に指定して、長いパターンから順にマッチさせる

-- ステップ1: 非空白直後の " === " → "=" (優先度: 100 - 最高)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\S\zs === \%#]],
      replace = [[=\%#]]
    }),
    { insx.with.priority(100) }
  )
)

-- ステップ1.5: 行頭の " === " → "=" (優先度: 95)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[^ === \%#]],
      replace = [[=\%#]]
    }),
    { insx.with.priority(95) }
  )
)

-- ステップ2: " = " → " === " (優先度: 80)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[ = \%#]],
      replace = [[ === \%#]]
    }),
    { insx.with.priority(80) }
  )
)

-- ステップ2.5: "=" → " = " (優先度: 65)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[=\%#]],
      replace = [[ = \%#]]
    }),
    { insx.with.priority(65) }
  )
)

-- ステップ3: 最初の = → "=" (優先度: 10 - 最低)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\%#]],
      replace = [[=\%#]]
    }),
    { insx.with.priority(10) }
  )
)

-- ステップ4: 非空白文字の直後の = → " = " (優先度: 60)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\S\zs=\%#]],
      replace = [[ = \%#]]
    }),
    { insx.with.priority(60) }
  )
)

-- ' の後で = を入力すると " = " を挿入 (優先度: 90)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [=[\%#']=],
      replace = [[<Right> = \%#]]
    }),
    { insx.with.priority(90) }
  )
)

-- ') の後で = を入力すると " = " を挿入 (優先度: 90)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [=[\%#')]=],
      replace = [[<Right><Right> = \%#]]
    }),
    { insx.with.priority(90) }
  )
)

-- ") の後で = を入力すると " = " を挿入 (優先度: 90)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [=[\%#")]=],
      replace = [[<Right><Right> = \%#]]
    }),
    { insx.with.priority(90) }
  )
)

-- '] の後で = を入力すると " = " を挿入 (優先度: 90)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [=[\%#']]=],
      replace = [[<Right><Right> = \%#]]
    }),
    { insx.with.priority(90) }
  )
)

-- "] の後で = を入力すると " = " を挿入 (優先度: 90)
insx.add(
  '=',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [=[\%#"]]=],
      replace = [[<Right><Right> = \%#]]
    }),
    { insx.with.priority(90) }
  )
)

-- % のトグル：" % " ⇄ " %% " ⇄ " % "
-- 優先度を明示的に指定して、長いパターンから順にマッチさせる

-- ステップ1: " %% " → " % " (優先度: 100 - 最高)
insx.add(
  '%',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[ %% \%#]],
      replace = [[ % \%#]]
    }),
    { insx.with.priority(100) }
  )
)

-- ステップ2: " % " → " %% " (優先度: 80)
insx.add(
  '%',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[ % \%#]],
      replace = [[ %% \%#]]
    }),
    { insx.with.priority(80) }
  )
)

-- ステップ2.5: "%%" → " %% " (優先度: 70)
insx.add(
  '%',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[%%\%#]],
      replace = [[ %% \%#]]
    }),
    { insx.with.priority(70) }
  )
)

-- ステップ2.8: "%" → "%%" (優先度: 65)
insx.add(
  '%',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[%\%#]],
      replace = [[%%\%#]]
    }),
    { insx.with.priority(65) }
  )
)

-- ステップ3: 最初の % → "%" (優先度: 10 - 最低)
insx.add(
  '%',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\%#]],
      replace = [[%\%#]]
    }),
    { insx.with.priority(10) }
  )
)

-- ステップ4: 非空白文字の直後の % → " % " (優先度: 60)
insx.add(
  '%',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\S\zs%\%#]],
      replace = [[ % \%#]]
    }),
    { insx.with.priority(60) }
  )
)

-- & のトグル：" & " ⇄ " && "
-- 優先度を明示的に指定して、長いパターンから順にマッチさせる

-- ステップ1: " && " → " & " (優先度: 100 - 最高)
insx.add(
  '&',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[ && \%#]],
      replace = [[ & \%#]]
    }),
    { insx.with.priority(100) }
  )
)

-- ステップ2: " & " → " && " (優先度: 80)
insx.add(
  '&',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[ & \%#]],
      replace = [[ && \%#]]
    }),
    { insx.with.priority(80) }
  )
)

-- ステップ2.5: "&&" → " && " (優先度: 70)
insx.add(
  '&',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[&&\%#]],
      replace = [[ && \%#]]
    }),
    { insx.with.priority(70) }
  )
)

-- ステップ2.8: "&" → "&&" (優先度: 65)
insx.add(
  '&',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[&\%#]],
      replace = [[&&\%#]]
    }),
    { insx.with.priority(65) }
  )
)

-- ステップ3: 最初の & → "&" (優先度: 10 - 最低)
insx.add(
  '&',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\%#]],
      replace = [[&\%#]]
    }),
    { insx.with.priority(10) }
  )
)

-- ステップ4: 非空白文字の直後の & → " & " (優先度: 60)
insx.add(
  '&',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\S\zs&\%#]],
      replace = [[ & \%#]]
    }),
    { insx.with.priority(60) }
  )
)

-- , のトグル：", " ⇄ ","
-- 特別ケース: ' の直後で , を入力すると ", " を挿入
-- （文字列の外側でのみ適用：後続文字が空白、括弧閉じ、カンマ、セミコロン、または行末の場合）
insx.add(
  ',',
  {
    enabled = function(ctx)
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      -- カーソルの直後が ' であることを確認
      if col < #line and line:sub(col + 1, col + 1) == "'" then
        -- 行末または後続文字が空白、括弧閉じ、カンマ、セミコロンの場合のみ適用
        if col + 1 >= #line then
          return true
        end
        local next_char = line:sub(col + 2, col + 2)
        return next_char:match('[%s%)%],;]') ~= nil
      end
      return false
    end,
    action = function(ctx)
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<Right>, ', true, false, true),
        'n',
        false
      )
    end
  }
)

-- 特別ケース: " の直後で , を入力すると ", " を挿入
-- （文字列の外側でのみ適用：後続文字が空白、括弧閉じ、カンマ、セミコロン、または行末の場合）
insx.add(
  ',',
  {
    enabled = function(ctx)
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      -- カーソルの直後が " であることを確認
      if col < #line and line:sub(col + 1, col + 1) == '"' then
        -- 行末または後続文字が空白、括弧閉じ、カンマ、セミコロンの場合のみ適用
        if col + 1 >= #line then
          return true
        end
        local next_char = line:sub(col + 2, col + 2)
        return next_char:match('[%s%)%],;]') ~= nil
      end
      return false
    end,
    action = function(ctx)
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<Right>, ', true, false, true),
        'n',
        false
      )
    end
  }
)

-- ステップ1: ", " → ","（最も長いパターンを先に）
insx.add(
  ',',
  require('insx.recipe.substitute')({
    pattern = [[, \%#]],
    replace = [[,\%#]]
  })
)

-- ステップ2: "," → ", "
insx.add(
  ',',
  require('insx.recipe.substitute')({
    pattern = [[,\%#]],
    replace = [[, \%#]]
  })
)

-- ステップ3: 最初の , → ", "（非空白文字の直後）
insx.add(
  ',',
  require('insx.recipe.substitute')({
    pattern = [[\S\zs\%#]],
    replace = [[, \%#]]
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

-- ! のトグル：! → "!!" → " !== " → "!"
-- 優先度を明示的に指定して、長いパターンから順にマッチさせる

-- ステップ1: " !== " → "!" (優先度: 100 - 最高)
insx.add(
  '!',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[ !== \%#]],
      replace = [[!\%#]]
    }),
    { insx.with.priority(100) }
  )
)

-- ステップ2: "!!" → " !== " (優先度: 80)
insx.add(
  '!',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[!!\%#]],
      replace = [[ !== \%#]]
    }),
    { insx.with.priority(80) }
  )
)

-- ステップ3: "!" → "!!" (優先度: 65)
insx.add(
  '!',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[!\%#]],
      replace = [[!!\%#]]
    }),
    { insx.with.priority(65) }
  )
)

-- ステップ4: 最初の ! → "!" (優先度: 10 - 最低)
insx.add(
  '!',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\%#]],
      replace = [[!\%#]]
    }),
    { insx.with.priority(10) }
  )
)

-- + のトグル：+ → " + " → "++" → "+"
-- 優先度を明示的に指定して、長いパターンから順にマッチさせる

-- ステップ3: " + " → "++" (優先度: 100 - 最高)
insx.add(
  '+',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[ + \%#]],
      replace = [[++\%#]]
    }),
    { insx.with.priority(100) }
  )
)

-- ステップ4: "++" → "+" (優先度: 90)
insx.add(
  '+',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[++\%#]],
      replace = [[+\%#]]
    }),
    { insx.with.priority(90) }
  )
)

-- ステップ2: "+" → " + " (優先度: 60)
insx.add(
  '+',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[+\%#]],
      replace = [[ + \%#]]
    }),
    { insx.with.priority(60) }
  )
)

-- ステップ1: 何もない → "+" (優先度: 10 - 最低)
insx.add(
  '+',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\%#]],
      replace = [[+\%#]]
    }),
    { insx.with.priority(10) }
  )
)

-- / のトグル：/ → " / " → "// " → "//" → "/"
-- 優先度を明示的に指定して、長いパターンから順にマッチさせる

-- ステップ4: "// " → "//" (優先度: 100 - 最高)
insx.add(
  '/',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[// \%#]],
      replace = [[//\%#]]
    }),
    { insx.with.priority(100) }
  )
)

-- ステップ5: "//" → "/" (優先度: 90)
insx.add(
  '/',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[//\%#]],
      replace = [[/\%#]]
    }),
    { insx.with.priority(90) }
  )
)

-- ステップ3: " / " → "// " (優先度: 80)
insx.add(
  '/',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[ / \%#]],
      replace = [[// \%#]]
    }),
    { insx.with.priority(80) }
  )
)

-- ステップ2: "/" → " / " (優先度: 60)
insx.add(
  '/',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[/\%#]],
      replace = [[ / \%#]]
    }),
    { insx.with.priority(60) }
  )
)

-- ステップ1: 何もない → "/" (優先度: 10 - 最低)
insx.add(
  '/',
  insx.with(
    require('insx.recipe.substitute')({
      pattern = [[\%#]],
      replace = [[/\%#]]
    }),
    { insx.with.priority(10) }
  )
)

-- ' の自動ペア
insx.add(
  "'",
  require('insx.recipe.auto_pair')({
    open = "'",
    close = "'"
  })
)

-- ' の自動スキップ
insx.add(
  "'",
  require('insx.recipe.jump_next')({
    jump_pattern = [=[\']=]
  })
)

-- ' のペア削除
insx.add(
  '<BS>',
  require('insx.recipe.delete_pair')({
    open_pat = [=[\']=],
    close_pat = [=[\']=]
  })
)

-- " の自動ペア
insx.add(
  '"',
  require('insx.recipe.auto_pair')({
    open = '"',
    close = '"'
  })
)

-- " の自動スキップ
insx.add(
  '"',
  require('insx.recipe.jump_next')({
    jump_pattern = [=["]=]
  })
)

-- " のペア削除
insx.add(
  '<BS>',
  require('insx.recipe.delete_pair')({
    open_pat = [=["]=],
    close_pat = [=["]=]
  })
)

-- ( の自動ペア
insx.add(
  '(',
  require('insx.recipe.auto_pair')({
    open = '(',
    close = ')'
  })
)

-- ( のペア削除
insx.add(
  '<BS>',
  require('insx.recipe.delete_pair')({
    open_pat = [=[(]=],
    close_pat = [=[)]=]
  })
)

-- ` の自動ペア
insx.add(
  '`',
  require('insx.recipe.auto_pair')({
    open = '`',
    close = '`'
  })
)

-- ` の自動スキップ
insx.add(
  '`',
  require('insx.recipe.jump_next')({
    jump_pattern = [=[`]=]
  })
)

-- ` のペア削除
insx.add(
  '<BS>',
  require('insx.recipe.delete_pair')({
    open_pat = [=[`]=],
    close_pat = [=[`]=]
  })
)

EOF

