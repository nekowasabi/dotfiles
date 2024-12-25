nnoremap <silent> ,ccf :ContextNvim add_current_file<CR>
nnoremap <silent> ,ccl :ContextNvim add_line_lsp_daig<CR>
nnoremap <silent> ,cch :ContextNvim find_context_history<CR>
nnoremap <silent> ,ccm :ContextNvim find_context_manual<CR>
vnoremap <silent> ,ccc :ContextNvim add_current<CR>

function! s:ClearContext()
  execute "ContextNvim clear_manual"
  execute "ContextNvim clear_history"
endfunction
nnoremap <silent> ,ccc :call <SID>ClearContext()<CR>

lua << EOF
require("context_nvim").setup({ 
  enable_history = true, -- whether to enable history context by tracking opened files/buffers
  history_length = 10, -- how many history items to track
  history_for_files_only = true, -- only use history for files, any non-file buffers will be ignored
  history_pattern = "*", -- history pattern to match files/buffers that will be tracked
  root_dir = ".", -- root directory of the project, used for finding files and constructing paths
  cmp = {
    enable = true, -- whether to enable the nvim-cmp source for referencing contexts

    register_cmp_avante = true, -- whether to include the cmp source for avante input buffers. 
                                -- They need to be registered using an autocmd, so this is a separate config option
    manual_context_keyword = "@manual_context", -- keyword to use for manual context
    history_keyword = "@history_context", -- keyword to use for history context
    prompt_keyword = "@prompt", -- keyword to use for prompt context
  },

  telescope = {
    enable = true, -- whether to enable the telescope picker
  },

  logger = {
    level = "error", -- log level for the plenary logger 
  },

  lsp = {
    ignore_sources = {}, -- lsp sources to ignore when adding line diagnostics to the manual context
  },
  prompts = {
        { 
            name = 'unit tests', -- the name of the prompt (required)
            prompt = 'Generate a suite of unit tests using Jest, respond with only code.', -- the prompt text (required)
            cmp = 'jest' -- an alternate name for the cmp completion source (optional) defaults to 'name'
        },
    }
})
EOF
