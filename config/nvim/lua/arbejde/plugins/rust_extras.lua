return {
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      completion = {
        crates = {
          enabled = true,
        },
      },
    }
  },
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          capabilities = require("blink.cmp").get_lsp_capabilities()
        }
      }
    end,
  },
}
