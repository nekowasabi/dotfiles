lua << EOF
local navic = require("nvim-navic")
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
  end
end
require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach, --keyバインドなどの設定を登録
    }
  end,
}

require("lspconfig").vimls.setup {
    on_attach = on_attach
}

require("lspconfig").intelephense.setup {
    on_attach = on_attach
}

require("lspconfig").denols.setup {
    on_attach = on_attach
}
EOF
