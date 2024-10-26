return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    'ThePrimeagen/vim-be-good',
    cmd = "VimBeGood",
    config = function()
    end
  },
  {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- Your Harpoon configuration here
  end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
  },
  {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      config = function()
        require "configs.lspconfig"
        
        -- Setup mason
        require("mason").setup()
        
        -- Configure SVLS
        require("lspconfig").svls.setup({
          cmd = { "svls" },
          filetypes = { "verilog", "systemverilog" },
          root_dir = function(fname)
            return vim.loop.cwd()
          end,
        })
      end,
    },
    {
      "vhda/verilog_systemverilog.vim",
      ft = { "verilog", "systemverilog" },
      event = { "BufRead", "BufNewFile" },
      config = function()
        -- Verilog plugin specific settings
        vim.g.verilog_syntax_fold_lst = "function,task"
        vim.g.verilog_disable_indent_lst = "eos"
        
        -- Set up file type detection
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
          pattern = { "*.v", "*.sv", "*.vh", "*.svh" },
          callback = function()
            vim.bo.filetype = "verilog_systemverilog"
          end,
        })
      end,
    },
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
