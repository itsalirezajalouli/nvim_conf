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
-- Zen mode plugin
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = {
      dimming = {
        alpha = 0.25, -- amount of dimming
        color = { "Normal", "#ffffff" },
        inactive = true, -- dim inactive windows
      },
      context = 10, -- amount of lines we will try to show around the current line
      treesitter = true, -- use treesitter when available for dimming
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
    },
    config = function(_, opts)
      require("twilight").setup(opts)
      -- Optional: Add keymapping
      vim.keymap.set("n", "<leader>tz", ":Twilight<CR>", { desc = "Toggle Twilight Zen Mode" })
    end
  },
  -- Alternatively, you can use the full Zen Mode plugin
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen mode window
        width = 90, -- width of the Zen mode window
        height = 1, -- height of the Zen mode window
        options = {
          signcolumn = "no", -- disable signcolumn
          number = true, -- disable number column
          relativenumber = true, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- disable some global vim options (vim.o...)
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = { enabled = false, font = "+2" },
      },
    },
    config = function(_, opts)
      require("zen-mode").setup(opts)
      vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode" })
    end
  }
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
