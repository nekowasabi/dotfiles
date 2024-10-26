lua << EOF
local wk = require("which-key")

-- Core which-key setup
require("which-key").setup({
  preset = "modern", 
  notify = false,
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = tue,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    -- set to false to disable all mapping icons,
    -- both those explicitly added in a mapping
    -- and those from rules
    mappings = true,
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons from rules
    ---@type wk.IconRule[]|false
    rules = {},
    -- use the highlights from mini.icons
    -- When `false`, it will use `WhichKeyIcon` instead
    colors = true,
    -- used by key format
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "󰘴 ",
      M = "󰘵 ",
      D = "󰘳 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "󰁮",
      Space = "󱁐 ",
      Tab = "󰌒 ",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
      F12 = "󱊶",
    },
  },
})

-- Leader key groups
wk.register({
  ["<leader>a"] = { name = "+Aider/AI", icon = "🤖", group = "aider" },
  ["<leader>c"] = { name = "+Code/CoC", group = "coc" },
  -- ["<leader>p"] = { name = "+Project/Search", group = "ddu project" },
  ["<leader>v"] = { name = "+Avante", group = "avante" },
  ["<leader>u"] = { name = "+Test", group = "vim-test" },
  ["<leader>cl"] = { name = "+CoC List", group = "coc action" }
})

-- Navigation groups
wk.register({
  ["g"] = { 
    name = "+Go",
    group = "seeachx",
    b = { name = "+Comment Block", c = "Toggle Current Block" },
    c = {
      name = "+Comment",
      c = "Toggle Current Line",
      o = "Insert Below", 
      O = "Insert Above",
      A = "Insert End of Line"
    }
  },
  ["z"] = { name = "+Fold", group = "folding" },
  ["]"] = { name = "+Next", group = "next" },
  ["["] = { name = "+Prev", group = "prev" }
})

-- Text manipulation
wk.register({
  ["s"] = {
    name = "sandwich",
    group = "sandwich",
    a = { "<Plug>(operator-sandwich-add)", "Add Surrounding" },
    d = { "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)", "Delete Surrounding" },
    db = { "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)", "Delete Block" },
    r = { "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)", "Replace Surrounding" },
    rb = { "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)", "Replace Block" }
  }
}, { mode = "x", "o" })

