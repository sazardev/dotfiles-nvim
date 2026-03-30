-- ══════════════════════════════════════════════════
-- UI — flat, minimal, Gruvbox hard dark
-- Sin bordes redondeados, sin sombras, sin fondo
-- Coherente con Hyprland + Waybar + Kitty
-- ══════════════════════════════════════════════════
return {
  -- ── Alpha — dashboard estilo waybar ────────────
  {
    "goolord/alpha-nvim",
    event        = "VimEnter",
    config = function()
      local alpha = require("alpha")

      vim.api.nvim_set_hl(0, "AlphaName",    { fg = "#d65d0e", bold = true })
      vim.api.nvim_set_hl(0, "AlphaInfo",    { fg = "#504945" })
      vim.api.nvim_set_hl(0, "AlphaUpdate",  { fg = "#b8bb26" })
      vim.api.nvim_set_hl(0, "AlphaSep",     { fg = "#3c3836" })
      vim.api.nvim_set_hl(0, "AlphaKey",     { fg = "#d65d0e", bold = true })
      vim.api.nvim_set_hl(0, "AlphaDesc",    { fg = "#665c54" })

      -- Info dinámica
      local v       = vim.version()
      local ver     = "nvim v" .. v.major .. "." .. v.minor .. "." .. v.patch
      local stats   = require("lazy").stats()
      local plugins = stats.count .. " plugins"
      local date    = os.date("%a %d %b · %H:%M"):lower()

      local ok_ls, ls = pcall(require, "lazy.status")
      local updates = (ok_ls and ls.has_updates()) and ls.updates() or nil

      -- Función para crear botón sin duplicar la tecla
      -- val = "key  descripción", sin shortcut en opts
      local function btn(key, desc, action)
        return {
          type     = "button",
          val      = key .. "  " .. desc,
          on_press = function() vim.cmd(action) end,
          opts     = {
            position = "center",
            cursor   = 0,
            width    = 34,
            hl       = {
              { "AlphaKey",  0, #key },
              { "AlphaDesc", #key + 2, #key + 2 + #desc },
            },
            keymap = { "n", key, "<cmd>" .. action .. "<cr>",
                       { noremap = true, silent = true, nowait = true } },
          },
        }
      end

      local sep = {
        type = "text",
        val  = { string.rep("─", 34) },
        opts = { hl = "AlphaSep", position = "center" },
      }

      -- Grupo navegación
      local nav = {
        btn("f", "find file",        "Telescope find_files"),
        btn("r", "recent",           "Telescope oldfiles"),
        btn("g", "grep",             "Telescope live_grep"),
        btn("b", "buffers",          "Telescope buffers"),
        btn("e", "explorer",         "NvimTreeToggle"),
        btn("s", "symbols",          "Telescope lsp_document_symbols"),
        btn("t", "terminal",         "ToggleTerm direction=float"),
      }

      -- Grupo sistema / updates
      local sys = {
        btn("u", "update  —  lazy sync",    "Lazy sync"),
        btn("p", "plugins —  lazy",         "Lazy"),
        btn("m", "mason   —  lsp tools",    "Mason"),
        btn("c", "config  —  nvim",         "e " .. vim.fn.stdpath("config") .. "/init.lua"),
        btn("h", "health  —  checkhealth",  "checkhealth"),
        btn("q", "quit",                    "qa"),
      }

      -- Info line: separada en dos líneas para legibilidad
      local info_line = ver .. "  ·  " .. plugins .. "  ·  " .. date

      local layout = {
        { type = "padding", val = 5 },
        { type = "text", val = { "sazar" },
          opts = { hl = "AlphaName", position = "center" } },
        { type = "padding", val = 1 },
        { type = "text", val = { info_line },
          opts = { hl = "AlphaInfo", position = "center" } },
      }

      -- Mostrar updates disponibles si los hay
      if updates then
        table.insert(layout, {
          type = "text", val = { updates .. " updates available" },
          opts = { hl = "AlphaUpdate", position = "center" },
        })
      end

      table.insert(layout, { type = "padding", val = 1 })
      table.insert(layout, sep)
      table.insert(layout, { type = "padding", val = 1 })
      table.insert(layout, { type = "group", val = nav, opts = { spacing = 0 } })
      table.insert(layout, { type = "padding", val = 1 })
      table.insert(layout, sep)
      table.insert(layout, { type = "padding", val = 1 })
      table.insert(layout, { type = "group", val = sys, opts = { spacing = 0 } })
      table.insert(layout, { type = "padding", val = 3 })

      alpha.setup({ layout = layout, opts = { noautocmd = true } })
    end,
  },

  -- ── Lualine — flat, sin secciones con fondo ────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      -- Tema flat: mismo fondo que la terminal (#1d2021)
      -- Solo el modo cambia de color, sin bloques de fondo
      local colors = {
        bg      = "#1d2021",
        fg      = "#a89984",
        fg_dim  = "#504945",
        orange  = "#d65d0e",
        green   = "#b8bb26",
        yellow  = "#fabd2f",
        red     = "#fb4934",
        blue    = "#83a598",
        purple  = "#d3869b",
      }

      local flat = {
        normal   = { a = { fg = colors.orange, bg = colors.bg, gui = "bold" }, b = { fg = colors.fg,  bg = colors.bg }, c = { fg = colors.fg_dim, bg = colors.bg } },
        insert   = { a = { fg = colors.green,  bg = colors.bg, gui = "bold" }, b = { fg = colors.fg,  bg = colors.bg }, c = { fg = colors.fg_dim, bg = colors.bg } },
        visual   = { a = { fg = colors.yellow, bg = colors.bg, gui = "bold" }, b = { fg = colors.fg,  bg = colors.bg }, c = { fg = colors.fg_dim, bg = colors.bg } },
        replace  = { a = { fg = colors.red,    bg = colors.bg, gui = "bold" }, b = { fg = colors.fg,  bg = colors.bg }, c = { fg = colors.fg_dim, bg = colors.bg } },
        command  = { a = { fg = colors.blue,   bg = colors.bg, gui = "bold" }, b = { fg = colors.fg,  bg = colors.bg }, c = { fg = colors.fg_dim, bg = colors.bg } },
        terminal = { a = { fg = colors.purple, bg = colors.bg, gui = "bold" }, b = { fg = colors.fg,  bg = colors.bg }, c = { fg = colors.fg_dim, bg = colors.bg } },
        inactive = { a = { fg = colors.fg_dim, bg = colors.bg },               b = { fg = colors.fg_dim, bg = colors.bg }, c = { fg = colors.fg_dim, bg = colors.bg } },
      }

      require("lualine").setup({
        options = {
          theme                = flat,
          component_separators = { left = "│", right = "│" },
          section_separators   = { left = "",  right = "" },
          globalstatus         = true,
          disabled_filetypes   = { statusline = { "NvimTree", "alpha" } },
        },
        sections = {
          lualine_a = {
            { "mode", fmt = function(s) return s:lower() end },
            -- Indicador de macro grabándose (vital)
            {
              function()
                local reg = vim.fn.reg_recording()
                return reg ~= "" and "  @" .. reg or ""
              end,
              color = { fg = "#fb4934", gui = "bold" },
            },
          },
          lualine_b = {
            "branch",
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            { "filename", path = 1, symbols = { modified = "  ", readonly = " ", unnamed = "…" } },
            -- Harpoon: slot del archivo actual
            {
              function()
                local ok, harpoon = pcall(require, "harpoon")
                if not ok then return "" end
                local list = harpoon:list()
                local path = vim.fn.expand("%:p")
                for i, item in ipairs(list.items) do
                  if vim.fn.fnamemodify(item.value, ":p") == path then
                    return "  " .. i
                  end
                end
                return ""
              end,
              color = { fg = "#d65d0e" },
            },
          },
          lualine_x = {
            -- LSP status (qué servidor está activo)
            {
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                local names = vim.tbl_map(function(c) return c.name end, clients)
                return "  " .. table.concat(names, ", ")
              end,
              color = { fg = "#928374" },
            },
            { "diagnostics", symbols = { error = " ", warn = " ", hint = "󰌵 ", info = " " } },
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
        },
      })
    end,
  },

  -- ── Bufferline ─────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts  = {
      options = {
        mode                    = "buffers",
        separator_style         = "thin",
        show_buffer_close_icons = false,
        show_close_icon         = false,
        always_show_bufferline  = false,
        offsets = {
          { filetype = "NvimTree", text = "explorer", text_align = "left", separator = true },
        },
      },
      highlights = {
        fill               = { bg = "#1d2021" },
        background         = { fg = "#504945", bg = "#1d2021" },
        tab                = { fg = "#504945", bg = "#1d2021" },
        tab_selected       = { fg = "#ebdbb2", bg = "#1d2021" },
        buffer_visible     = { fg = "#665c54", bg = "#1d2021" },
        buffer_selected    = { fg = "#ebdbb2", bg = "#1d2021", bold = true, italic = false },
        separator          = { fg = "#3c3836", bg = "#1d2021" },
        separator_selected = { fg = "#3c3836", bg = "#1d2021" },
        indicator_selected = { fg = "#d65d0e", bg = "#1d2021" },
        modified           = { fg = "#d79921", bg = "#1d2021" },
        modified_selected  = { fg = "#fabd2f", bg = "#1d2021" },
      },
    },
  },

  -- ── NvimTree ────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    cmd          = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view     = { width = 28, side = "left" },
      renderer = {
        group_empty         = true,
        highlight_git       = true,
        indent_markers      = { enable = true, icons = { corner = "└", edge = "│", item = "│", none = " " } },
        icons = {
          show              = { git = true, file = true, folder = true, folder_arrow = false },
          git_placement     = "after",
        },
      },
      filters    = { dotfiles = false },
      git        = { enable = true, ignore = false },
      actions    = {
        open_file = { quit_on_open = false, resize_window = false },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      -- Gruvbox git status colors
      local hl = function(name, val) vim.api.nvim_set_hl(0, name, val) end
      hl("NvimTreeGitNew",          { fg = "#b8bb26" })  -- verde: untracked
      hl("NvimTreeGitDirty",        { fg = "#fabd2f" })  -- amarillo: modified
      hl("NvimTreeGitStaged",       { fg = "#83a598" })  -- azul: staged
      hl("NvimTreeGitDeleted",      { fg = "#fb4934" })  -- rojo: deleted
      hl("NvimTreeGitRenamed",      { fg = "#8ec07c" })  -- aqua: renamed
      hl("NvimTreeGitMerge",        { fg = "#d3869b" })  -- purple: merge conflict
      hl("NvimTreeGitIgnored",      { fg = "#504945" })  -- gris: ignored
      hl("NvimTreeOpenedFile",      { fg = "#d65d0e", bold = true })  -- naranja: abierto
      hl("NvimTreeFolderName",      { fg = "#83a598" })
      hl("NvimTreeOpenedFolderName",{ fg = "#d65d0e", bold = true })
      hl("NvimTreeRootFolder",      { fg = "#d65d0e", bold = true })
      hl("NvimTreeSpecialFile",     { fg = "#d3869b" })
      hl("NvimTreeExecFile",        { fg = "#b8bb26" })
    end,
  },

  -- ── Indent Blankline — guías sutiles ───────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = "BufReadPost",
    opts  = {
      indent = { char = "▏", highlight = "IblIndent" },
      scope  = { enabled = true, highlight = "IblScope" },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#282828" })
      vim.api.nvim_set_hl(0, "IblScope",  { fg = "#3c3836" })
      require("ibl").setup(opts)
    end,
  },

  -- ── Devicons ────────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
