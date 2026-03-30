-- ══════════════════════════════════════════════════
-- Languages — Go (go.nvim) · Flutter (flutter-tools)
-- ══════════════════════════════════════════════════
return {
  -- ── Go.nvim — helpers para Go ───────────────────
  {
    "ray-x/go.nvim",
    ft           = { "go", "gomod", "gosum", "gowork" },
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
    config = function()
      require("go").setup({
        lsp_cfg         = false,  -- gopls lo maneja nvim-lspconfig
        lsp_gofumpt     = false,
        lsp_on_attach   = false,
        diagnostic      = false,  -- diagnósticos los maneja lsp.lua
        icons           = { breakpoint = "🔴", currentpos = "→" },
        dap_debug       = true,
        dap_debug_gui   = true,
        test_runner     = "go",
        run_in_floaterm = true,
      })
    end,
  },

  -- ── Flutter Tools ───────────────────────────────
  {
    "akinsho/flutter-tools.nvim",
    ft           = "dart",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {
      ui             = { border = "single" },
      widget_guides  = { enabled = true },
      dev_log        = { enabled = false },
      debugger = {
        enabled               = true,
        run_via_dap           = true,
        exception_breakpoints = {},
      },
      lsp = {
        color        = { enabled = true },
        capabilities = function()
          return require("cmp_nvim_lsp").default_capabilities()
        end,
        settings = {
          showTodos              = true,
          completeFunctionCalls  = true,
          renameFilesWithClasses = "prompt",
          enableSnippets         = true,
        },
      },
    },
    keys = {
      { "<leader>Fs", "<cmd>FlutterRun<cr>",           desc = "Flutter Run" },
      { "<leader>Fr", "<cmd>FlutterReload<cr>",        desc = "Flutter Reload" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>",       desc = "Flutter Restart" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>",          desc = "Flutter Quit" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>",       desc = "Flutter Devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>",     desc = "Flutter Emulators" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter Outline" },
      { "<leader>FD", "<cmd>FlutterDebugAdapters<cr>", desc = "Flutter Debug Adapters" },
      { "<leader>Fv", "<cmd>FlutterVisualDebug<cr>",   desc = "Flutter Visual Debug" },
      { "<leader>Fl", "<cmd>FlutterLspRestart<cr>",    desc = "Flutter LSP Restart" },
      { "<leader>Fp", "<cmd>FlutterPubGet<cr>",        desc = "Flutter Pub Get" },
      { "<leader>FP", "<cmd>FlutterPubUpgrade<cr>",    desc = "Flutter Pub Upgrade" },
    },
  },
}
