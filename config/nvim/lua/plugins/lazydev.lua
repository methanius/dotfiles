return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    dependencies = {
      { "Bilal2453/luvit-meta" }, -- optional `vim.uv` typings
      { "DrKJeff16/wezterm-types" },
    },
    opts = {
      library = {
        "lazy.nvim",

        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },

        -- Snacks types
        { path = "snacks.nvim",        words = { "Snacks" } },

        -- Optional wezterm types
        { path = "wezterm-types",      mods = { "wezterm" } },

        -- Nvim dap ui types
        "nvim-dap-ui",
      },
    },
  },
  { -- optional blink completion source for require statements and module annotations
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  }
}
