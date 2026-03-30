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

      vim.api.nvim_set_hl(0, "AlphaName",       { fg = "#d65d0e", bold = true })
      vim.api.nvim_set_hl(0, "AlphaInfo",       { fg = "#504945" })
      vim.api.nvim_set_hl(0, "AlphaUpdate",     { fg = "#b8bb26" })
      vim.api.nvim_set_hl(0, "AlphaSep",        { fg = "#3c3836" })
      vim.api.nvim_set_hl(0, "AlphaKey",        { fg = "#d65d0e", bold = true })
      vim.api.nvim_set_hl(0, "AlphaDesc",       { fg = "#665c54" })
      vim.api.nvim_set_hl(0, "AlphaGitProject", { fg = "#fabd2f", bold = true })
      vim.api.nvim_set_hl(0, "AlphaGitBranch",  { fg = "#83a598" })
      vim.api.nvim_set_hl(0, "AlphaGitAhead",   { fg = "#b8bb26" })
      vim.api.nvim_set_hl(0, "AlphaGitBehind",  { fg = "#fb4934" })
      vim.api.nvim_set_hl(0, "AlphaGitDirty",   { fg = "#d65d0e" })
      vim.api.nvim_set_hl(0, "AlphaGitClean",   { fg = "#504945" })

      -- ── Info dinámica ──────────────────────────────
      local v       = vim.version()
      local ver     = "nvim v" .. v.major .. "." .. v.minor .. "." .. v.patch
      local stats   = require("lazy").stats()
      local plugins = stats.count .. " plugins"
      local date    = os.date("%a %d %b · %H:%M"):lower()

      local ok_ls, ls = pcall(require, "lazy.status")
      local updates = (ok_ls and ls.has_updates()) and ls.updates() or nil

      -- ── Git info ───────────────────────────────────
      local function git_info()
        local function run(cmd)
          local out = vim.fn.system(cmd)
          return vim.trim(out)
        end

        -- Check we're inside a git repo
        local root = run("git rev-parse --show-toplevel 2>/dev/null")
        if root == "" or vim.v.shell_error ~= 0 then return nil end

        local project  = vim.fn.fnamemodify(root, ":t")
        local branch   = run("git rev-parse --abbrev-ref HEAD 2>/dev/null")

        -- Branches (remote + local, deduped, sorted, max 5)
        local raw_branches = run("git branch -a --format='%(refname:short)' 2>/dev/null")
        local seen, branch_list = {}, {}
        for b in raw_branches:gmatch("[^\n]+") do
          local clean = b:gsub("^origin/", ""):gsub("^HEAD.*", "")
          clean = vim.trim(clean)
          if clean ~= "" and not seen[clean] then
            seen[clean] = true
            table.insert(branch_list, clean)
          end
        end
        table.sort(branch_list)
        local shown = {}
        for i, b in ipairs(branch_list) do
          if i > 5 then
            table.insert(shown, "+" .. (#branch_list - 5) .. " more")
            break
          end
          table.insert(shown, b == branch and ("* " .. b) or b)
        end

        -- Ahead / behind vs upstream
        local ahead_behind = run("git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null")
        local ahead, behind = ahead_behind:match("(%d+)%s+(%d+)")
        ahead  = tonumber(ahead)  or 0
        behind = tonumber(behind) or 0

        -- Dirty state: staged + unstaged
        local dirty   = run("git status --porcelain 2>/dev/null")
        local changes = 0
        for _ in dirty:gmatch("\n") do changes = changes + 1 end
        if dirty ~= "" then changes = changes + 1 end

        return {
          project  = project,
          branch   = branch,
          branches = table.concat(shown, "  ·  "),
          ahead    = ahead,
          behind   = behind,
          changes  = changes,
        }
      end

      local git = git_info()

      -- ── Button factory ─────────────────────────────
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

      local function txt(val, hl)
        return { type = "text", val = { val }, opts = { hl = hl or "AlphaInfo", position = "center" } }
      end

      local sep = txt(string.rep("─", 34), "AlphaSep")

      -- ── Grupos ─────────────────────────────────────
      local nav = {
        btn("f", "find file",    "Telescope find_files"),
        btn("r", "recent",       "Telescope oldfiles"),
        btn("g", "grep",         "Telescope live_grep"),
        btn("b", "buffers",      "Telescope buffers"),
        btn("e", "explorer",     "NvimTreeToggle"),
        btn("s", "symbols",      "Telescope lsp_document_symbols"),
        btn("t", "terminal",     "ToggleTerm direction=float"),
      }

      local sys = {
        btn("u", "update",   "Lazy sync"),
        btn("p", "plugins",  "Lazy"),
        btn("m", "mason",    "Mason"),
        btn("c", "config",   "e " .. vim.fn.stdpath("config") .. "/init.lua"),
        btn("h", "health",   "checkhealth"),
        btn("q", "quit",     "qa"),
      }

      -- ── Layout base ────────────────────────────────
      local layout = {
        { type = "padding", val = 4 },
        txt("sazar", "AlphaName"),
        { type = "padding", val = 1 },
        txt(ver .. "  ·  " .. plugins .. "  ·  " .. date),
      }

      if updates then
        table.insert(layout, txt(updates .. " updates available", "AlphaUpdate"))
      end

      -- ── Sección git (solo si hay repo) ─────────────
      if git then
        local status_parts = {}
        if git.behind > 0 then
          table.insert(status_parts, { git.behind .. " behind", "AlphaGitBehind" })
        end
        if git.ahead > 0 then
          table.insert(status_parts, { git.ahead .. " ahead", "AlphaGitAhead" })
        end
        if git.changes > 0 then
          table.insert(status_parts, { git.changes .. " changed", "AlphaGitDirty" })
        end
        if #status_parts == 0 then
          table.insert(status_parts, { "clean", "AlphaGitClean" })
        end

        -- Build status string (plain text; color per-entry via hl array)
        local status_str = ""
        local status_hl  = {}
        for _, part in ipairs(status_parts) do
          if status_str ~= "" then
            status_hl[#status_hl + 1] = { "AlphaInfo", #status_str, #status_str + 3 }
            status_str = status_str .. "  ·  "
          end
          status_hl[#status_hl + 1] = { part[2], #status_str, #status_str + #part[1] }
          status_str = status_str .. part[1]
        end

        table.insert(layout, { type = "padding", val = 1 })
        table.insert(layout, sep)
        table.insert(layout, { type = "padding", val = 1 })

        -- Project name
        table.insert(layout, {
          type = "text",
          val  = { git.project },
          opts = { hl = "AlphaGitProject", position = "center" },
        })

        -- Branch
        table.insert(layout, {
          type = "text",
          val  = { git.branch },
          opts = { hl = "AlphaGitBranch", position = "center" },
        })

        -- Status (ahead/behind/dirty)
        table.insert(layout, {
          type = "text",
          val  = { status_str },
          opts = {
            hl       = status_hl,
            position = "center",
          },
        })

        -- All branches
        table.insert(layout, {
          type = "text",
          val  = { git.branches },
          opts = { hl = "AlphaInfo", position = "center" },
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
        highlight_modified  = "name",
        indent_markers      = { enable = true, icons = { corner = "└", edge = "│", item = "│", none = " " } },
        icons = {
          show              = { git = true, file = true, folder = true, folder_arrow = false },
          git_placement     = "after",
        },
      },
      filters    = { dotfiles = false },
      git        = { enable = true, ignore = false, show_on_dirs = true, show_on_open_dirs = true },
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
