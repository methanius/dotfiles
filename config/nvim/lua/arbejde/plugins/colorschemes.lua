return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    config = function()
      require("tokyonight").setup({
        transparent = true,
        plugins = "all",
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = true,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = false },
        typeStype = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            TelescopeTitle = { bg = "none", fg = theme.ui.special, bold = true },
            TelescopeBorder = { bg = "none" },
          }
        end,
        colors = {
          theme = { all = { ui = { bg_gutter = "none" } } },
        },
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus",
        },
      })
      -- vim.cmd(":KanagawaCompile")
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
