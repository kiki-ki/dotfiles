-- =============================================================================
-- Options
-- =============================================================================

-- encoding
vim.opt.fileencodings = "utf-8,iso-2022-jp,euc-jp,sjis"

-- UI
vim.opt.number        = true
vim.opt.signcolumn    = "yes"
vim.opt.title         = true
vim.opt.showmatch     = true
vim.opt.list          = true
vim.opt.listchars     = { tab = "»-", trail = "·", extends = "»", precedes = "«", nbsp = "%" }
vim.opt.winbar        = "%f"
vim.opt.laststatus    = 0
vim.opt.statusline    = " "
vim.opt.ruler         = false
vim.opt.termguicolors = true
vim.opt.background    = "dark"

-- editing
vim.opt.tabstop       = 2
vim.opt.softtabstop   = 2
vim.opt.expandtab     = true
vim.opt.shiftwidth    = 2
vim.opt.smartindent   = true
vim.opt.clipboard     = "unnamed,unnamedplus"
vim.opt.swapfile      = false
vim.opt.autoread      = true
vim.opt.updatetime    = 500

-- search
vim.opt.ignorecase    = true
vim.opt.wrapscan      = true
vim.opt.smartcase     = true
vim.opt.incsearch     = true
vim.opt.hlsearch      = true

-- =============================================================================
-- Keybindings
-- =============================================================================

vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.keymap.set({ "n", "v" }, "J", "3j")
vim.keymap.set({ "n", "v" }, "K", "3k")
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")
vim.keymap.set("n", "gb", "<C-o>", { desc = "Jump back" })
vim.keymap.set("n", "<leader>y", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
  vim.notify("Copied: " .. vim.fn.expand("%"))
end, { desc = "Copy relative path" })

-- =============================================================================
-- Autocmds
-- =============================================================================

-- auto save
vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = "AutoSave",
  callback = function()
    if vim.bo.modified and not vim.bo.readonly
        and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- highlight ideographic spaces
vim.api.nvim_create_augroup("HighlightIdeographicSpace", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  group = "HighlightIdeographicSpace",
  callback = function()
    -- skip if already added to this window
    for _, m in ipairs(vim.fn.getmatches()) do
      if m.group == "IdeographicSpace" then return end
    end
    vim.fn.matchadd("IdeographicSpace", "　")
    vim.fn.matchadd("IdeographicSpace", "[\u{00A0}\u{2000}-\u{200B}\u{FEFF}]")
  end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "HighlightIdeographicSpace",
  callback = function()
    vim.api.nvim_set_hl(0, "IdeographicSpace", { bg = "#333333" })
  end,
})

-- LSP keybindings
vim.api.nvim_create_augroup("LspKeymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspKeymaps",
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition,  opts)
    vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references,   opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  end,
})

-- =============================================================================
-- Plugins (lazy.nvim)
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- colorscheme
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup()
      vim.cmd("colorscheme github_dark_default")
      vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE", fg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "NONE" })
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    opts = {
      options = {
        separator_style = "slant",
        offsets = {
          { filetype = "neo-tree", text = "Explorer", highlight = "Directory", separator = true },
        },
      },
      highlights = {
        buffer_selected = { fg = "#e6edf3" },
      },
    },
  },

  -- file tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = "VimEnter",
    keys = {
      { "<leader>t", "<cmd>Neotree toggle<cr>", desc = "Toggle neo-tree" },
    },
    opts = {
      window = { width = 30 },
      filesystem = {
        follow_current_file = { enabled = true, leave_dirs_open = false },
        filtered_items = {
          visible      = true,
          hide_dotfiles  = false,
          hide_gitignored = false,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.cmd("Neotree filesystem reveal left")
    end,
  },

  -- fzf
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    keys = {
      { "<leader>f", "<cmd>Files<cr>",   desc = "Find files" },
      { "<leader>g", "<cmd>Rg<cr>",      desc = "Grep" },
      { "<leader>b", "<cmd>Buffers<cr>", desc = "Buffers" },
    },
  },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {},
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        typescript = { "prettierd" },
        javascript = { "prettierd" },
        json       = { "prettierd" },
        yaml       = { "prettierd" },
        go         = { "gofumpt" },
      },
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    },
  },

  -- linter
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function()
      require("lint").linters_by_ft = {
        typescript = { "eslint_d" },
        javascript = { "eslint_d" },
        go         = { "golangci-lint" },
      }
      vim.api.nvim_create_augroup("NvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        group = "NvimLint",
        callback = function() pcall(require("lint").try_lint) end,
      })
    end,
  },

  -- LSP
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },

}, {
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})

-- =============================================================================
-- LSP
-- =============================================================================

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed    = { "gopls", "ts_ls" },
  automatic_installation = true,
})

pcall(function()
  require("mason-registry").refresh(function()
    local registry = require("mason-registry")
    for _, name in ipairs({ "prettierd", "gofumpt", "eslint_d", "golangci-lint" }) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then pkg:install() end
    end
  end)
end)

vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
vim.lsp.enable({ "gopls", "ts_ls" })

local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<C-e>"]     = cmp.mapping.abort(),
  }),
  sources = cmp.config.sources({ { name = "nvim_lsp" } }),
})
