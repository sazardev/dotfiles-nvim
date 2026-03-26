-- ══════════════════════════════════════════════════
-- Noice — cmdline como mini-modal flat Gruvbox
-- bg #1d2021, borde #3c3836, acento naranja #d65d0e
-- ══════════════════════════════════════════════════
return {
  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view    = "cmdline_popup",
          format  = {
            cmdline     = { icon = "›", lang = "vim" },
            search_down = { icon = "/", lang = "regex" },
            search_up   = { icon = "?", lang = "regex" },
            filter      = { icon = "$", lang = "bash" },
            lua         = { icon = "›", lang = "lua" },
            help        = { icon = "›" },
          },
        },

        popupmenu  = { enabled = true, backend = "nui" },
        notify     = { enabled = false },

        messages = {
          enabled      = true,
          view         = "mini",
          view_error   = "mini",
          view_warn    = "mini",
          view_history = "messages",
          view_search  = false,
        },

        lsp = {
          progress  = { enabled = false },
          hover     = { enabled = false },
          signature = { enabled = false },
          message   = { enabled = false },
          override  = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"]                = true,
          },
        },

        presets = {
          bottom_search         = false,
          command_palette       = false,
          long_message_to_split = true,
          inc_rename            = false,
        },

        views = {
          cmdline_popup = {
            position    = { row = "38%", col = "50%" },
            size        = { width = 56, height = "auto" },
            border      = {
              style   = "single",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = "Normal:NoiceCmdlinePopup,FloatBorder:NoiceCmdlinePopupBorder",
              winblend     = 0,
              cursorline   = false,
            },
          },
          popupmenu = {
            relative = "editor",
            position = { row = "50%", col = "50%" },
            size     = { width = 56, height = 10 },
            border   = {
              style   = "single",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = "Normal:NoiceCmdlinePopup,FloatBorder:NoiceCmdlinePopupBorder",
              winblend     = 0,
            },
          },
          mini = {
            position    = { row = -2, col = -2 },
            size        = { width = "auto", height = "auto" },
            border      = { style = "none" },
            win_options = {
              winblend     = 0,
              winhighlight = "Normal:NoiceMini",
            },
          },
        },
      })

      -- ── Colores: bg igual al terminal #1d2021 ────
      local bg     = "#1d2021"
      local border = "#3c3836"
      local fg     = "#ebdbb2"
      local fg_dim = "#928374"
      local orange = "#d65d0e"
      local yellow = "#fabd2f"

      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",        { bg = bg,  fg = fg })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder",  { bg = bg,  fg = border })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIcon",         { bg = bg,  fg = orange, bold = true })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch",   { bg = bg,  fg = yellow, bold = true })
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle",   { bg = bg,  fg = fg_dim })
      vim.api.nvim_set_hl(0, "NoicePopupMenu",           { bg = bg,  fg = fg })
      vim.api.nvim_set_hl(0, "NoicePopupMenuBorder",     { bg = bg,  fg = border })
      vim.api.nvim_set_hl(0, "NoicePopupMenuSelected",   { bg = "#3c3836", fg = fg, bold = true })
      vim.api.nvim_set_hl(0, "NoiceConfirm",             { bg = bg,  fg = fg })
      vim.api.nvim_set_hl(0, "NoiceConfirmBorder",       { bg = bg,  fg = border })
      vim.api.nvim_set_hl(0, "NoiceMini",                { bg = bg,  fg = fg_dim })
      vim.api.nvim_set_hl(0, "NoiceFormatProgressTodo",  { bg = bg,  fg = border })
      vim.api.nvim_set_hl(0, "NoiceFormatProgressDone",  { bg = bg,  fg = orange })
    end,
  },
}
