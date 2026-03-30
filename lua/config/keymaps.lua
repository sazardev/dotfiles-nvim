-- ══════════════════════════════════════════════════
-- Keymaps — productividad máxima
-- ══════════════════════════════════════════════════
local map = vim.keymap.set

vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- ── Guardar / Salir ──────────────────────────────
map("n", "<leader>w",  "<cmd>w<cr>",    { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",    { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qa!<cr>",  { desc = "Quit All" })

-- ── Ventanas ─────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window Right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Height +" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Height -" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Width -" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Width +" })

-- ── Buffers ──────────────────────────────────────
map("n", "<S-h>",      "<cmd>bprev<cr>",        { desc = "Prev Buffer" })
map("n", "<S-l>",      "<cmd>bnext<cr>",        { desc = "Next Buffer" })
map("n", "<leader>x",  "<cmd>bd<cr>",           { desc = "Close Buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>",  { desc = "Close Others" })
map("n", "<leader>bs", function() require("snacks").scratch() end, { desc = "Scratch Buffer" })

-- ── Mover líneas en visual ───────────────────────
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- ── Scroll / Búsqueda centrada ───────────────────
map("n", "n",     "nzzzv")
map("n", "N",     "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- ── Pegar sin perder registro ────────────────────
map("x", "<leader>p", '"_dP', { desc = "Paste (no yank)" })

-- ── Explorer ─────────────────────────────────────
map("n", "<leader>e",  "<cmd>NvimTreeToggle<cr>",  { desc = "File Explorer" })
map("n", "<leader>0",  "<cmd>Alpha<cr>",           { desc = "dashboard" })

-- ── Find / Telescope ─────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",           { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",            { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",              { desc = "Buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",             { desc = "Recent Files" })
map("n", "<leader>fc", "<cmd>Telescope command_history<cr>",      { desc = "Command History" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Symbols" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>",                  { desc = "TODOs" })

-- ── Terminal / ToggleTerm ────────────────────────
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal size=15<cr>", { desc = "Terminal H" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical   size=60<cr>", { desc = "Terminal V" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",              { desc = "Terminal Float" })
map("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>",                   { desc = "LazyGit" })
map("t", "<Esc><Esc>", "<C-\\><C-n>",                                      { desc = "Exit Terminal" })

-- ── Search & Replace / Spectre ───────────────────
map("n", "<leader>sr", "<cmd>lua require('spectre').open()<cr>",                          { desc = "Search & Replace" })
map("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", { desc = "Search Word" })
map("v", "<leader>sr", "<cmd>lua require('spectre').open_visual()<cr>",                   { desc = "Search Selection" })

-- ── AI / Copilot Chat ────────────────────────────
map("n", "<leader>ai", "<cmd>CopilotChatToggle<cr>",  { desc = "Chat Toggle" })
map("v", "<leader>ai", "<cmd>CopilotChatToggle<cr>",  { desc = "Chat Toggle" })
map("n", "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "Explain" })
map("v", "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "Explain" })
map("n", "<leader>af", "<cmd>CopilotChatFix<cr>",     { desc = "Fix" })
map("v", "<leader>af", "<cmd>CopilotChatFix<cr>",     { desc = "Fix" })
map("n", "<leader>ar", "<cmd>CopilotChatReview<cr>",  { desc = "Review" })
map("v", "<leader>ar", "<cmd>CopilotChatReview<cr>",  { desc = "Review" })

-- ── Go (lenguaje) ────────────────────────────────
map("n", "<leader>gr", "<cmd>GoRun<cr>",          { desc = "Go Run" })
map("n", "<leader>gb", "<cmd>GoBuild<cr>",         { desc = "Go Build" })
map("n", "<leader>gt", "<cmd>GoTest<cr>",          { desc = "Go Test" })
map("n", "<leader>gT", "<cmd>GoTestFunc<cr>",      { desc = "Go Test Func" })
map("n", "<leader>gi", "<cmd>GoImports<cr>",       { desc = "Go Imports" })
map("n", "<leader>ga", "<cmd>GoAddTag<cr>",        { desc = "Go Add Tags" })
map("n", "<leader>gR", "<cmd>GoRemoveTags<cr>",    { desc = "Go Remove Tags" })
map("n", "<leader>ge", "<cmd>GoIfErr<cr>",         { desc = "Go If Err" })
map("n", "<leader>gf", "<cmd>GoFillStruct<cr>",    { desc = "Go Fill Struct" })
map("n", "<leader>gF", "<cmd>GoFillSwitch<cr>",    { desc = "Go Fill Switch" })
map("n", "<leader>gI", "<cmd>GoImpl<cr>",          { desc = "Go Impl Interface" })
map("n", "<leader>gA", "<cmd>GoAlt<cr>",           { desc = "Go Alt (test ↔ src)" })
map("n", "<leader>gg", "<cmd>GoGenerate<cr>",      { desc = "Go Generate" })
map("n", "<leader>gm", "<cmd>GoMod tidy<cr>",      { desc = "Go Mod Tidy" })
map("n", "<leader>gc", "<cmd>GoCoverage<cr>",      { desc = "Go Coverage" })

-- ── Git / Neogit ─────────────────────────────────
map("n", "<leader>G",  "<cmd>Neogit<cr>",                    { desc = "Git Status" })
map("n", "<leader>Gc", "<cmd>Neogit commit<cr>",             { desc = "Commit" })
map("n", "<leader>Gp", "<cmd>Neogit push<cr>",               { desc = "Push" })
map("n", "<leader>GP", "<cmd>Neogit pull<cr>",               { desc = "Pull" })
map("n", "<leader>Gb", "<cmd>Neogit branch<cr>",             { desc = "Branch" })
map("n", "<leader>Gl", "<cmd>Neogit log<cr>",                { desc = "Log" })
map("n", "<leader>Gd", "<cmd>DiffviewOpen<cr>",              { desc = "Diff (working tree)" })
map("n", "<leader>GD", "<cmd>DiffviewOpen HEAD~1<cr>",       { desc = "Diff HEAD~1" })
map("n", "<leader>Gf", "<cmd>DiffviewFileHistory %<cr>",     { desc = "File History" })
map("n", "<leader>GF", "<cmd>DiffviewFileHistory<cr>",       { desc = "Repo History" })
map("n", "<leader>Gx", "<cmd>DiffviewClose<cr>",             { desc = "Close Diff" })
map("n", "<leader>GA", function()
  vim.ui.input({ prompt = "Commit message: " }, function(msg)
    if msg and msg ~= "" then
      vim.fn.system("git add -A")
      vim.fn.system("git commit -m " .. vim.fn.shellescape(msg))
      vim.notify("✓ Committed: " .. msg, vim.log.levels.INFO)
    end
  end)
end, { desc = "Add All & Commit" })

-- ── Debug / DAP ──────────────────────────────────
map("n", "<leader>Db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle Breakpoint" })
map("n", "<leader>Dc", "<cmd>lua require('dap').continue()<cr>",          { desc = "Continue" })
map("n", "<leader>Di", "<cmd>lua require('dap').step_into()<cr>",         { desc = "Step Into" })
map("n", "<leader>Do", "<cmd>lua require('dap').step_over()<cr>",         { desc = "Step Over" })
map("n", "<leader>Du", "<cmd>lua require('dapui').toggle()<cr>",          { desc = "DAP UI" })
map("n", "<leader>Dt", "<cmd>lua require('dap').terminate()<cr>",         { desc = "Terminate" })

-- ── Tests / Neotest ──────────────────────────────
map("n", "<leader>Tt", "<cmd>lua require('neotest').run.run()<cr>",                   { desc = "Run Nearest" })
map("n", "<leader>Tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run File" })
map("n", "<leader>Ts", "<cmd>lua require('neotest').summary.toggle()<cr>",            { desc = "Summary" })
map("n", "<leader>To", "<cmd>lua require('neotest').output_panel.toggle()<cr>",       { desc = "Output" })

-- ── Harpoon ──────────────────────────────────────
map("n", "<leader>Ha", function() require("harpoon"):list():add() end,                           { desc = "Add File" })
map("n", "<leader>H",  function() local h = require("harpoon"); h.ui:toggle_quick_menu(h:list()) end, { desc = "Harpoon Menu" })
map("n", "<leader>H1", function() require("harpoon"):list():select(1) end,                       { desc = "File 1" })
map("n", "<leader>H2", function() require("harpoon"):list():select(2) end,                       { desc = "File 2" })
map("n", "<leader>H3", function() require("harpoon"):list():select(3) end,                       { desc = "File 3" })
map("n", "<leader>H4", function() require("harpoon"):list():select(4) end,                       { desc = "File 4" })
map("n", "<leader>Hn", function() require("harpoon"):list():next() end,                          { desc = "Next Harpoon" })
map("n", "<leader>Hp", function() require("harpoon"):list():prev() end,                          { desc = "Prev Harpoon" })

-- ── Undotree ──────────────────────────────────────
map("n", "<leader>u",  "<cmd>UndotreeToggle<cr>", { desc = "Undo Tree" })

-- ── Sessions / Persistence ────────────────────────
map("n", "<leader>Ss", function() require("persistence").save() end,              { desc = "Save Session" })
map("n", "<leader>Sr", function() require("persistence").load() end,              { desc = "Restore Session (cwd)" })
map("n", "<leader>Sl", function() require("persistence").load({ last = true }) end, { desc = "Load Last Session" })
map("n", "<leader>Sd", function() require("persistence").stop() end,              { desc = "Don't Save on Exit" })

-- ── UI Toggles ────────────────────────────────────
map("n", "<leader>Ui", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Inlay Hints" })

map("n", "<leader>Uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Format on save: " .. (vim.g.autoformat and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "Format on Save" })

map("n", "<leader>Ub", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Git Blame" })

map("n", "<leader>Uw", function()
  vim.o.wrap = not vim.o.wrap
  vim.notify("Word wrap: " .. (vim.o.wrap and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "Word Wrap" })

map("n", "<leader>Un", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Relative Numbers" })

map("n", "<leader>Uc", function()
  vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
end, { desc = "Conceal Level" })

-- ── LSP ──────────────────────────────────────────
map("n", "gd",         vim.lsp.buf.definition,      { desc = "Go to Definition" })
map("n", "gD",         vim.lsp.buf.declaration,      { desc = "Declaration" })
map("n", "gi",         vim.lsp.buf.implementation,   { desc = "Implementation" })
map("n", "gy",         vim.lsp.buf.type_definition,  { desc = "Type Definition" })
map("n", "gr",         vim.lsp.buf.references,       { desc = "References" })
map("n", "K",          vim.lsp.buf.hover,            { desc = "Hover Docs" })
map("i", "<C-s>",      vim.lsp.buf.signature_help,   { desc = "Signature Help" })
map("n", "<leader>ca", vim.lsp.buf.code_action,      { desc = "Code Action" })
map("n", "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = "Format File" })
map("n", "<leader>ls", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
map("n", "[d",         vim.diagnostic.goto_prev,     { desc = "Prev Diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,     { desc = "Next Diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float,    { desc = "Line Diagnostics" })

-- Inc-rename (live preview en cmdline)
map("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename" })
