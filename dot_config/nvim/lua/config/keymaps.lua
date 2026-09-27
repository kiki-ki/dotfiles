vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set({ "n", "v" }, "J", "3j")
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")

local function copy(text, title)
  vim.fn.setreg("+", text)
  vim.notify(text, vim.log.levels.INFO, { title = title })
end

local function copy_path(mods, title)
  local path = vim.fn.expand("%" .. mods)
  if path == "" then
    return vim.notify("No file in this buffer", vim.log.levels.WARN)
  end
  copy(path, title)
end

-- Snacks.gitbrowse builds a broken URL instead of failing for a file git does not track
local function is_tracked(file)
  return file ~= ""
    and vim.system({ "git", "-C", vim.fs.dirname(file), "ls-files", "--error-unmatch", file }):wait().code == 0
end

vim.keymap.set("n", "<leader>fy", function()
  copy_path(":.", "Copied relative path")
end, { desc = "Copy Relative Path" })

vim.keymap.set("n", "<leader>fY", function()
  copy_path(":p", "Copied absolute path")
end, { desc = "Copy Absolute Path" })

vim.keymap.set({ "n", "x" }, "<leader>gy", function()
  if not is_tracked(vim.fn.expand("%:p")) then
    return vim.notify("Not a file tracked by git", vim.log.levels.WARN)
  end
  Snacks.gitbrowse({
    what = "permalink",
    open = function(url)
      copy(url, "Copied permalink")
    end,
    notify = false,
  })
end, { desc = "Copy Git Permalink" })
