return {
  "brianhuster/live-preview.nvim",
  cmd = "LivePreview",
  keys = {
    { "<leader>cp", ft = "markdown", "<cmd>LivePreview start<cr>", desc = "Markdown Preview" },
    { "<leader>cP", ft = "markdown", "<cmd>LivePreview close<cr>", desc = "Markdown Preview Stop" },
  },
  config = function()
    -- Serve from the file's directory so relative images resolve even when the file is outside the cwd
    require("livepreview.config").set({ dynamic_root = true })
  end,
}
