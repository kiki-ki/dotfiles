return {
  "folke/snacks.nvim",
  init = function()
    -- Put the mmdc wrapper in bin/ ahead of any real mermaid-cli, only inside Neovim
    vim.env.PATH = vim.fn.stdpath("config") .. "/bin:" .. vim.env.PATH
  end,
  opts = {
    -- Not attached to documents by default: the Markdown preview attaches itself so the edited buffer stays plain
    image = { enabled = true, doc = { enabled = false } },
    picker = { sources = { files = { hidden = true }, grep = { hidden = true }, explorer = { hidden = true } } },
  },
}
