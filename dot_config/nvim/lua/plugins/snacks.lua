return {
  "folke/snacks.nvim",
  opts = {
    picker = { sources = { files = { hidden = true }, grep = { hidden = true }, explorer = { hidden = true } } },
  },
  keys = {
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>/", LazyVim.pick("grep", { root = false }), desc = "Grep (cwd)" },
  },
}
