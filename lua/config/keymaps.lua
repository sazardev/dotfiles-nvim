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
map("n", "<S-h>",      "<cmd>bprev<cr>",         { desc = "Prev Buffer" })
map("n", "<S-l>",      "<cmd>bnext<cr>",         { desc = "Next Buffer" })
map("n", "<leader>x",  "<cmd>bd<cr>",            { desc = "Close Buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>",   { desc = "Close Others" })

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
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File Explorer" })

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
map("n", "<leader>gr", "<cmd>GoRun<cr>",      { desc = "Go Run" })
map("n", "<leader>gt", "<cmd>GoTest<cr>",     { desc = "Go Test" })
map("n", "<leader>gT", "<cmd>GoTestFunc<cr>", { desc = "Go Test Func" })
map("n", "<leader>gi", "<cmd>GoImports<cr>",  { desc = "Go Imports" })
map("n", "<leader>ga", "<cmd>GoAddTag<cr>",   { desc = "Go Add Tags" })
map("n", "<leader>ge", "<cmd>GoIfErr<cr>",    { desc = "Go If Err" })

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

-- ── LSP ──────────────────────────────────────────
map("n", "gd",         vim.lsp.buf.definition,     { desc = "Go to Definition" })
map("n", "gr",         vim.lsp.buf.references,     { desc = "References" })
map("n", "K",          vim.lsp.buf.hover,          { desc = "Hover Docs" })
map("n", "<leader>rn", vim.lsp.buf.rename,         { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action,    { desc = "Code Action" })
map("n", "[d",         vim.diagnostic.goto_prev,   { desc = "Prev Diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,   { desc = "Next Diagnostic" })
