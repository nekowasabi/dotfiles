" lsp_saga
if !g:IsMacNeovimInWork()
  nnoremap <silent> ,ck <cmd>Lspsaga hover_doc<CR>
  nnoremap <silent> ,cf <cmd>Lspsaga code_action<CR>
  nnoremap <silent> ,cr <cmd>Lspsaga rename<CR>
  nnoremap <silent> ,cd <cmd>Lspsaga goto_definition<CR>
  nnoremap <silent> ,co <cmd>Telescope lsp_document_symbols<CR>
  nnoremap <silent> ,cO <cmd>Lspsaga outline<CR>
  nnoremap <silent> ,ca <cmd>Lspsaga code_action<CR>
endif

lua << EOF

require("mason").setup()
local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

-- vim.lsp.set_log_level("trace")

vim.lsp.config("denols", {
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
        parameterNames = true,
        parameterTypes = true,
        variableTypes = true,
        functionReturnTypes = true,
        enumMemberValues = true,
        propertyDeclarationTypes = true,
        parameterNamesSuppressWhenArgumentMatchesName = true,
      },
      unstable = true,
      codeLens = {
        implementations = true,
        references = true,
      },
      cache = true,
      import_map = true,
    },
  },
  root_dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc", "import_map.json"),
})

require('lspsaga').setup({
  symbol_in_winbar = {
    enable = false,
    separator = " > ",
    show_file = true,
    folder_level = 2,
    click_support = false,
  },
})

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
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

-- カスタムLSPサーバーの定義
if not configs.storyteller then
  configs.storyteller = {
    default_config = {
      cmd = { "/home/takets/repos/street-storyteller/storyteller", "lsp", "start", "--stdio" },
      filetypes = { "markdown" },
      root_dir = lspconfig.util.root_pattern(".storyteller.json", "story.config.ts", "deno.json"),
      single_file_support = true,
    },
  }
end

-- storyteller LSPを起動
lspconfig.storyteller.setup({
  capabilities = capabilities,
})

vim.lsp.enable({"lua_ls", "denols"})

-- markdownファイル用のキーマッピング（coc.nvimの代わりにnvim-lspを使用）
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set("n", ",cd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", ",ck", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", ",cr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", ",ca", vim.lsp.buf.code_action, opts)
  end,
})

vim.lsp.diagnostics_trigger_update = true

EOF
