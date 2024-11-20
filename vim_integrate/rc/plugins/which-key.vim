lua << EOF
local wk = require("which-key")

-- Core which-key setup
require("which-key").setup({
  preset = "helix", 
  notify = false,
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 30,
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

-- Navigation groups
wk.add({
  { "gb",  desc = "+Comment Block" },
  { "gbc", desc = "Toggle Current Block" },
  { "gc",  desc = "+Comment" },
  { "gcc", desc = "Toggle Current Line" },
  { "gco", desc = "Insert Below" },
  { "gcO", desc = "Insert Above" },
  { "gcA", desc = "Insert End of Line" },
  { "z",   desc = "+Fold" },
  { "]",   desc = "+Next" },
  { "[",   desc = "+Prev" }
})

-- edge-motion
wk.add({
  { "<C-x>j", desc = "<Plug>(edgemotion-j)" },
  { "<C-x>k", desc = "<Plug>(edgemotion-k)" },
})


-- ddu
wk.add({
  { "<leader>gf", desc = "ddu File External" },
  { "<leader>H", desc = "ddu Help" },
  { "<leader>h", desc = "ddu Command History" },
  { "<leader>ll", desc = "ddu Fuzzy Line" }
})

wk.add({
  { mode = "n" },
  { "<BS>", desc = "Buffer List" },
  { "<D-b>", desc = "Bookmarks (CMD)" },
  { "<M-b>", desc = "Bookmarks (Alt)" },
  { "<D-a>", desc = "Aider (CMD)" },
  { "<M-a>", desc = "Aider (Alt)" },
  { "<CR><CR>", desc = "ddu mru" },
  { "<CR>", desc = "ddu mru" },
})


wk.add({
  { "<C-c>G", desc = "ddu with GpRewrite", mode = "v", icon = "🤖" },
  { "<C-c>a", desc = "ddu with AiderAsk", mode = "v", icon = "🤖" },
  { "<C-c>c", desc = "ddu with CopilotChat", mode = "v", icon = "🤖" },
  { "<C-c>g", desc = "ddu with GpAppend", mode = "v", icon = "🤖" }
})

wk.add({
  { "<leader>pa",  desc = "Grep Project", group = "ddu Project" },
  { "<leader>pc",  desc = "Grep Current Directory", group = "ddu Project" },
  { "<leader>pi",  desc = "Grep Constructor Injection", group = "ddu Project" },
  { "<leader>pm",  desc = "Grep Changelog Header", group = "ddu Project" },
  { "<leader>pv",  desc = "Grep Config", group = "ddu Project" },
  { "<leader>pw",  desc = "Grep Project Word", group = "ddu Project" }
})

-- Core mappings
wk.add({
  { "<M-Left>",  desc = "Navigate Back", mode = "n" },
  { "<M-Right>", desc = "Navigate Forward", mode = "n" },
  { "/",         desc = "Search Forward", mode = "n" },
  { "?",         desc = "Search Backward", mode = "n" },
  { ":",         desc = "Page Up", mode = "n" },
  { ";",         desc = "Page Down", mode = "n" },
  { "<C-Tab>",   desc = "Insert Tab at Start", mode = "n" },
  { "<S-Tab>",   desc = "Delete First Character", mode = "n" },
  { "<F4>",      desc = "Duplicate Line", mode = "n" },
  { "-",         desc = "Switch", mode = "n" },
  { ".",         desc = "Repeat Last Command", mode = "n" },
  { "<C-Z>",     desc = "Switch Buffer", mode = "n" },
  { "<D-z>",     desc = "Zoom Outliner", mode = "n" },
  { "<D-f>",     desc = "Toggle Fold", mode = "n" },
  { "<C-S>",     desc = "Switch Rule", mode = "n" },
  { "<C-U>",     desc = "Play Macro", mode = "n" },
  { "<D-g>",     desc = "New GPT Chat", mode = "n" },
  { "<M-g>",     desc = "New GPT Chat", mode = "n" },
  { "<D-p>",     desc = "Select Paragraph", mode = "n" },
  { "<M-p>",     desc = "Select Paragraph", mode = "n" },
})

-- Visual mode specific mappings
wk.add({
  { ":", desc = "Command Line", mode = "x" },
  { ";", desc = "Page Down", mode = "x" },
  { "<", desc = "Unindent and Reselect", mode = "x" },
  { ">", desc = "Indent and Reselect", mode = "x" }
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
      c = {
        name = "+CopilotChat",
        r = { ":CopilotChatReview", "Review", mode = "v" },
        e = { ":CopilotChatExplain", "Explain", mode = "v" },
        c = { 
          { ":CopilotChat", "Chat", mode = "n" },
          { ":CopilotChat", "Chat Selection", mode = "v" }
        },
        f = { ":CopilotChatFix", "Fix", mode = "v" },
        o = { ":CopilotChatOptimize", "Optimize", mode = "v" },
      },
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
    f = { ":Yazi", "File Explorer" },
    D = { ":Sayonara<CR>", "Close Buffer" },
    d = { ":Sayonara!<CR>", "Force Close Buffer" },
    w = { "<Plug>(choosewin)", "Choose Window" },
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
wk.add({
  { "A", "targets#e('o', 'A', 'A')", desc = "Target A", mode = "o" },
  { "B", "<Plug>JaSegmentMoveOB", desc = "Segment Move Back", mode = "o" },
  { "E", "<Plug>JaSegmentMoveOE", desc = "Segment Move End", mode = "o" },
  { "F", "<Plug>(clever-f-F)", desc = "Clever F Backward", mode = "o" },
  { "I", "targets#e('o', 'I', 'I')", desc = "Target I", mode = "o" },
  { "W", "<Plug>JaSegmentMoveOW", desc = "Segment Move Word", mode = "o" },
  { "f", "<Plug>(clever-f-f)", desc = "Clever F Forward", mode = "o" }
})

-- Visual mode mappings  
wk.add({
  { "A", desc = "Easy Align", mode = "x" },
  { "B", desc = "Segment Move Back", mode = "x" },
  { "E", desc = "Segment Move End", mode = "x" },
  { "F", desc = "Clever F Backward", mode = "x" },
  { "H", desc = "Move Left 10", mode = "x" },
  { "P", desc = "Yank Put Before", mode = "x" },
  { "W", desc = "Segment Move Word", mode = "x" },
  { "f", desc = "Clever F Forward", mode = "x" }
})

-- Text objects (shared between operator-pending and visual modes)
wk.add({
  { "aM", desc = "Method Chain", mode = { "o", "x" } },
  { "am", desc = "Method", mode = { "o", "x" } },
  { "a,", desc = "Parameter", mode = { "o", "x" } },
  { "asb", desc = "Multi Block", mode = { "o", "x" } },
  { "af", desc = "Function", mode = { "o", "x" } },
  { "ae", desc = "Equation", mode = { "o", "x" } },
  { "a_", desc = "Quoted", mode = { "o", "x" } },
  { "az", desc = "Fold", mode = { "o", "x" } },
  { "ab", desc = "Multi Text Object", mode = { "o", "x" } },
  { "a`", desc = "Back Quote", mode = { "o", "x" } },
  { "a'", desc = "Single Quote", mode = { "o", "x" } },
  -- Japanese text objects
  { "ajY", desc = "Double Yama Kakko", mode = { "o", "x" } },
  { "ajk", desc = "Kakko", mode = { "o", "x" } },
  { "ajK", desc = "Double Kakko", mode = { "o", "x" } },
  { "aj]", desc = "Brackets", mode = { "o", "x" } },
  { "aj[", desc = "Brackets", mode = { "o", "x" } },
  { "ajr", desc = "Brackets", mode = { "o", "x" } },
  { "aj>", desc = "Angles", mode = { "o", "x" } },
  { "aj<", desc = "Angles", mode = { "o", "x" } },
  { "aja", desc = "Angles", mode = { "o", "x" } },
  { "ajA", desc = "Double Angles", mode = { "o", "x" } },
  { "ajt", desc = "Kikkou Kakko", mode = { "o", "x" } },
  { "ajs", desc = "Sumi Kakko", mode = { "o", "x" } },
  { "ajy", desc = "Yama Kakko", mode = { "o", "x" } },
  { "aj)", desc = "Parentheses", mode = { "o", "x" } },
  { "aj(", desc = "Parentheses", mode = { "o", "x" } },
  { "ajb", desc = "Parentheses", mode = { "o", "x" } },
  { "aj}", desc = "Braces", mode = { "o", "x" } },
  { "aj{", desc = "Braces", mode = { "o", "x" } },
  { "ajB", desc = "Braces", mode = { "o", "x" } },
  -- Operator mode specific
  { "i<Space>", desc = "Inner Word", mode = "o" },
  { "i<CR>", desc = "Outer WORD", mode = "o" },
  { "i<CR>", desc = "Inner WORD", mode = "x" },
  { "gx", desc = "Open Browser Search", mode = "x" },
  { "sa", desc = "Add Surrounding", mode = "x" }
})

EOF
