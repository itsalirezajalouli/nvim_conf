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
      "neovim/nvim-lspconfig", dependencies = { "williamboman/mason.nvim",
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
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen mode window
        width = 94, -- width of the Zen mode window
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
      vim.keymap.set("n", "<leader>zz", ":ZenMode<CR>", { desc = "Toggle Zen Mode" })
    end
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "level", "added" },
        level = vim.log.levels.TRACE,
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
        keep = function(notif)
          return vim.fn.getcmdpos() > 0
        end,
        style = "compact",
        top_down = true,
        date_format = "%R",
        more_format = " ↓ %d lines ",
        refresh = 50,
      },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>nn",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

{
    "bfredl/nvim-ipy",
    config = function()
        vim.g.ipy_enable_autoimport = 1
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
