vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Set up line numbers
vim.opt.number = true            -- Show absolute line numbers
vim.opt.relativenumber = true    -- Show selative line numbers

-- Set up sign column (left margin)
vim.opt.signcolumn = 'yes'       -- Always show the sign column, can be 'auto' if you prefer

-- Show a color column to visually indicate the right margin
vim.opt.colorcolumn = '90'  -- Adjust according to your text width

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  -- Add MATLAB/Octave support plugins
  {
    "vim-scripts/matlab.vim",
    ft = { "matlab", "octave" },
  },

  { import = "plugins" },

}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Custom keybindings using vim.keymap.set
local function set_keymaps()
  -- [Your existing keymaps]
  -- Move lines in normal mode
  vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
  vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

  -- Move lines in visual mode
  vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
  vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

  -- Scroll and center
  vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
  vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

  -- Scroll to end and center
  vim.keymap.set("n", "G", "Gzz", { desc = "Go to end and center" })

  -- Open a terminal in a split
  vim.keymap.set("n", "<leader>tt", ":split | terminal<CR>", { desc = "Open terminal in split" })

  -- Close the current split
  vim.keymap.set("n", "<leader>tc", ":close<CR>", { desc = "Close current split" })

  -- Toggle spell checking
  vim.keymap.set("n", "<leader>ts", ":setlocal spell!<CR>", { desc = "Toggle spell checking" })

  -- Bind <leader>fs to search from the root directory using Telescope
  vim.api.nvim_set_keymap('n', '<leader>fs', ":Telescope find_files cwd=/ <CR>", { noremap = true, silent = true })

  -- Bind <leader>pd to python documentation
  vim.api.nvim_set_keymap('n', '<leader>pd', ":!pydoc ", { noremap = true, silent = false})

  -- Bind <leader>rt to python documentation
  vim.api.nvim_set_keymap('n', '<leader>rt', ":!rustup doc ", { noremap = true, silent = false})

  -- Show diagnostics in a floating window with Shift + E
  vim.api.nvim_set_keymap('n', 'E', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

  -- Map new increment/decrement keys
  vim.keymap.set('n', '<C-q>', '<C-a>', { noremap = true, desc = "Increment number" })

  -- Harpoon
  vim.api.nvim_set_keymap('n', '<leader>hh', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ha', ':lua require("harpoon.mark").add_file()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>5', ':lua require("harpoon.ui").nav_file(5)<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>6', ':lua require("harpoon.ui").nav_file(6)<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>7', ':lua require("harpoon.ui").nav_file(7)<CR>', { noremap = true, silent = true })

  -- MATLAB/Octave specific keymaps
  vim.keymap.set("n", "<leader>mr", ":write | !octave %<CR>", { desc = "Run current file in Octave" })
  vim.keymap.set("n", "<leader>ml", ":.w !octave<CR>", { desc = "Send line to Octave" })
  vim.keymap.set("v", "<leader>ms", ":w !octave<CR>", { desc = "Send selection to Octave" })
  vim.keymap.set("n", "<leader>mc", "0i%% <ESC>", { desc = "Comment line in MATLAB" })
  vim.keymap.set("n", "<leader>md", ":!octave --eval \"help <cword>\"<CR>", { desc = "Show Octave documentation" })
  -- Zen Mode
  vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode" })
end

-- Move text left and right
vim.api.nvim_set_keymap('n', '<C-h>', '<<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '>>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-h>', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-l>', '>gv', { noremap = true, silent = true })

-- MATLAB/Octave specific settings
local function setup_matlab()
  local matlab_group = vim.api.nvim_create_augroup("MatlabConfig", { clear = true })
  
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = matlab_group,
    pattern = { "*.m", "*.mat" },
    callback = function()
      vim.opt_local.filetype = "matlab"
      vim.opt_local.commentstring = "%% %s"
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_us"
    end,
  })
end

vim.filetype.add({
    extension = {
        ipynb = "ipynb",
    },
})

vim.g.snacks_animate = false

-- Call the setup functions
setup_matlab()
set_keymaps()

