vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.fileencodings = { "utf-8", "iso-2022-jp", "euc-jp", "sjis" }

vim.opt.list = true
vim.opt.listchars = { tab = "»-", trail = "·", extends = "»", precedes = "«", nbsp = "%" }

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.title = true
vim.opt.showmatch = true
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "IdeographicSpace", { bg = "#073642" })
  end,
})
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  callback = function()
    if not vim.w.ideographic_space_match then
      vim.w.ideographic_space_match = vim.fn.matchadd("IdeographicSpace", "[\\u3000\\u00A0\\u2000-\\u200B\\uFEFF]")
    end
  end,
})

vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set({ "n", "v" }, "J", "3j")
vim.keymap.set({ "n", "v" }, "K", "3k")
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("github_dark")
    end,
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      picker = {},
      explorer = {},
    },
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    },
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    -- Load at startup so a claude running in another pane can connect via /ide
    event = "VeryLazy",
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}, {
  install = { colorscheme = { "github_dark" } },
  checker = { enabled = false },
})
