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


" マッピングの定義 (例: Normalモードで gd)
" 必要であれば、ファイルタイプに基づいてマッピングを有効化してください
" 例: autocmd FileType typescript,javascript nnoremap <buffer> <silent> gd :DenolsJump<CR>

lua << EOF

local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

-- Denoプロジェクト判定
local deno_root_files = {
  'deno.json',
  'deno.jsonc',
}

-- Deno用LSP
lspconfig.denols.setup{
  root_dir = util.root_pattern(unpack(deno_root_files)),
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
  }
}

require("mason").setup()
local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

require("mason-lspconfig").setup_handlers({
	function(server_name)
    capabilities = capabilities
    vim.lsp.enable(server_name)
  end,
})

vim.lsp.set_log_level("trace")

require('lspconfig').denols.setup {
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
}

require('lspsaga').setup({
  symbol_in_winbar = {
    enable = false,
    separator = " > ",
    show_file = true,
    folder_level = 2,
    click_support = false,
  },
})

require("lspconfig").pyright.setup({})

local function fetch_deno_content(bufnr, uri)
  local client = vim.lsp.get_clients({ name = 'denols' })[1]
  if not client then
    vim.notify('denols client not found', vim.log.levels.ERROR)
    return false
  end

  local response = client.request_sync('deno/virtualTextDocument', {
    textDocument = { uri = uri },
  }, 2000, 0)

  if not response or type(response.result) ~= 'string' then
    vim.notify('Failed to fetch content', vim.log.levels.ERROR)
    return false
  end

  vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
  local lines = vim.split(response.result, '\n')
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
  return true
end

vim.api.nvim_create_autocmd({ 'BufReadCmd' }, {
  pattern = { 'deno:/*' },
  callback = function(params)
    local bufnr = params.buf
    local uri = params.match

    if fetch_deno_content(bufnr, uri) then
      vim.api.nvim_buf_set_name(bufnr, uri)
      vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
      vim.api.nvim_set_option_value('modified', false, { buf = bufnr })
      vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
      vim.api.nvim_set_option_value('filetype', 'typescript', { buf = bufnr })

      local client = vim.lsp.get_clients({ name = 'denols' })[1]
      if client then
        vim.lsp.buf_attach_client(bufnr, client.id)
      end
    end
  end,
})

EOF
