-- Show diagnostics in floating windows
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in a floating window" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous LSP diagnostic" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next LSP diagnostic" })

local diagnostics_signs = {
  Error = " ",
  Warn  = " ",
  Hint  = " ",
  Info  = " ",
}
vim.diagnostic.config({
  update_in_insert = true,
  underline = true,
  float = {
    focusable = false,
    style = "minimal",
    source = "if_many",
    header = "",
    prefix = "",
  },
  severity_sort = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = function(diagnostic)
      local severity = diagnostic.severity
      local match_severities = vim.diagnostic.severity
      if severity == match_severities.ERROR then
        return diagnostics_signs.Error
      elseif severity == match_severities.WARN then
        return diagnostics_signs.Warn
      elseif severity == match_severities.HINT then
        return diagnostics_signs.Hint
      elseif severity == match_severities.INFO then
        return diagnostics_signs.Info
      else
        return ""
      end
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostics_signs.Error,
      [vim.diagnostic.severity.WARN] = diagnostics_signs.Warn,
      [vim.diagnostic.severity.HINT] = diagnostics_signs.Hint,
      [vim.diagnostic.severity.INFO] = diagnostics_signs.Info,
    }
  }
})
