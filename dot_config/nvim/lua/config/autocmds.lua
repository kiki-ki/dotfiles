-- LazyVim only checks on FocusGained, which herdr may not forward; catch edits from an agent in another pane too
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("checktime_agent", { clear = true }),
  callback = function()
    if vim.o.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

local function highlight_ideographic_space()
  local warn = vim.api.nvim_get_hl(0, { name = "WarningMsg", link = false }).fg
  vim.api.nvim_set_hl(0, "IdeographicSpace", { bg = warn })
end
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("ideographic_space", { clear = true }),
  callback = highlight_ideographic_space,
})
highlight_ideographic_space()
local function match_ideographic_space()
  if not vim.w.ideographic_space_match then
    vim.w.ideographic_space_match = vim.fn.matchadd("IdeographicSpace", "[\\u3000\\u00A0\\u2000-\\u200B\\uFEFF]")
  end
end
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("ideographic_space_match", { clear = true }),
  callback = match_ideographic_space,
})
-- LazyVim loads this file after VimEnter when nvim starts without a file argument
match_ideographic_space()
