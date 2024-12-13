return {
  {
    "saghen/blink.cmp",
    lazy = false,
    build = "nix run .#build-plugin",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "v2.*" },
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
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
      },
      sources = {
        default = { "lsp", "path", "luasnip", "buffer", "lazydev" },
        providers = {
          lsp = { fallbacks = { "lazydev" } },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
        },
      },
      snippets = {
        expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction) require("luasnip").jump(direction) end,
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
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "L3MON4D3/LuaSnip", -- Snippet engine
  --     "hrsh7th/cmp-nvim-lsp", -- Lsp completion source
  --     "hrsh7th/cmp-cmdline", -- Commandline completion hook
  --     "hrsh7th/cmp-buffer", -- source for buffer local words
  --     "saadparwaiz1/cmp_luasnip", -- Luasnip completion hook
  --     "hrsh7th/cmp-path", -- source for local filesystem paths
  --     "hrsh7th/cmp-nvim-lsp-document-symbol", --LSP Document Symbol source
  --   },
  --   event = { "InsertEnter", "CmdlineEnter" },
  --   config = function()
  --     local luasnip = require("luasnip")
  --
  --     local cmp = require("cmp")
  --     local cmp_select = { behavior = cmp.SelectBehavior.Select }
  --
  --     cmp.setup({
  --       -- I like the bordered look for now ;)
  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },
  --       experimental = {
  --         ghost_text = true,
  --       },
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" }, -- LSP
  --         { name = "luasnip" }, -- luasnip snippets
  --         { name = "path" }, -- filesystem paths
  --       }),
  --       mapping = {
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<C-n>"] = cmp.mapping(function()
  --           if cmp.visible() then
  --             cmp.select_next_item(cmp_select)
  --           else
  --             cmp.complete()
  --           end
  --         end),
  --         ["<C-p>"] = cmp.mapping(function()
  --           if cmp.visible() then
  --             cmp.select_prev_item(cmp_select)
  --           else
  --             cmp.complete()
  --           end
  --         end),
  --         ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  --         ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-d>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-f>"] = cmp.mapping(function()
  --           if luasnip.expand_or_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { "i", "s" }),
  --         ["<C-b>"] = cmp.mapping(function()
  --           if luasnip.jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { "i", "s" }),
  --       },
  --       formatting = {
  --         format = require("lspkind").cmp_format({}),
  --       },
  --     })
  --     -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "buffer" },
  --         { name = "nvim_lsp_document_symbol" },
  --       }),
  --     })
  --
  --     -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "path" },
  --       }, {
  --         { name = "cmdline" },
  --       }),
  --       matching = {
  --         disallow_symbol_nonprefix_matching = false,
  --         disallow_fuzzy_matching = false,
  --         disallow_partial_matching = false,
  --         disallow_prefix_unmatching = false,
  --         disallow_fullfuzzy_matching = false,
  --         disallow_partial_fuzzy_matching = false,
  --       },
  --     })
  --   end,
  -- },
  {
    "williamboman/mason.nvim",
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
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lspp_capabiiutues

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
        ensure_installed = { "bashls", "clangd", "pylsp", "ruff", "taplo", "neocmake", "lua_ls" },
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
