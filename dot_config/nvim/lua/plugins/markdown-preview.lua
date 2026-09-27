-- Only the preview from LazyVim's lang.markdown extra: the extra also adds in-buffer rendering and prettier on save
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
  },
  config = function()
    -- The plugin defines its commands per buffer on FileType, which already fired before lazy loaded it
    vim.cmd([[do FileType]])
  end,
}
