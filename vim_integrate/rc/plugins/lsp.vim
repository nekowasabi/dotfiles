" LSP キーバインド設定
" - CoC filetypes (vim,typescript,php,json,go,lua,sh,python,javascript,vue,yaml,blade): coc.vim で設定
" - markdown: nvim-lsp (storyteller LSP) を使用（下部のLuaで設定）
" - その他: nvim-lsp ビルトインコマンドを使用（下部のLuaで設定）

lua << EOF

-- ligthtlineで使用するため、インストールだけはしておく
require('lspsaga').setup({
  symbol_in_winbar = {
    enable = false,
    separator = " > ",
    show_file = true,
    folder_level = 2,
    click_support = false,
  },
})


require("mason").setup({
  log_level = vim.log.levels.ERROR,
  -- 起動時の通知を無効化
  ui = {
    check_outdated_packages_on_open = false,
  },
  -- レジストリの自動更新を無効化（手動で :MasonUpdate を実行）
  registries = {
    "github:mason-org/mason-registry",
  },
  -- pip upgrade通知も無効化
  pip = {
    upgrade_pip = false,
  },
})
local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
-- storyteller LSPがファイル監視を動的登録できるようにする
-- false だと client/registerCapability が無視される
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- vim.lsp.set_log_level("trace")

-- Helper: find root directory by marker files
local function find_root(markers)
  return function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then return nil end
    local dir = vim.fn.fnamemodify(path, ":h")
    while dir ~= "/" do
      for _, marker in ipairs(markers) do
        if vim.uv.fs_stat(dir .. "/" .. marker) then
          if on_dir then on_dir(dir) end
          return dir
        end
      end
      dir = vim.fn.fnamemodify(dir, ":h")
    end
    return nil
  end
end

-- Deno LSP configuration (Neovim 0.11+ vim.lsp.config API)
vim.lsp.config("denols", {
  cmd = { "deno", "lsp" },
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_dir = find_root({ "deno.json", "deno.jsonc", "import_map.json" }),
  capabilities = capabilities,
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true
          }
        }
      },
      inlayHints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        functionReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
      },
      unstable = true,
      codeLens = {
        implementations = true,
        references = true,
      },
      lint = true,
    },
  },
})

-- Enable denols for TypeScript/JavaScript in Deno projects
vim.lsp.enable("denols")


-- vim.lsp.config("pyright", {})

vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc')) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      },
    })
    end,
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        },
      }
      }
    })

