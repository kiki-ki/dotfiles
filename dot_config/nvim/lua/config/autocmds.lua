-- LazyVim only checks on FocusGained, which herdr may not forward; catch edits from an agent in another pane too
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("checktime_agent", { clear = true }),
  callback = function()
    if vim.o.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("ideographic_space", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "IdeographicSpace", { bg = "#073642" })
  end,
})
vim.api.nvim_set_hl(0, "IdeographicSpace", { bg = "#073642" })
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

-- Neovim maps K to hover per buffer when an LSP attaches before our global K exists; keep K as 3k
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("keep_k_motion", { clear = true }),
  callback = function(ev)
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(ev.buf, "n")) do
      if map.lhs == "K" and map.desc == "vim.lsp.buf.hover()" then
        vim.keymap.del("n", "K", { buffer = ev.buf })
      end
    end
  end,
})
