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
        require("render-markdown").preview()
      end,
      ft = "markdown",
      desc = "Markdown Preview",
    },
  },
}
