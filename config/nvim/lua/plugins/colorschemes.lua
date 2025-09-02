return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        floats = "transparent",
      },
      plugins = {
        auto = true,
      },
      on_highlights = function(hl, c)
        hl.DapBreakpoint = { link = "DiagnosticWarn" }
        hl.DapBreakpointCondition = { link = "DiagnosticWarn" }
        hl.DapBreakpointRejected = { link = "DiagnosticError" }
        hl.DapLogPoint = { link = "DiagnosticHint" }
        hl.debugPC = { bg = c.bg_highlight }
      end,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      statementStyle = { bold = false },
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          TelescopeTitle = { bg = "none", fg = theme.ui.special, bold = true },
          TelescopeBorder = { bg = "none" },
          DapBreakpoint = { link = "DiagnosticWarn" },
          DapBreakpointCondition = { link = "DiagnosticWarn" },
          DapBreakpointRejected = { link = "DiagnosticError" },
          DapLogPoint = { link = "DiagnosticHint" },
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
  },
}
