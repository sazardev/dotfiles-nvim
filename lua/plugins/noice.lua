-- ══════════════════════════════════════════════════
-- Noice — cmdline modal: 1 fondo + acento naranja
-- ══════════════════════════════════════════════════
return {
  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      local bg     = "#1d2021"
      local orange = "#d65d0e"
      local fg     = "#ebdbb2"
      local fg_dim = "#928374"
      local yellow = "#fabd2f"

      -- Definir highlights ANTES del setup para que noice los respete
      local hl = function(name, opts) vim.api.nvim_set_hl(0, name, opts) end

      hl("NoiceBase",              { bg = bg, fg = fg })
      hl("NoiceBaseBorder",        { bg = bg, fg = orange })  -- borde naranja = acento
      hl("NoiceBaseDim",           { bg = bg, fg = fg_dim })
      hl("NoiceIcon",              { bg = bg, fg = orange, bold = true })
      hl("NoiceIconSearch",        { bg = bg, fg = yellow, bold = true })
      -- Todos los grupos noice apuntan al mismo bg
      hl("NoiceCmdlinePopup",          { bg = bg, fg = fg })
      hl("NoiceCmdlinePopupBorder",    { bg = bg, fg = orange })
      hl("NoiceCmdlinePopupTitle",     { bg = bg, fg = fg_dim })
      hl("NoiceCmdlineIcon",           { bg = bg, fg = orange, bold = true })
      hl("NoiceCmdlineIconSearch",     { bg = bg, fg = yellow, bold = true })
      hl("NoicePopupMenu",             { bg = bg, fg = fg })
      hl("NoicePopupMenuBorder",       { bg = bg, fg = orange })
      hl("NoicePopupMenuSelected",     { bg = bg, fg = orange, bold = true })
      hl("NoicePopupMenuMatch",        { bg = bg, fg = orange })
      hl("NoiceConfirm",               { bg = bg, fg = fg })
      hl("NoiceConfirmBorder",         { bg = bg, fg = orange })
      hl("NoiceMini",                  { bg = bg, fg = fg_dim })
      hl("NoiceFormatProgressTodo",    { bg = bg, fg = fg_dim })
      hl("NoiceFormatProgressDone",    { bg = bg, fg = orange })
      -- Cubrir highlights nativos que se filtran dentro del float
      hl("NoiceFloatNormal",           { bg = bg, fg = fg })
      hl("NoiceFloatBorder",           { bg = bg, fg = orange })
      hl("NoiceCursorLine",            { bg = bg, fg = fg })

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
            position = { row = "38%", col = "50%" },
            size     = { width = 56, height = "auto" },
            border   = {
              style   = "single",
              padding = { 0, 1 },
            },
            win_options = {
              -- Forzar bg uniforme en TODOS los highlight internos del float
              winhighlight = table.concat({
                "Normal:NoiceCmdlinePopup",
                "FloatBorder:NoiceCmdlinePopupBorder",
                "FloatTitle:NoiceCmdlinePopupTitle",
                "NormalFloat:NoiceCmdlinePopup",
                "CursorLine:NoiceCmdlinePopup",
                "Search:NoiceCmdlinePopup",
                "IncSearch:NoiceCmdlinePopup",
              }, ","),
              winblend   = 0,
              cursorline = false,
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
              winhighlight = table.concat({
                "Normal:NoicePopupMenu",
                "FloatBorder:NoicePopupMenuBorder",
                "NormalFloat:NoicePopupMenu",
                "CursorLine:NoicePopupMenuSelected",
                "Search:NoicePopupMenu",
              }, ","),
              winblend = 0,
            },
          },

          mini = {
            position = { row = -2, col = -2 },
            size     = { width = "auto", height = "auto" },
            border   = { style = "none" },
            win_options = {
              winblend     = 0,
              winhighlight = "Normal:NoiceMini",
            },
          },
        },
      })
    end,
  },
}