-- AI/Chat features
wk.register({
  -- ["<C-c>"] = {
  --   name = "ddu-ai-connectors",
  --   mode = { "v" },
  --   icon = "🤖",
  --   group = "ddu",
  --   G = { "ddu with GpRewrite", "GPT Rewrite" },
  --   g = { "ddu with GpAppend>", "GPT Append" },
  --   c = { "ddu with CopilotChat", "Copilot Chat" },
  --   a = { "ddu with AiderAsk", "Aider Ask" },
  -- },
  --
  -- ["<leader>p"] = {
  --   name = "ddu Project",
  --   group = "ddu",
  --   v = { "DduGrepConfig", "Grep Config" },
  --   i = { "DduGrepForConstructorInjection", "Grep Constructor Injection" },
  --   w = { "DduGrepProjectWord", "Grep Project Word" },
  --   a = { "DduGrepProject", "Grep Project" },
  --   m = { "DduGrepChangelogHeader", "Grep Changelog Header" },
  --   c = { "DduGrepCurrentDirectory", "Grep Current Directory" }
  -- },


  -- ["<leader>"] = {
  --   g = { 
  --     f = { "ddu file_external", "File External" }
  --   },
  --   H = { "ddu help", "Help" },
  --   h = { "ddu command_history", "Command History" },
  --   l = {
  --     l = { "ddu line", "Fuzzy Line" }
  --   },
  -- ["<BS>"] = { "ddu buffer", "Buffer List", group = "ddu" },
  -- ["<D-b>"] = { "ddu vim-bookmark", "Bookmarks (CMD)", group = "ddu" },
  -- ["<M-b>"] = { "ddu vim-bookmark", "Bookmarks (Alt)", group = "ddu" },
  -- ["<D-a>"] = { "ddu aider'", "Aider (CMD)", group = "aider" },
  -- ["<M-a>"] = { "aider", "Aider (Alt)", group = "aider" },
  -- ["<CR><CR>"] = { "vim-bookmark", "Bookmarks", group = "ddu" }
})

-- Core mappings
wk.register({
  -- Navigation
  ["<M-Left>"] = { "<Plug>(backandforward-back)", "Navigate Back" },
  ["<M-Right>"] = { "<Plug>(backandforward-forward)", "Navigate Forward" },
  ["/"] = { "<Cmd>call searchx#start({ 'dir': 1 })<CR>", "Search Forward", group = "searchx" },
  ["?"] = { "<Cmd>call searchx#start({ 'dir': 0 })<CR>", "Search Backward", group = "searchx" },
  [":"] = { "<PageUp>", "Page Up" },
  [";"] = { "<PageDown>", "Page Down" },
  
  -- Text manipulation
  ["<C-Tab>"] = { "0i<Tab>", "Insert Tab at Start" },
  ["<S-Tab>"] = { "0x", "Delete First Character" },
  ["<F4>"] = { ":DuplicateLineFormatNormal<CR>", "Duplicate Line" },
  ["-"] = { "<Plug>(Switch)", "Switch" },
  ["."] = { "<Plug>(repeat-.)", "Repeat Last Command" },
  
  -- Window/Buffer management
  ["<C-Z>"] = { "<Esc>:SwitchPreviousBuffer<CR>", "Switch Buffer" },
  ["<D-z>"] = { ":ZoomOutliner<CR>", "Zoom Outliner" },
  ["<D-f>"] = { "za", "Toggle Fold" },
  
  -- Macros and special commands
  ["<C-S>"] = { "<Esc>:SwitchRule<CR>", "Switch Rule" },
  ["<C-U>"] = { "<Plug>(dmacro-play-macro)", "Play Macro" },
  
  -- AI/Chat features  
  ["<D-g>"] = { ":GpChatNew vsplit<CR>", "New GPT Chat", group = "gp.nvim" },
  ["<M-g>"] = { ":GpChatNew vsplit<CR>", "New GPT Chat", group = "gp.nvim" },
  
  -- Selection
  ["<D-p>"] = { ":normal! vip<CR>", "Select Paragraph" },
  ["<M-p>"] = { ":normal! vip<CR>", "Select Paragraph" },
}, {
  mode = "n",
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
})

-- Visual mode specific mappings
wk.register({
  [":"] = { ":", "Command Line" },
  [";"] = { "<PageDown>", "Page Down" },
  ["<"] = { "<gv", "Unindent and Reselect" },
  [">"] = { ">gv", "Indent and Reselect" },
}, { mode = "x" })

-- Sandwich mappings
wk.register({
  sa = { "<Plug>(operator-sandwich-g@)", "Add Sandwich", group = "sandwich" },
}, {
  mode = { "o", "x" },
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
  group = "sandwich"
})

-- Register comma mappings 
wk.register({
  [","] = {
    -- Octo & Test
    ops = { ":Octo pr search<CR>", "PR Search" },
    u = {
      name = "vim-test",
      v = { ":TestVisit<CR>", "Visit Test" },
      s = { ":TestSuite<CR>", "Test Suite" },
      l = { ":TestLast<CR>", "Last Test" },
      f = { ":TestFile<CR>", "Test File" },
      u = { ":TestNearest<CR>", "Nearest Test" }
    },
    -- GPChat & Git
    [","] = { 
      { ":GpChatNew vsplit<CR>", "New Chat", mode = "n" },
      { ":GpChatPaste vsplit<CR>", "Paste Chat", mode = "x" }
    },
    g = {
      name = "gitsign",
      h = { ":Gitsigns stage_hunk<CR>", "Stage Hunk", mode = { "n", "x" } },
      r = { ":Gitsigns reset_hunk<CR>", "Reset Hunk", mode = { "n", "x" } },
    },
    rw = { ":call ReplaceCurrentWordWithYank()<CR>", "Replace Word" },
    -- Hugo
    H = {
      name = "+Hugo",
      d = { ":HugoDeploy<CR>", "Deploy" },
      r = { ":HugoRunServer<CR>", "Run Server" },
      g = { ":HugoGeneratePost<CR>", "Generate Post" }
    },
    -- Changelog Operations
    p = { ":PushChangelog<CR>", "Push Changelog" },
    C = { ":MoveChangelogItemToTop<CR>", "Move to Top" },
    Cp = { "<Esc>:OpenChangelog<CR><C-Home>o<CR>i<C-R>=neosnippet#expand('cpp')<CR>", "New Changelog Post" },
    L = { ":buffer changelogmemo<CR><C-Home>o<CR>a<C-R>=neosnippet#expand('cpwd')<CR>", "Changelog Memo" },
    l = { "<Esc>:OpenChangelog<CR><C-Home>o<CR>i<C-R>=neosnippet#expand('cpw')<CR>", "Quick Changelog" },
    c = { "<Esc>:OpenChangelog<CR>:set showtabline=2<CR>", "Open Changelog" },
    -- Task & Utils
    T = { ":OpenOnlyTentask<CR>", "Open Tentask" },
    t = { ":OpenTentask<CR>GA", "Edit Tentask" },
    d = { ":CdCurrent<CR>", "CD Current" },
    cp = { ":CopyCurrentFilepath<CR>:echo \"Copied: \" . expand(\"%:p\")<CR>", "Copy Filepath" },
    rr = { ":<C-U>call <SNR>17_source_script('%')<CR>", "Source Script" }
  }
}, {
  mode = "n",
  prefix = ",",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
})

-- Space key mappings
wk.register({
  ["<Space>"] = {
    -- Table Mode
    T = { "<Plug>(table-mode-tableize-delimiter)", "Table Mode Delimiter", mode = "x" },
    t = { 
      t = { "<Plug>(table-mode-tableize)", "Table Mode", mode = { "n", "x" } }
    },
    -- Git
    g = {
      m = { "<Plug>(git-messenger)", "Git Messenger" },
      P = { ":GpContext<CR>", "GPT Context" , group = "gp" },
      r = { ":GpRewrite<Space>", "GPT Rewrite", mode = "v", group = "gp" },
    },
    -- Yanky & Utils
    y = { ":Telescope yank_history<CR>", "Yank History", group = "telescope" },
    s = { "SelectSwitchRule", "Switch Rule" },
    -- TreeSJ & Tools
    T = { "<Cmd>lua require('treesj').toggle()<CR>", "Toggle TreeSJ" },
    E = { ":Telescope emoji<CR>", "Emoji Picker" },
    F = { ":Oil<CR>", "Oil File Manager" },
    -- PHP Unit
    u = {
      name = "+PHPUnit",
      f = { ":PHPUnitCurrentFile<CR>", "Test File" },
      i = { ":PHPUnitCurrentMethodWithInitialize<CR>", "Test Method with Init" },
      u = { ":PHPUnitCurrentMethod<CR>", "Test Method" }
    },
    -- File & Window
    f = { ":Defx `expand('%:p:h')` -search=`expand('%:p')`<CR>", "File Explorer" },
    D = { ":Sayonara<CR>", "Close Buffer" },
    d = { ":Sayonara!<CR>", "Force Close Buffer" },
    W = { "<Plug>(choosewin)", "Choose Window" },
    -- Quit & Save
    Q = { ":call QuickExit()<CR>", "Quick Exit" },
    q = { ":call CloseQuickRunWindow()<CR>", "Close Quick Run" },
    e = { ":e!<CR>", "Reload File" },
    w = { ":wa!<CR>", "Save All" },
  }
}, {
  mode = "n",
  prefix = "<Space>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
})


-- Operator-pending mode mappings
wk.register({
  ["A"] = { "targets#e('o', 'A', 'A')", "Target A" },
  ["B"] = { "<Plug>JaSegmentMoveOB", "Segment Move Back" },
  ["E"] = { "<Plug>JaSegmentMoveOE", "Segment Move End" },
  ["F"] = { "<Plug>(clever-f-F)", "Clever F Backward" },
  ["I"] = { "targets#e('o', 'I', 'I')", "Target I" },
  ["W"] = { "<Plug>JaSegmentMoveOW", "Segment Move Word" },
  ["f"] = { "<Plug>(clever-f-f)", "Clever F Forward" },
}, { mode = 'o' })

-- Visual mode mappings  
wk.register({
  ["A"] = { "<Plug>(EasyAlign)", "Easy Align" },
  ["B"] = { "<Plug>JaSegmentMoveVB", "Segment Move Back" },
  ["E"] = { "<Plug>JaSegmentMoveVE", "Segment Move End" },
  ["F"] = { "<Plug>(clever-f-F)", "Clever F Backward" }, 
  ["H"] = { "10h", "Move Left 10" },
  ["I"] = { "targets#e('o', 'I', 'I')", "Target I" },
  ["P"] = { "<Plug>(YankyPutBefore)", "Yank Put Before" },
  ["W"] = { "<Plug>JaSegmentMoveVW", "Segment Move Word" },
  ["X"] = { "\"_X", "Delete Back" },
  ["f"] = { "<Plug>(clever-f-f)", "Clever F Forward" },
}, { mode = 'x' })

-- Text objects (shared between operator-pending and visual modes)
wk.register({
  ["a"] = {
    name = "+around",
    ["M"] = { "<Plug>(textobj-methodcall-chain-a)", "Method Chain" },
    ["m"] = { "<Plug>(textobj-methodcall-a)", "Method" },
    [","] = { "<Plug>(textobj-parameter-a)", "Parameter" },
    ["sb"] = { "<Plug>(textobj-multiblock-a)", "Multi Block" },
    ["f"] = { "<Plug>(textobj-functioncall-a)", "Function" },
    ["e"] = { "<Plug>(textobj-equation-a)", "Equation" },
    ["_"] = { "<Plug>(textobj-quoted-a)", "Quoted" },
    ["z"] = { "<Plug>(textobj-fold-a)", "Fold" },
    ["b"] = { "<Plug>(textobj-multitextobj-a)", "Multi Text Object" },
    ["`"] = { "2i`", "Back Quote" },
    ["'"] = { "2i'", "Single Quote" },
    ["j"] = {
      name = "+Japanese",
      ["Y"] = { "<Plug>(textobj-jabraces-double-yama-kakko-a)", "Double Yama Kakko" },
      ["k"] = { "<Plug>(textobj-jabraces-kakko-a)", "Kakko" },
      ["K"] = { "<Plug>(textobj-jabraces-double-kakko-a)", "Double Kakko" },
      ["]"] = { "<Plug>(textobj-jabraces-brackets-a)", "Brackets" },
      ["["] = { "<Plug>(textobj-jabraces-brackets-a)", "Brackets" },
      ["r"] = { "<Plug>(textobj-jabraces-brackets-a)", "Brackets" },
      [">"] = { "<Plug>(textobj-jabraces-angles-a)", "Angles" },
      ["<"] = { "<Plug>(textobj-jabraces-angles-a)", "Angles" },
      ["a"] = { "<Plug>(textobj-jabraces-angles-a)", "Angles" },
      ["A"] = { "<Plug>(textobj-jabraces-double-angles-a)", "Double Angles" },
      ["t"] = { "<Plug>(textobj-jabraces-kikkou-kakko-a)", "Kikkou Kakko" },
      ["s"] = { "<Plug>(textobj-jabraces-sumi-kakko-a)", "Sumi Kakko" },
      ["y"] = { "<Plug>(textobj-jabraces-yama-kakko-a)", "Yama Kakko" },
      [")"] = { "<Plug>(textobj-jabraces-parens-a)", "Parentheses" },
      ["("] = { "<Plug>(textobj-jabraces-parens-a)", "Parentheses" },
      ["b"] = { "<Plug>(textobj-jabraces-parens-a)", "Parentheses" },
      ["}"] = { "<Plug>(textobj-jabraces-braces-a)", "Braces" },
      ["{"] = { "<Plug>(textobj-jabraces-braces-a)", "Braces" },
      ["B"] = { "<Plug>(textobj-jabraces-braces-a)", "Braces" },
    }
  }
}, { mode = { "o", "x" } })

-- Operator mode mappings
wk.register({
  ["i<Space>"] = { "iw", "Inner Word" },
  ["i<CR>"] = { "iW", "Outer WORD" },
}, { mode = "o" })

-- Visual mode mappings
wk.register({
  ["<SNR>17_(command-line-enter)"] = { "q:", "Command Line History" },
  ["gx"] = { "<Plug>(openbrowser-smart-search)", "Open Browser Search" },
  ["i<CR>"] = { "iW", "Inner WORD" },
  ["sa"] = { "<Plug>(operator-sandwich-add)", "Add Surrounding" }
}, { mode = "x" })

EOF
