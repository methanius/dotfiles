return {
  "p00f/clangd_extensions.nvim",
  ft = { "cpp", "h" },
  event = "LspAttach",
  opts = {
    inlay_hints = { only_current_line = true },
  },
}
