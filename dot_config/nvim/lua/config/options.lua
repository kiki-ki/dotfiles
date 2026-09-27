vim.opt.fileencodings = { "utf-8", "iso-2022-jp", "euc-jp", "sjis" }
vim.opt.listchars = { tab = "»-", trail = "·", extends = "»", precedes = "«", nbsp = "%" }
vim.opt.relativenumber = false

-- Mapped here, before any LSP attaches, so Neovim does not claim K for hover in each buffer
vim.keymap.set({ "n", "v" }, "K", "3k")

-- Containers reached with kubectl exec have no clipboard tool: copy through the terminal with OSC 52,
-- and paste the last yank instead of reading the clipboard, which ghostty would prompt for every time
if vim.fn.has("linux") == 1 and not vim.env.DISPLAY and not vim.env.WAYLAND_DISPLAY then
  local osc52 = require("vim.ui.clipboard.osc52")
  local last = {}
  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      last[reg] = { lines, regtype }
      send(lines)
    end
  end
  local function paste(reg)
    return function()
      return last[reg] or { { "" }, "v" }
    end
  end
  vim.g.clipboard = {
    name = "OSC 52 copy",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste("+"), ["*"] = paste("*") },
  }
  vim.opt.clipboard = "unnamedplus"
end
