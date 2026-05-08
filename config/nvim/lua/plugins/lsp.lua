return {
  {
    "smjonas/inc-rename.nvim",
    opts = { input_buffer_type = "snacks" },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
      "saghen/blink.cmp",
    },
  },
}
