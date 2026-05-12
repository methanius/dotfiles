return {
  {
    "smjonas/inc-rename.nvim",
    opts = { input_buffer_type = "snacks" },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
  },
}
