lua << EOF
--- for caw's workaround
local M = {}
---@param lnum integer
---@param col integer
---@return boolean
function M.has_syntax(lnum, col)
  local bufnr = vim.api.nvim_get_current_buf()
  local captures = vim.treesitter.get_captures_at_pos(bufnr, lnum - 1, col - 1)
  for _, capture in ipairs(captures) do
    if capture.capture == "comment" then
      return true
    end
  end
  return false
end
---@diagnostic disable-next-line: duplicate-set-field
_G.package.preload.caw = function() return M end

EOF
