-- Tests for buffer_picker
local stub = require("luassert.stub")
local spy = require("luassert.spy")

describe("buffer_picker", function()
  local mock_buffers = {
    { nr = 1, name = "file1.lua", path = "/tmp/file1.lua" },
    { nr = 2, name = "file2.lua", path = "/tmp/file2.lua" },
    { nr = 3, name = "[No Name]", path = "" },
  }

  before_each(function()
    -- Mock vim.api.nvim_list_bufs
    stub(vim.api, "nvim_list_bufs", function()
      return { 1, 2, 3 }
    end)

    -- Mock vim.api.nvim_buf_is_valid
    stub(vim.api, "nvim_buf_is_valid", function(buf)
      return buf ~= nil
    end)

    -- Mock vim.fn.buflisted
    stub(vim.fn, "buflisted", function(buf)
      return buf ~= nil and buf > 0 and 1 or 0
    end)

    -- Mock vim.api.nvim_buf_get_name
    stub(vim.api, "nvim_buf_get_name", function(buf)
      if buf == 1 then return "/tmp/file1.lua" end
      if buf == 2 then return "/tmp/file2.lua" end
      return ""
    end)

    -- Mock vim.fn.fnamemodify
    stub(vim.fn, "fnamemodify", function(path, modifier)
      if modifier == ":t" then
        local name = path:match("([^/]+)$")
        return name or ""
      end
      return path
    end)

    -- Mock vim.fn.bufnr
    stub(vim.fn, "bufnr", function(buf)
      return buf
    end)
  end)

  after_each(function()
    vim.api.nvim_list_bufs:revert()
    vim.api.nvim_buf_is_valid:revert()
    vim.fn.buflisted:revert()
    vim.api.nvim_buf_get_name:revert()
    vim.fn.fnamemodify:revert()
    vim.fn.bufnr:revert()
  end)

  it("should collect listed buffers", function()
    local buffers = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.fn.buflisted(buf) == 1 then
        local name = vim.api.nvim_buf_get_name(buf)
        local filename = vim.fn.fnamemodify(name, ":t")
        if filename == "" then filename = "[No Name]" end
        table.insert(buffers, { nr = vim.fn.bufnr(buf), name = filename, path = name })
      end
    end

    assert.equals(3, #buffers)
    assert.equals("file1.lua", buffers[1].name)
    assert.equals("file2.lua", buffers[2].name)
    assert.equals("[No Name]", buffers[3].name)
  end)

  it("should format buffer display string", function()
    local entry = { nr = 1, name = "test.lua", path = "/tmp/test.lua" }
    local display = entry.nr .. ": " .. entry.name
    
    assert.equals("1: test.lua", display)
  end)

  it("should return entry maker format", function()
    local entry = { nr = 5, name = "main.lua", path = "/project/main.lua" }
    local result = {
      value = entry,
      display = entry.nr .. ": " .. entry.name,
      ordinal = entry.nr .. " " .. entry.name,
    }

    assert.equals(5, result.value.nr)
    assert.equals("5: main.lua", result.display)
    assert.equals("5 main.lua", result.ordinal)
  end)
end)
