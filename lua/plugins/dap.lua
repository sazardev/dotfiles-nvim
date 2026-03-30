-- ══════════════════════════════════════════════════
-- DAP — Debugger (Go, Flutter/Dart, Java)
-- Requiere: delve instalado (go install github.com/go-delve/delve/cmd/dlv@latest)
-- ══════════════════════════════════════════════════
return {
  -- ── Core DAP ───────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    -- Lazy: solo carga cuando se usan keymaps de debug (<Space>D*)
    keys = { "<leader>Db", "<leader>Dc", "<leader>Di", "<leader>Do", "<leader>Du", "<leader>Dt" },
  },

  -- ── DAP UI ─────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({
        icons    = { expanded = "", collapsed = "", current_frame = "" },
        layouts  = {
          {
            elements = {
              { id = "scopes",      size = 0.35 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.20 },
            },
            size     = 40,
            position = "left",
          },
          {
            elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
            size     = 10,
            position = "bottom",
          },
        },
        floating  = { border = "single" },
      })

      -- Abrir/cerrar UI automáticamente al iniciar/terminar debug
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

      -- Colores Gruvbox para breakpoints
      vim.api.nvim_set_hl(0, "DapBreakpoint",       { fg = "#fb4934" })
      vim.api.nvim_set_hl(0, "DapBreakpointCond",   { fg = "#fabd2f" })
      vim.api.nvim_set_hl(0, "DapLogPoint",         { fg = "#83a598" })
      vim.api.nvim_set_hl(0, "DapStopped",          { fg = "#b8bb26", bg = "#3c3836" })

      vim.fn.sign_define("DapBreakpoint",      { text = "●", texthl = "DapBreakpoint",     linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCond",  { text = "◆", texthl = "DapBreakpointCond", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint",        { text = "◎", texthl = "DapLogPoint",       linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",         { text = "→", texthl = "DapStopped",        linehl = "DapStopped", numhl = "" })
    end,
  },

  -- ── DAP Virtual Text — valores inline ──────────
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    opts = {
      enabled                = true,
      enabled_commands       = true,
      highlight_changed_variables = true,
      highlight_new_as_changed    = true,
      show_stop_reason       = true,
      commented              = false,
      virt_text_pos          = "eol",
    },
  },

  -- ── DAP Go — debugger con Delve ────────────────
  {
    "leoluz/nvim-dap-go",
    ft           = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    config       = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type    = "go",
            name    = "Debug",
            request = "launch",
            program = "${file}",
          },
          {
            type    = "go",
            name    = "Debug Package",
            request = "launch",
            program = "${fileDirname}",
          },
          {
            type    = "go",
            name    = "Attach (local)",
            request = "attach",
            mode    = "local",
            processId = require("dap.utils").pick_process,
          },
        },
        delve = {
          path        = "dlv",
          initialize_timeout_sec = 20,
          port        = "${port}",
          args        = {},
          build_flags = "",
        },
      })
    end,
  },
}