-- storyteller LSP (物語作成支援ツール)
-- g:IsMacNeovimInWork() が false のときのみ有効化
if not vim.fn.IsMacNeovimInWork() then
  -- セマンティックトークンの優先度をTreesitter/Syntaxより高く設定
  -- HTMLコメント内の伏線アノテーションが正しくハイライトされるようにする
  vim.hl.priorities.semantic_tokens = 200
  local lspconfig = require('lspconfig')
  local configs = require('lspconfig.configs')

  -- カスタムLSPサーバーの定義
  -- TypeScriptファイルでもリテラル型ホバーを有効にするため、filetypesにtypescriptを追加
  if not configs.storyteller then
    configs.storyteller = {
      default_config = {
        cmd = { "storyteller", "lsp", "start", "--stdio" },
        filetypes = { "markdown", "typescript", "typescriptreact" },
        root_dir = lspconfig.util.root_pattern(".storyteller.json", "story.config.ts", "deno.json"),
        single_file_support = true,
      },
    }
  end

  -- storyteller LSPを起動
  lspconfig.storyteller.setup({
    capabilities = capabilities,
    handlers = {
      -- semanticTokens/refresh を受け取ったらセマンティックトークンを再取得
      ["workspace/semanticTokens/refresh"] = function(err, result, ctx, config)
        -- Markdownバッファを強制的に再読み込みしてセマンティックトークンを更新
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) then
            local ft = vim.bo[bufnr].filetype
            local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "storyteller" })
            if #clients > 0 and ft == "markdown" then
              -- バッファが変更されていなければ再読み込み
              if not vim.bo[bufnr].modified then
                vim.api.nvim_buf_call(bufnr, function()
                  vim.cmd('edit')
                end)
              end
            end
          end
        end
        return vim.NIL
      end,
    },
  })

  -- storyteller LSP semantic tokens highlight
  -- ColorScheme読み込み後にも適用されるようautocmdで設定
  local function setup_storyteller_highlights()
    vim.api.nvim_set_hl(0, '@lsp.type.character', { fg = '#FF8800' })
    vim.api.nvim_set_hl(0, '@lsp.type.character.markdown', { fg = '#FF8800' })
    vim.api.nvim_set_hl(0, '@lsp.type.setting', { fg = '#0087FF' })
    vim.api.nvim_set_hl(0, '@lsp.type.setting.markdown', { fg = '#0087FF' })
    vim.api.nvim_set_hl(0, '@lsp.mod.lowConfidence', { underdashed = true })

    -- 伏線（foreshadowing）トークンタイプ
    vim.api.nvim_set_hl(0, '@lsp.type.foreshadowing', { fg = '#e67e22', italic = false })
    vim.api.nvim_set_hl(0, '@lsp.type.foreshadowing.markdown', { fg = '#e67e22', italic = false })

    -- 伏線ステータスモディファイア
    vim.api.nvim_set_hl(0, '@lsp.mod.planted', { fg = '#e67e22' })
    vim.api.nvim_set_hl(0, '@lsp.mod.resolved', { fg = '#27ae60' })

    -- typemod形式（より優先度が高い）
    vim.api.nvim_set_hl(0, '@lsp.typemod.foreshadowing.planted.markdown', {
      fg = '#e67e22',
      bold = false
    })
    vim.api.nvim_set_hl(0, '@lsp.typemod.foreshadowing.resolved.markdown', {
      fg = '#27ae60',
      bold = false
    })
  end

  -- 起動時に設定
  setup_storyteller_highlights()

  -- ColorScheme変更時にも再設定
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = setup_storyteller_highlights,
  })

  -- markdownファイル用のキーマッピング（nvim-lsp / storyteller LSP を使用）
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      local opts = { buffer = true, silent = true }
      -- 基本操作
      vim.keymap.set("n", ",cd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", ",ck", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", ",cr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", ",ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", ",cf", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", ",cn", vim.lsp.buf.rename, opts)
      -- Outline (Telescope)
      vim.keymap.set("n", ",co", "<cmd>Telescope lsp_document_symbols<CR>", opts)
      -- Diagnostics
      vim.keymap.set("n", ",cla", vim.diagnostic.setqflist, opts)
      vim.keymap.set("n", ",clb", vim.diagnostic.setloclist, opts)
    end,
  })

  -- 汎用 LSP キーマップ（CoC/markdown 以外のファイルタイプ用）
  -- TypeScript/JavaScript は denols を使うため CoC から除外
  local coc_filetypes = {
    'vim', 'php', 'json', 'go', 'lua', 'sh',
    'python', 'vue', 'yaml', 'blade'
  }

  local function is_coc_filetype(ft)
    for _, cft in ipairs(coc_filetypes) do
      if ft == cft then return true end
    end
    return false
  end

  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      local ft = vim.bo.filetype
      if ft ~= 'markdown' and not is_coc_filetype(ft) then
        local opts = { buffer = true, silent = true }
        vim.keymap.set("n", ",cd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", ",ck", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", ",cr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", ",cn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", ",ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", ",cf", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", ",co", "<cmd>Telescope lsp_document_symbols<CR>", opts)
        vim.keymap.set("n", ",cO", "<cmd>Telescope lsp_document_symbols<CR>", opts)
        vim.keymap.set("n", ",ci", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", ",cla", vim.diagnostic.setqflist, opts)
        vim.keymap.set("n", ",clb", vim.diagnostic.setloclist, opts)
      end
    end,
  })
end

vim.lsp.diagnostics_trigger_update = true

EOF
