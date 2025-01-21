return {
  {
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
  },
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonLog",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
    },
    opts = {
      pip = { upgrade_pip = true },
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "p00f/clangd_extensions.nvim",
      "onsails/lspkind.nvim",
      "saghen/blink.cmp",
      { "smjonas/inc-rename.nvim", opts = {}, },
    },
    config = function()
      --blink.cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({ capabilities = capabilities })
        end,
        ["pylsp"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.pylsp.setup({
            settings = {
              pylsp = {
                plugins = {
                  pycodestyle = {
                    enabled = false,
                  },
                  pyflakes = {
                    enabled = false,
                  },
                  mccabe = {
                    enabled = false,
                  },
                  autopep8 = {
                    enabled = false,
                  },
                  yapf = {
                    enabled = false,
                  },
                  ruff = {
                    enabled = false,
                    formatEnabled = true,
                    preview = true,
                  },
                  pylsp_mypy = {
                    live_mode = true,
                  },
                },
              },
            },
            capabilities = capabilities,
          })
        end,
      }
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = { "bashls", "clangd", "pylsp", "ruff", "lua_ls" },
        automatic_installation = true,
        handlers = handlers,
      })

      -- Futhark filetype and lsp
      vim.filetype.add({
        extension = {
          fut = "futhark",
          futhark = "futhark",
        },
      })
      require("lspconfig").futhark_lsp.setup({})
    end,
  },
}
