" LSP キーバインド設定
" - CoC filetypes (vim,typescript,php,json,go,lua,sh,python,javascript,vue,yaml,blade): coc.vim で設定
" - markdown: nvim-lsp (storyteller LSP) を使用（下部のLuaで設定）
" - その他: Lspsaga を使用

" CoC filetypes かどうかを判定
function! s:IsCocFiletype() abort
  let l:coc_filetypes = ['vim', 'typescript', 'php', 'json', 'go', 'lua', 'sh', 'python', 'javascript', 'vue', 'yaml', 'blade']
  return index(l:coc_filetypes, &filetype) >= 0
endfunction

" Lspsaga用キーバインドを設定する関数
function! s:SetLspsagaKeybindings() abort
  nnoremap <buffer><silent> ,cd <cmd>Lspsaga goto_definition<CR>
  nnoremap <buffer><silent> ,ck <cmd>Lspsaga hover_doc<CR>
  nnoremap <buffer><silent> ,cr <cmd>Lspsaga rename<CR>
  nnoremap <buffer><silent> ,cR <cmd>Lspsaga finder ref<CR>
  nnoremap <buffer><silent> ,ca <cmd>Lspsaga code_action<CR>
  nnoremap <buffer><silent> ,cf <cmd>Lspsaga code_action<CR>
  nnoremap <buffer><silent> ,co <cmd>Telescope lsp_document_symbols<CR>
  nnoremap <buffer><silent> ,cO <cmd>Lspsaga outline<CR>
  nnoremap <buffer><silent> ,ci <cmd>Lspsaga finder imp<CR>
  nnoremap <buffer><silent> ,cla <cmd>Lspsaga show_workspace_diagnostics<CR>
  nnoremap <buffer><silent> ,clb <cmd>Lspsaga show_buf_diagnostics<CR>
endfunction

if !g:IsMacNeovimInWork()
  augroup LspsagaMappings
    autocmd!
    " CoC filetypes と markdown 以外で Lspsaga キーバインドを設定
    autocmd FileType * if &filetype != 'markdown' && !s:IsCocFiletype() | call s:SetLspsagaKeybindings() | endif
  augroup END
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

-- storyteller LSP semantic tokens highlight
-- ColorScheme読み込み後にも適用されるようautocmdで設定
local function setup_storyteller_highlights()
  vim.api.nvim_set_hl(0, '@lsp.type.character', { fg = '#FF8800' })
  vim.api.nvim_set_hl(0, '@lsp.type.character.markdown', { fg = '#FF8800' })
  vim.api.nvim_set_hl(0, '@lsp.type.setting', { fg = '#0087FF' })
  vim.api.nvim_set_hl(0, '@lsp.type.setting.markdown', { fg = '#0087FF' })
  vim.api.nvim_set_hl(0, '@lsp.mod.lowConfidence', { underdashed = true })
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

vim.lsp.diagnostics_trigger_update = true

EOF
