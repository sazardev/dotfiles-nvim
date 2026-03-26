-- ══════════════════════════════════════════════════
-- UI: dashboard, statusline, bufferline, file tree
-- ══════════════════════════════════════════════════
return {
  -- ── Alpha — dashboard de inicio ────────────────
  {
    "goolord/alpha-nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha   = require("alpha")
      local dash    = require("alpha.themes.dashboard")

      -- Header
      dash.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                                     ",
      }
      dash.section.header.opts.hl = "GruvboxOrange"

      -- Botones
      dash.section.buttons.val = {
        dash.button("f", "  Find File",      "<cmd>Telescope find_files<cr>"),
        dash.button("r", "  Recent Files",   "<cmd>Telescope oldfiles<cr>"),
        dash.button("g", "  Live Grep",      "<cmd>Telescope live_grep<cr>"),
        dash.button("e", "  Explorer",       "<cmd>NvimTreeToggle<cr>"),
        dash.button("l", "󰒲  Lazy",           "<cmd>Lazy<cr>"),
        dash.button("m", "  Mason",          "<cmd>Mason<cr>"),
        dash.button("q", "  Quit",           "<cmd>qa<cr>"),
      }

      -- Colores Gruvbox para botones
      for _, button in ipairs(dash.section.buttons.val) do
        button.opts.hl        = "GruvboxBlue"
        button.opts.hl_shortcut = "GruvboxOrange"
      end

      -- Footer con versión de Neovim
      dash.section.footer.val = "Neovim v" .. tostring(vim.version())
      dash.section.footer.opts.hl = "GruvboxGray"

      dash.opts.noautocmd = true
      alpha.setup(dash.opts)
    end,
  },

  -- ── Lualine — statusline ────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts  = {
      options = {
        theme                  = "gruvbox",
        component_separators   = { left = "", right = "" },
        section_separators     = { left = "", right = "" },
        globalstatus           = true,
        disabled_filetypes     = { statusline = { "NvimTree", "alpha" } },
      },
      sections = {
        lualine_a = { { "mode", upper = true } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Bufferline — pestañas ───────────────────────
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
          { filetype = "NvimTree", text = "Explorer", text_align = "left", separator = true },
        },
      },
      highlights = {
        fill               = { bg = "#1d2021" },
        background         = { fg = "#7c6f64", bg = "#282828" },
        tab                = { fg = "#7c6f64", bg = "#282828" },
        tab_selected       = { fg = "#ebdbb2", bg = "#504945" },
        buffer_visible     = { fg = "#928374", bg = "#3c3836" },
        buffer_selected    = { fg = "#fbf1c7", bg = "#504945", bold = true },
        separator          = { fg = "#1d2021", bg = "#282828" },
        separator_selected = { fg = "#1d2021", bg = "#504945" },
        indicator_selected = { fg = "#d65d0e", bg = "#504945" },
        modified           = { fg = "#d79921", bg = "#282828" },
        modified_selected  = { fg = "#fabd2f", bg = "#504945" },
      },
    },
  },

  -- ── NvimTree — explorador de archivos ──────────
  {
    "nvim-tree/nvim-tree.lua",
    cmd          = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view     = { width = 30, side = "left" },
      renderer = {
        group_empty   = true,
        highlight_git = true,
        icons = {
          show = { git = true, file = true, folder = true, folder_arrow = true },
        },
      },
      filters = { dotfiles = false },
      git     = { enable = true, ignore = false },
      actions = {
        open_file = {
          quit_on_open  = false,
          resize_window = false,
        },
      },
    },
  },

  -- ── Indent Blankline — guías de indentado ──────
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = "BufReadPost",
    opts  = {
      indent = { char = "▏", highlight = "IblIndent" },
      scope  = { enabled = true, highlight = "IblScope" },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3c3836" })
      vim.api.nvim_set_hl(0, "IblScope",  { fg = "#504945" })
      require("ibl").setup(opts)
    end,
  },

  -- ── Devicons ────────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
