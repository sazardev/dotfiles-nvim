-- ══════════════════════════════════════════════════
-- Editor: telescope, treesitter, git, terminal, AI,
--         testing, debugging helpers, etc.
-- ══════════════════════════════════════════════════
return {
  -- ── Telescope ──────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cmd  = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      defaults = {
        prompt_prefix    = "  ",
        selection_caret  = " ",
        sorting_strategy = "ascending",
        layout_config    = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          width = 0.87, height = 0.80,
        },
        file_ignore_patterns = { "node_modules", ".git/", "target/", "__pycache__", ".dart_tool/" },
      },
    },
  },

  -- ── Treesitter ─────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      ensure_installed = {
        "lua", "python", "javascript", "typescript", "tsx",
        "go", "gomod", "gosum", "gowork",
        "bash", "json", "jsonc", "yaml", "toml", "markdown", "markdown_inline",
        "html", "css", "astro",
        "dart", "java",
        "dockerfile", "terraform", "hcl",
        "proto", "sql",
        "regex", "vim", "vimdoc",
      },
      highlight    = { enable = true },
      indent       = { enable = true },
      auto_install = true,
    },
  },

  -- ── Treesitter Context — muestra función/clase actual ──
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts  = {
      max_lines      = 3,
      trim_scope     = "outer",
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      vim.api.nvim_set_hl(0, "TreesitterContext",           { bg = "#282828" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#7c6f64", bg = "#282828" })
    end,
  },

  -- ── Autopairs ──────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts  = { check_ts = true },
  },

  -- ── Comment ────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    opts  = {},
  },

  -- ── Gitsigns — indicadores git en gutter ───────
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk,               "Next Hunk")
        map("n", "[h", gs.prev_hunk,               "Prev Hunk")
        map("n", "<leader>hs", gs.stage_hunk,      "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk,      "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer,    "Stage Buffer")
        map("n", "<leader>hR", gs.reset_buffer,    "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk,    "Preview Hunk")
        map("n", "<leader>hb", gs.blame_line,      "Blame Line")
        map("n", "<leader>hd", gs.diffthis,        "Diff This")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.api.nvim_set_hl(0, "GitSignsAdd",    { fg = "#b8bb26" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#fabd2f" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#fb4934" })
    end,
  },

  -- ── Which-key — grupos de atajos flat Gruvbox ──
  {
    "folke/which-key.nvim",
    event  = "VeryLazy",
    opts   = {
      win = {
        border  = "none",
        padding = { 1, 2 },
        wo      = { winblend = 0 },
      },
      layout  = { spacing = 5 },
      icons   = { separator = "→", group = "", breadcrumb = "›" },
      show_help = false,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Colores Gruvbox flat (mismo bg que terminal)
      vim.api.nvim_set_hl(0, "WhichKey",          { fg = "#d65d0e", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyDesc",      { fg = "#ebdbb2", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyGroup",     { fg = "#83a598", bg = "#1d2021", bold = true })
      vim.api.nvim_set_hl(0, "WhichKeyNormal",    { bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyFloat",     { bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyBorder",    { fg = "#3c3836", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = "#504945", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "WhichKeyValue",     { fg = "#928374", bg = "#1d2021" })

      wk.add({
        { "<leader>a", group = "ai" },
        { "<leader>D", group = "debug" },
        { "<leader>d", group = "diagnostics" },
        { "<leader>f", group = "find" },
        { "<leader>F", group = "flutter" },
        { "<leader>g", group = "go" },
        { "<leader>h", group = "git hunks" },
        { "<leader>r", group = "rename" },
        { "<leader>s", group = "search/replace" },
        { "<leader>T", group = "tests" },
        { "<leader>t", group = "terminal" },
      })
    end,
  },

  -- ── ToggleTerm + LazyGit ────────────────────────
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event   = "VeryLazy",
    opts    = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping    = [[<C-\>]],
      hide_numbers    = true,
      shade_terminals = false,
      start_in_insert = true,
      persist_mode    = true,
      direction       = "float",
      float_opts      = {
        border   = "single",
        winblend = 0,
      },
      highlights = {
        FloatBorder = { guifg = "#504945" },
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- LazyGit toggle
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit  = Terminal:new({
        cmd       = "lazygit",
        hidden    = true,
        direction = "float",
        float_opts = { border = "single" },
        on_open   = function(t) vim.cmd("startinsert!") end,
      })
      _LAZYGIT_TOGGLE = function() lazygit:toggle() end
    end,
  },

  -- ── Go.nvim — helpers para Go ───────────────────
  {
    "ray-x/go.nvim",
    ft           = { "go", "gomod", "gosum", "gowork" },
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
    config = function()
      require("go").setup({
        lsp_cfg          = false,  -- gopls lo maneja nvim-lspconfig
        lsp_gofumpt      = false,
        lsp_on_attach    = false,
        diagnostic       = false,  -- diagnósticos los maneja tiny-inline-diagnostic
        icons            = { breakpoint = "🔴", currentpos = "→" },
        dap_debug        = true,
        dap_debug_gui    = true,
        test_runner      = "go",
        run_in_floaterm  = true,
      })
    end,
  },

  -- ── Neotest — test runner universal ────────────
  {
    "nvim-neotest/neotest",
    event        = "BufReadPost",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({
            experimental = { test_table = true },
          }),
        },
        output  = { open_on_run = true },
        summary = {
          open = "botright vsplit | vertical resize 40",
        },
        icons = {
          running     = "⟳",
          passed      = "✓",
          failed      = "✗",
          skipped     = "○",
          unknown     = "?",
        },
      })
    end,
  },

  -- ── Spectre — search & replace global ──────────
  {
    "nvim-pack/nvim-spectre",
    cmd          = "Spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {
      open_cmd    = "noswapfile vnew",
      color_devicons = true,
      highlight   = {
        ui      = "String",
        search  = "DiffChange",
        replace = "DiffDelete",
      },
    },
  },

  -- ── CopilotChat — chat con Copilot / IA ────────
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event        = "VeryLazy",
    dependencies = { "github/copilot.vim", "nvim-lua/plenary.nvim" },
    opts = {
      window = {
        layout   = "float",
        width    = 0.45,
        height   = 0.85,
        border   = "single",
      },
      show_help        = false,
      auto_insert_mode = false,
      mappings = {
        reset = { normal = "<C-x>", insert = "<C-x>" },
      },
    },
  },

  -- ── GitHub Copilot (sugerencias inline) ────────
  {
    "github/copilot.vim",
    cmd   = "Copilot",
    event = "InsertEnter",
  },

  -- ── Mini surround ───────────────────────────────
  {
    "echasnovski/mini.surround",
    event = "BufReadPost",
    opts  = {},
  },

  -- ── Flash — navegación rápida ───────────────────
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {},
    keys  = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    },
  },


  -- ── Trouble — panel de diagnósticos ────────────
  {
    "folke/trouble.nvim",
    cmd          = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts         = {},
    keys         = {
      { "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics" },
      { "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    },
  },

  -- ── Todo Comments ───────────────────────────────
  {
    "folke/todo-comments.nvim",
    event        = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {
      signs     = true,
      highlight = { multiline = false },
    },
  },

  -- ── Vim Illuminate — resalta ocurrencias ────────
  {
    "RRethy/vim-illuminate",
    event  = "BufReadPost",
    config = function()
      require("illuminate").configure({
        delay             = 200,
        filetypes_denylist = { "NvimTree", "Trouble", "lazy", "alpha" },
      })
      vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = "#3c3836" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = "#3c3836" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3c3836" })
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
      lsp = {
        color        = { enabled = true },
        capabilities = function()
          return require("cmp_nvim_lsp").default_capabilities()
        end,
      },
    },
    keys = {
      { "<leader>Fs", "<cmd>FlutterRun<cr>",          desc = "Flutter Run" },
      { "<leader>Fr", "<cmd>FlutterReload<cr>",        desc = "Flutter Reload" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>",       desc = "Flutter Restart" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>",          desc = "Flutter Quit" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>",       desc = "Flutter Devices" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter Outline" },
    },
  },
}
