return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      plugins = { auto = true },
      on_hightlights = function(highlights, colors)
        local theme = colors.theme
        highlights.NormalFloat = { bg = "none" }
        highlights.FloatBorder = { bg = "none" }
        highlights.FloatTitle = { bg = "none" }
        highlights.TelescopeTitle = { bg = "none", fg = theme.ui.special, bold = true }
        highlights.TelescopeBorder = { bg = "none" }
        highlights.NotifyBackground.background_colour = "#000000"
      end,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = true,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = false },
      typeStype = {},
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
        theme = {
          wave = {
            ui = {
              bg = "NONE",
            },
          },
          all = { ui = { bg_gutter = "none" } }
        },
      },
      background = {   -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus",
      },
    },
    config = function(_, opts)
      -- vim.cmd(":KanagawaCompile")
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
