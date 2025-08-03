return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  build = "nix run .#build-plugin",
  dependencies = {
    { "L3MON4D3/LuaSnip", version = "v2.*" },
    "folke/lazydev.nvim"
  },
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
        auto_show_delay_ms = 100,
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
