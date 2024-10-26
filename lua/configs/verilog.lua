-- ~/.config/nvim/lua/configs/verilog.lua
local M = {}

M.setup = function()
  -- Set up Verilog-specific keymaps
  local function set_verilog_keymaps()
    local opts = { noremap = true, silent = true }
    
    -- Compilation and simulation
    vim.keymap.set("n", "<leader>lc", ":!iverilog -o sim %<CR>", { desc = "Compile Verilog", buffer = true })
    vim.keymap.set("n", "<leader>lr", ":!./sim<CR>", { desc = "Run simulation", buffer = true })
    vim.keymap.set("n", "<leader>lw", ":!gtkwave *.vcd<CR>", { desc = "Open waveform", buffer = true })
    
    -- LSP specific mappings for Verilog files
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = true })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover info", buffer = true })
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.formatting, { desc = "Format Verilog", buffer = true })
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show diagnostics", buffer = true })
  end

  -- Set up autocommands for Verilog files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "verilog", "systemverilog" },
    callback = function()
      -- Set indentation
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
      
      -- Set Verilog-specific keymaps
      set_verilog_keymaps()
    end,
  })
end

return M
