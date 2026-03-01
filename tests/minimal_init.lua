-- Minimal init for testing
vim.opt.runtimepath:prepend(".")

-- Mock vim functions that might not exist in headless
if not vim.fn.exists("*vim.fn.fnamemodify") then
  vim.fn.fnamemodify = function(path, modifier)
    if modifier == ":t" then
      return (path:gsub("^.*/", ""))
    end
    return path
  end
end
