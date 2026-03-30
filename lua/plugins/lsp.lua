-- ══════════════════════════════════════════════════
-- LSP + Autocompletado + Formateo
-- Stack: Go, Dart/Flutter, TS/Astro/React/Solid,
--        Java, Docker, YAML, JSON, Terraform, Shell
-- ══════════════════════════════════════════════════
return {
  -- ── Mason — instalador de LSPs y herramientas ──
  {
    "williamboman/mason.nvim",
    cmd  = "Mason",
    opts = {
      ui = {
        border = "single",
        icons  = { package_installed = "✓", package_pending = "→", package_uninstalled = "✗" },
      },
    },
  },

  -- ── Mason Tool Installer — herramientas automáticas ──
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Formateadores
        "stylua",
        "prettier",
        "shfmt",
        -- Linters
        "eslint_d",
        -- Debuggers
        "delve",           -- Go debugger
        "java-debug-adapter",
      },
      auto_update = false,
      run_on_start = true,
    },
  },

  -- ── Mason-LSPConfig — bridge Mason ↔ lspconfig ──
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Web / Frontend
        "ts_ls",        -- TypeScript / JavaScript
        "eslint",       -- Linter JS/TS
        "astro",        -- Astro
        "tailwindcss",  -- Tailwind CSS
        "html",         -- HTML
        "cssls",        -- CSS
        -- Backend
        "gopls",        -- Go
        "jdtls",        -- Java
        "bashls",       -- Bash / Shell
        -- Infra / DevOps
        "dockerls",                    -- Dockerfile
        "docker_compose_language_service", -- docker-compose
        "yamlls",       -- YAML (K8s, Azure Pipelines, GH Actions)
        "jsonls",       -- JSON + schemas
        "terraformls",  -- Terraform / OpenTofu
        -- Config
        "lua_ls",       -- Lua (Neovim config)
        "taplo",        -- TOML
      },
      automatic_installation = true,
    },
  },

  -- ── nvim-lspconfig ─────────────────────────────
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ── Highlight groups para row completo ──────────
      -- Fondo tintado: cubre toda la línea con error/warn/hint/info
      vim.api.nvim_set_hl(0, "DiagnosticLineError", { bg = "#2d1b1b" })
      vim.api.nvim_set_hl(0, "DiagnosticLineWarn",  { bg = "#2d220e" })
      vim.api.nvim_set_hl(0, "DiagnosticLineHint",  { bg = "#1b2a1e" })
      vim.api.nvim_set_hl(0, "DiagnosticLineInfo",  { bg = "#1b242d" })

      -- Virtual text (fin de línea) con fondo tintado + ícono
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#fb4934", bg = "#2d1b1b", italic = false })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",  { fg = "#fabd2f", bg = "#2d220e", italic = false })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint",  { fg = "#8ec07c", bg = "#1b2a1e", italic = false })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo",  { fg = "#83a598", bg = "#1b242d", italic = false })

      vim.diagnostic.config({
        -- Virtual text siempre visible en todas las líneas
        virtual_text = {
          spacing = 4,
          prefix  = "",
          format  = function(d)
            local icons = {
              [vim.diagnostic.severity.ERROR] = " ",
              [vim.diagnostic.severity.WARN]  = " ",
              [vim.diagnostic.severity.HINT]  = "󰌵 ",
              [vim.diagnostic.severity.INFO]  = " ",
            }
            return (icons[d.severity] or "") .. d.message
          end,
        },
        -- Signs con linehl para pintar el row completo
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰌵",
            [vim.diagnostic.severity.INFO]  = " ",
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticLineError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticLineWarn",
            [vim.diagnostic.severity.HINT]  = "DiagnosticLineHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticLineInfo",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticVirtualTextWarn",
            [vim.diagnostic.severity.HINT]  = "DiagnosticVirtualTextHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticVirtualTextInfo",
          },
        },
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        float            = { border = "single", source = "always" },
      })

      -- ── Servidores básicos (sin config especial) ──
      local servers = {
        "ts_ls", "eslint", "astro", "tailwindcss",
        "html", "cssls",
        "bashls",
        "dockerls", "docker_compose_language_service",
        "taplo",
      }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
      end

      -- ── Gopls — config extendida con inlay hints ──
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt     = true,
            staticcheck = true,
            analyses = {
              unusedparams  = true,
              shadow        = true,
              useany        = true,
              nilness       = true,
              unusedwrite   = true,
            },
            hints = {
              assignVariableTypes    = true,
              compositeLiteralFields = true,
              compositeLiteralTypes  = false,  -- demasiado verboso en Flutter-style
              constantValues         = true,
              functionTypeParameters = true,
              parameterNames         = true,
              rangeVariableTypes     = true,
            },
          },
        },
      })

      -- Activar inlay hints al conectar cualquier LSP que los soporte
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })

      -- ── YAML — con schemas para K8s, GitHub Actions, Azure ──
      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        settings = {
          yaml = {
            validate  = true,
            hover     = true,
            completion = true,
            schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"]      = ".github/workflows/*.{yml,yaml}",
              ["https://json.schemastore.org/github-action.json"]        = ".github/action.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
              kubernetes = { "k8s/**/*.{yml,yaml}", "kubernetes/**/*.{yml,yaml}" },
            },
          },
        },
      })

      -- ── JSON — con schemas automáticos ──
      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        settings = {
          json = {
            validate  = { enable = true },
            schemas   = require("schemastore").json.schemas(),
          },
        },
      })

      -- ── Terraform ──
      vim.lsp.config("terraformls", {
        capabilities  = capabilities,
        filetypes     = { "terraform", "terraform-vars", "hcl" },
      })

      -- ── Lua ──
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      })

      -- ── Buf LSP (Protobuf / gRPC) ──
      vim.lsp.config("buf_ls", {
        capabilities = capabilities,
        cmd          = { "buf", "lsp", "serve" },
        filetypes    = { "proto" },
        root_markers = { "buf.yaml", ".git" },
      })
      vim.lsp.enable("buf_ls")

      -- Habilitar todos
      vim.lsp.enable(vim.list_extend(servers, {
        "gopls", "yamlls", "jsonls", "terraformls", "lua_ls",
      }))
    end,
  },

  -- ── SchemaStore — schemas para JSON y YAML ─────
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- ── nvim-cmp — autocompletado ───────────────────
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Gruvbox palette para CMP
      local hl = function(name, val) vim.api.nvim_set_hl(0, name, val) end
      local bg     = "#1d2021"
      local bg3    = "#3c3836"
      local fg     = "#ebdbb2"
      local fg_dim = "#a89984"
      local orange = "#d65d0e"
      local yellow = "#fabd2f"
      local green  = "#b8bb26"
      local blue   = "#83a598"
      local purple = "#d3869b"
      local aqua   = "#8ec07c"
      local red    = "#fb4934"

      hl("CmpNormal",              { bg = bg,  fg = fg })
      hl("CmpBorder",              { bg = bg,  fg = "#504945" })
      hl("CmpDocNormal",           { bg = bg,  fg = fg })
      hl("CmpDocBorder",           { bg = bg,  fg = "#504945" })
      hl("CmpSel",                 { bg = bg3, fg = fg, bold = true })
      hl("CmpItemAbbrMatch",       { fg = yellow, bold = true })
      hl("CmpItemAbbrMatchFuzzy",  { fg = yellow })
      hl("CmpItemAbbrDeprecated",  { fg = "#504945", strikethrough = true })
      hl("CmpItemMenu",            { fg = "#665c54" })
      -- Kind icons por categoría (paleta gruvbox)
      hl("CmpItemKindText",        { fg = fg_dim })
      hl("CmpItemKindMethod",      { fg = blue })
      hl("CmpItemKindFunction",    { fg = blue })
      hl("CmpItemKindConstructor", { fg = orange })
      hl("CmpItemKindField",       { fg = green })
      hl("CmpItemKindVariable",    { fg = fg })
      hl("CmpItemKindClass",       { fg = yellow })
      hl("CmpItemKindInterface",   { fg = yellow })
      hl("CmpItemKindModule",      { fg = orange })
      hl("CmpItemKindProperty",    { fg = green })
      hl("CmpItemKindUnit",        { fg = aqua })
      hl("CmpItemKindValue",       { fg = aqua })
      hl("CmpItemKindEnum",        { fg = yellow })
      hl("CmpItemKindKeyword",     { fg = red })
      hl("CmpItemKindSnippet",     { fg = purple })
      hl("CmpItemKindColor",       { fg = green })
      hl("CmpItemKindFile",        { fg = fg_dim })
      hl("CmpItemKindReference",   { fg = orange })
      hl("CmpItemKindFolder",      { fg = fg_dim })
      hl("CmpItemKindEnumMember",  { fg = aqua })
      hl("CmpItemKindConstant",    { fg = aqua })
      hl("CmpItemKindStruct",      { fg = yellow })
      hl("CmpItemKindEvent",       { fg = orange })
      hl("CmpItemKindOperator",    { fg = red })
      hl("CmpItemKindTypeParameter", { fg = yellow })

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          completion    = cmp.config.window.bordered({
            border     = "single",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel",
          }),
          documentation = cmp.config.window.bordered({
            border     = "single",
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-d>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),
        formatting = {
          format = function(entry, item)
            local icons = {
              nvim_lsp = "󰒍", luasnip = "", buffer = "󰈙", path = "󰉋",
            }
            item.menu = (icons[entry.source.name] or "") .. " " .. (entry.source.name or "")
            return item
          end,
        },
      })
    end,
  },

  -- ── Conform — formateo al guardar ──────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts  = {
      formatters_by_ft = {
        lua        = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        astro      = { "prettier" },
        html       = { "prettier" },
        css        = { "prettier" },
        json       = { "prettier" },
        jsonc      = { "prettier" },
        yaml       = { "prettier" },
        markdown   = { "prettier" },
        dart       = { "dart_format" },
        java       = { "google-java-format" },
        go         = { "gofmt", "goimports" },
        sh         = { "shfmt" },
        bash       = { "shfmt" },
        proto      = { "buf" },
        terraform  = { "terraform_fmt" },
      },
      format_on_save = function(bufnr)
        -- Respeta el toggle <Space>Uf
        if vim.g.autoformat == false then return end
        -- Deshabilitar para ciertos filetypes donde el LSP maneja todo
        local disable_ft = { "dart" }
        if vim.tbl_contains(disable_ft, vim.bo[bufnr].filetype) then return end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    },
  },
}
