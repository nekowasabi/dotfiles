nnoremap <silent> <leader>rr :lua require('kulala').run()<CR>
nnoremap <silent> <leader>rl :lua require('kulala').replay()<CR>

lua << EOF
require("kulala").setup({
    -- dev, test, prod, can be anything
    -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
    default_env = "dev",

    -- enable/disable debug mode
    debug = false,

    -- default formatters/pathresolver for different content types
    contenttypes = {
      ["application/json"] = {
        ft = "json",
        formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
      },
      ["application/xml"] = {
        ft = "xml",
        formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "-" },
        pathresolver = vim.fn.executable("xmllint") == 1 and { "xmllint", "--xpath", "{{path}}", "-" },
      },
      ["text/html"] = {
        ft = "html",
        formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "--html", "-" },
        pathresolver = nil,
      },
    },

    ui = {
      -- display mode: possible values: "split", "float"
      display_mode = "split",

      -- split direction
      -- possible values: "above", "right", "below", "left"
      split_direction = "right",

      -- default_view, body or headers or headers_body
      default_view = "body",

      -- can be used to show loading, done and error icons in inlay hints
      -- possible values: "signcolumn", "on_request", "above_request", "below_request", or nil to disable
      show_icons = "on_request",

      -- default icons
      icons = {
        inlay = {
          loading = "⏳",
          done = "✅",
          error = "❌",
        },
        lualine = "🐼",
      },

      -- scratchpad default contents
      scratchpad_default_contents = {
        "@MY_TOKEN_NAME=my_token_value",
        "",
        "# @name scratchpad",
        "POST https://httpbin.org/post HTTP/1.1",
        "accept: application/json",
        "content-type: application/json",
        "",
        "{",
        '  "foo": "bar"',
        "}",
      },

      -- enable winbar
      winbar = false,

      -- Specify the panes to be displayed by default
      default_winbar_panes = { "body", "headers", "headers_body" },
    },

    -- enable reading vscode rest client environment variables
    vscode_rest_client_environmentvars = false,

    -- disable the vim.print output of the scripts
    -- they will be still written to disk, but not printed immediately
    disable_script_print_output = false,

    -- set scope for environment and request variables
    -- possible values: b = buffer, g = global
    environment_scope = "b",

    -- certificates
    certificates = {},
})
EOF
