-- ══════════════════════════════════════════════════
-- Noice — command line como mini-modal centrado
-- Requiere cmdheight = 0 en options.lua
-- ══════════════════════════════════════════════════
return {
  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      -- ── Cmdline — modal centrado ────────────────
      cmdline = {
        enabled = true,
        view    = "cmdline_popup",
        format  = {
          cmdline       = { icon = "›",  lang = "vim" },
          search_down   = { icon = "  " },
          search_up     = { icon = "  " },
          filter        = { icon = "$",  lang = "bash" },
          lua           = { icon = "  ", lang = "lua" },
          help          = { icon = "󰋖  " },
        },
      },

      -- ── Popup menu ──────────────────────────────
      popupmenu = {
        enabled  = true,
        backend  = "nui",
      },

      -- ── Mensajes — solo los esenciales ──────────
      messages = {
        enabled = true,
        view    = "mini",         -- mensajes normales: barra inferior discreta
        view_error   = "mini",
        view_warn    = "mini",
        view_history = "messages",
        view_search  = false,
      },

      -- ── LSP — solo lo necesario ─────────────────
      lsp = {
        progress  = { enabled = false },  -- sin spinner LSP
        hover     = { enabled = false },  -- K usa el nativo
        signature = { enabled = false },  -- sin signature popup
        message   = { enabled = false },
        override  = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
        },
      },

      -- ── Notify — sin reemplazar ─────────────────
      notify = { enabled = false },

      -- ── Presets ─────────────────────────────────
      presets = {
        bottom_search         = false,
        command_palette       = true,   -- centrado con historial
        long_message_to_split = true,
        inc_rename            = false,
      },

      -- ── Vista del cmdline_popup ─────────────────
      views = {
        cmdline_popup = {
          position = { row = "40%", col = "50%" },
          size     = { width = 60, height = "auto" },
          border   = {
            style   = "single",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = "Normal:NoicePopup,FloatBorder:NoicePopupBorder",
          },
        },
        mini = {
          win_options = {
            winblend = 0,
            winhighlight = "Normal:NoiceMini,IncSearch:,Search:",
          },
        },
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)

      -- Colores Gruvbox flat
      vim.api.nvim_set_hl(0, "NoicePopup",          { bg = "#282828", fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "NoicePopupBorder",    { bg = "#282828", fg = "#504945" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",   { bg = "#282828", fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { bg = "#282828", fg = "#504945" })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIcon",    { fg = "#d65d0e", bg = "#282828" })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#fabd2f", bg = "#282828" })
      vim.api.nvim_set_hl(0, "NoiceConfirm",        { bg = "#282828", fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "NoiceConfirmBorder",  { bg = "#282828", fg = "#504945" })
      vim.api.nvim_set_hl(0, "NoiceMini",           { bg = "#1d2021", fg = "#928374" })
    end,
  },
}
