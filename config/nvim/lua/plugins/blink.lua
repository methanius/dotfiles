return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  build = function()
    -- build the fuzzy matcher, wait up to 60 seconds
    -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
    require('blink.cmp').build():wait(600000)
  end,
  dependencies = {
    { "L3MON4D3/LuaSnip", version = "v2.*" },
    "folke/lazydev.nvim",
    "saghen/blink.lib",
  },
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
      ["<C-f>"] = { "snippet_forward", "fallback" },
      ["<C-b>"] = { "snippet_backward", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono"
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100, },
      },
    },
    snippets = {
      preset = "luasnip",
    },

    completion = {
      menu = {
        winhighlight =
        "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      ghost_text = {
        enabled = true,
      },
    },
    signature = {
      enabled = true,
    }
  },
}
