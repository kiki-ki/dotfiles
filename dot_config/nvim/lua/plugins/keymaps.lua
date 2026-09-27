-- Free H/L/K for the motions carried over from .vimrc; buffers stay on [b/]b and hover moves to gh
return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<S-h>", false },
      { "<S-l>", false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "K", false },
            {
              "gh",
              function()
                return vim.lsp.buf.hover()
              end,
              desc = "Hover",
            },
          },
        },
      },
    },
  },
}
