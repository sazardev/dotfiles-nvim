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

      -- Highlight groups propios (mismos colores que waybar)
      vim.api.nvim_set_hl(0, "AlphaName",   { fg = "#d65d0e", bold = true })
      vim.api.nvim_set_hl(0, "AlphaInfo",   { fg = "#504945" })
      vim.api.nvim_set_hl(0, "AlphaSep",    { fg = "#3c3836" })
      vim.api.nvim_set_hl(0, "AlphaKey",    { fg = "#d65d0e", bold = true })
      vim.api.nvim_set_hl(0, "AlphaDesc",   { fg = "#665c54" })
      vim.api.nvim_set_hl(0, "AlphaDot",    { fg = "#3c3836" })

      -- Info dinámica
      local ver     = "v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
      local plugins = require("lazy").stats().count .. " plugins"
      local date    = os.date("%a %d %b"):lower()
      local time    = os.date("%H:%M")

      -- Acciones: { key, desc, cmd }
      local actions = {
        { "f", "find file",    "<cmd>Telescope find_files<cr>" },
        { "r", "recent",       "<cmd>Telescope oldfiles<cr>" },
        { "g", "grep",         "<cmd>Telescope live_grep<cr>" },
        { "e", "explorer",     "<cmd>NvimTreeToggle<cr>" },
        { "l", "lazy",         "<cmd>Lazy<cr>" },
        { "q", "quit",         "<cmd>qa<cr>" },
      }

      -- Construir botones con highlight mixto por columna
      local buttons = {}
      for _, a in ipairs(actions) do
        local btn = {
          type = "button",
          val  = "  " .. a[1] .. "  " .. a[2],
          on_press = function() vim.cmd(a[3]:sub(6, -3)) end,
          opts = {
            position   = "left",
            shortcut   = a[1],
            cursor     = 3,
            width      = 30,
            align_shortcut = "left",
            hl_shortcut = { { "AlphaKey", 2, 3 } },
            hl = { { "AlphaDesc", 5, 5 + #a[2] } },
            keymap = { "n", a[1], a[3], { noremap = true, silent = true } },
          },
        }
        table.insert(buttons, btn)
      end

      alpha.setup({
        layout = {
          { type = "padding", val = 6 },
          {
            type = "text",
            val  = { "  sazar" },
            opts = { hl = "AlphaName", position = "left" },
          },
          { type = "padding", val = 1 },
          {
            type = "text",
            val  = { "  " .. ver .. "  ·  " .. plugins .. "  ·  " .. date .. "  ·  " .. time },
            opts = { hl = "AlphaInfo", position = "left" },
          },
          { type = "padding", val = 1 },
          {
            type = "text",
            val  = { "  ──────────────────────────" },
            opts = { hl = "AlphaSep", position = "left" },
          },
          { type = "padding", val = 1 },
          { type = "group", val = buttons, opts = { spacing = 0 } },
          { type = "padding", val = 2 },
        },
        opts = { noautocmd = true },
      })
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
          lualine_a = { { "mode", fmt = function(s) return s:lower() end } },
          lualine_b = { "branch", { "diff", symbols = { added = " ", modified = " ", removed = " " } } },
          lualine_c = { { "filename", path = 1, symbols = { modified = "  ", readonly = " ", unnamed = "…" } } },
          lualine_x = { { "diagnostics", symbols = { error = " ", warn = " ", hint = "󰌵 ", info = " " } }, "filetype" },
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
