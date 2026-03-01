-- buffer_picker.nvim
-- Telescope-based buffer picker for Neovim

local M = {}

local defaults = {
  keymap = "<M-Tab>",
}

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  vim.keymap.set("n", opts.keymap, M.pick_buffer, { noremap = true, silent = true, desc = "Buffer picker" })
end

function M.pick_buffer()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.fn.buflisted(buf) == 1 then
      local name = vim.api.nvim_buf_get_name(buf)
      local filename = vim.fn.fnamemodify(name, ":t")
      if filename == "" then filename = "[No Name]" end
      table.insert(buffers, { nr = vim.fn.bufnr(buf), name = filename, path = name })
    end
  end

  if #buffers == 0 then
    vim.notify("No buffers available", vim.log.levels.WARN)
    return
  end

  local picker = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  picker.new({}, {
    prompt_title = "Buffer Switcher",
    finder = finders.new_table({
      results = buffers,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.nr .. ": " .. entry.name,
          ordinal = entry.nr .. " " .. entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        local selection = require("telescope.actions.state").get_selected_entry()
        if selection then
          vim.cmd("silent! buffer! " .. selection.value.nr)
        end
        pcall(vim.cmd, "bdelete! " .. prompt_bufnr)
      end)
      return true
    end,
  }):find()
end

-- Auto-setup with default keymap
M.setup()

return M
