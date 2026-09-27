return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    opts = { options = { transparent = true } },
    config = function(_, opts)
      require("github-theme").setup(opts)
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "github_dark_default" } },
}
