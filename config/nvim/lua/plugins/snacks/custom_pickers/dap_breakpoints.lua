return {
  title = "DAP Breakpoints",
  finder = function(_opts, _ctx)
    local breakpoints = require("dap.breakpoints").get()
    local index = 0
    local items = {}
    local current_buf = vim.api.nvim_get_current_buf()
    for buf_nr, lines_table in pairs(breakpoints) do
      local buf_name = vim.api.nvim_buf_get_name(buf_nr)
      for _, line_table in pairs(lines_table) do
        local text = vim.trim(vim.api.nvim_buf_get_lines(buf_nr, line_table.line - 1, line_table.line, true)
          [1])
        index = index + 1
        table.insert(items, {
          file = buf_name,
          idx = index,
          text = text,
          pos = { line_table.line, 0 },
          score_add = (buf_nr == current_buf) and 1000 or 0,
          line = text,
          item = line_table,
          buf_nr = buf_nr,
          line_num = line_table.line,
          is_current_buffer = (buf_nr == current_buf) and 0 or 1,
        })
      end
    end
    return items
  end,
  format = "file",
  preview = "file",
  win = {
    input = {
      keys = {
        ["d"] = "delete_breakpoint",
      },
    },
  },
  sort = {
    fields = {
      "is_current_buffer",
      "file",
      "line_num",
    },
  },
  matcher = {
    sort_empty = true,
  },
  actions = {
    delete_breakpoint = function(picker)
      local dap_breakpoints = require("dap.breakpoints")
      local items = picker:selected({ fallback = true })
      for _, item in ipairs(items) do
        dap_breakpoints.remove(item.buf_nr, item.item.line)
      end

      picker.list:set_selected()
      picker.list:set_target()
      vim.schedule(function()
        picker:find()
      end)
    end,
  },
}
