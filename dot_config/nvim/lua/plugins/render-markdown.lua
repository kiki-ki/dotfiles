return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  opts = {
    -- Render only in the side preview, so the buffer being edited keeps its raw markup
    enabled = false,
    overrides = { preview = { enabled = true } },
    code = { sign = false, width = "block", right_pad = 1 },
    heading = { sign = false, icons = {} },
    checkbox = { enabled = false },
  },
  keys = {
    {
      "<leader>cp",
      function()
        local src = vim.api.nvim_get_current_buf()
        require("render-markdown").preview()
        local dst = require("render-markdown.core.preview").buffers[src]
        if dst then
          -- Name the preview after the source so snacks.image resolves relative image paths from its directory
          vim.api.nvim_buf_set_name(dst, vim.api.nvim_buf_get_name(src) .. " [preview]")
          Snacks.image.doc.attach(dst)
        end
      end,
      ft = "markdown",
      desc = "Markdown Preview",
    },
  },
}
