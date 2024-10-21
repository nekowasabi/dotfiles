if g:IsMacNeovim()
  let g:js_dap_adapter = "/Users/takets/.config/nvim/js-debug/src/dapDebugServer.js"
  let g:php_dap_adapter = "~/repos/vscode-php-debug/out/phpDebug.js"
endif
if g:IsMacNeovimInWork()
  let g:js_dap_adapter = "/Users/ttakeda/.config/nvim/js-debug/src/dapDebugServer.js"
  let g:php_dap_adapter = "~/repos/vscode-php-debug/out/phpDebug.js"
endif
if g:IsWsl()
  let g:js_dap_adapter = "/home/takets/.config/nvim/js-debug/src/dapDebugServer.js"
  let g:php_dap_adapter = "/home/takets/repos/vscode-php-debug/out/phpDebug.js"
endif


lua << EOF

require("dap").configurations.typescript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = "Launch file",
    runtimeExecutable = "deno",
    runtimeArgs = {
      "run",
      "--inspect-wait",
      "--allow-all"
    },
    program = "${file}",
    cwd = "${workspaceFolder}",
    attachSimplePort = 9229,
  },
}

require("dap").adapters.php = {
  type = 'executable',
  command = 'node',
  args = { vim.g.php_dap_adapter },
}

require("dap").configurations.php = {
{
  type = 'php',
  request = 'launch',
  name = 'Listen for Xdebug',
  port = 9003,  -- Xdebug 3のデフォルトポート
  pathMappings = {
    ['/opt/invase-backend'] = "${workspaceFolder}",
    ['/opt/invase-backend/app'] = "${workspaceFolder}/app",
    ['/var/www/html'] = "${workspaceFolder}",
  },
  serverSourceRoot = '/opt/invase-backend',
  localSourceRoot = '${workspaceFolder}',
  hostname = 'localhost',  -- localhostに変更
  log = true,
  xdebugSettings = {
    max_children = 100,
    max_data = 1024,
    max_depth = 5,
  },
  ignore_exception_throw = false,
  stop_on_entry = false,
  }
}

require("deno-nvim").setup {
  dap = {
    adapter = {
      executable = {
        args = {
          '~/repos/vscode-php-debug/out/phpDebug.js'
        }
        }
      }
    }
  }

require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()

vim.api.nvim_set_keymap('n', '<leader>dt', ':lua require("dapui").toggle()<CR>', {})
require('dap.ui.widgets').hover()
end)

vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
require('dap.ui.widgets').preview()
end)

vim.keymap.set('n', '<Leader>df', function()
local widgets = require('dap.ui.widgets')
widgets.centered_float(widgets.frames)
end)

-- 変数一覧
vim.keymap.set('n', '<Leader>ds', function()
local widgets = require('dap.ui.widgets')
widgets.centered_float(widgets.scopes)
end)


EOF
