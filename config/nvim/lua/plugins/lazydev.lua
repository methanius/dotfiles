return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    dependencies = {
      { "gonstoll/wezterm-types", lazy = true },
      { "Bilal2453/luvit-meta",   lazy = true }, -- optional `vim.uv` typings
    },
    opts = {
      library = {
        "lazy.nvim",

        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },

        -- Snacks types
        { path = "snacks.nvim",        words = { "Snacks" } },

        -- Optional wezterm types
        { path = "wezterm-types",      mods = { "wezterm" } },

        -- Nvim dap ui types
        "nvim-dap-ui",
      },
    },
  },
}
