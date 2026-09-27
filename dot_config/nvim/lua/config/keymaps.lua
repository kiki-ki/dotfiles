vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set({ "n", "v" }, "J", "3j")
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")

local function copy(text, title)
  vim.fn.setreg("+", text)
  vim.notify(text, vim.log.levels.INFO, { title = title })
end

vim.keymap.set("n", "<leader>fy", function()
  copy(vim.fn.expand("%:."), "Copied relative path")
end, { desc = "Copy Relative Path" })

vim.keymap.set("n", "<leader>fY", function()
  copy(vim.fn.expand("%:p"), "Copied absolute path")
end, { desc = "Copy Absolute Path" })

vim.keymap.set({ "n", "x" }, "<leader>gy", function()
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  -- Leave visual mode first so Snacks.gitbrowse does not send ":" to read the marks, which flashes the noice cmdline
  if vim.fn.mode():find("[vV]") then
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  end
  Snacks.gitbrowse({
    what = "permalink",
    line_start = math.min(s, e),
    line_end = math.max(s, e),
    open = function(url)
      copy(url, "Copied permalink")
    end,
    notify = false,
  })
end, { desc = "Copy Git Permalink" })
