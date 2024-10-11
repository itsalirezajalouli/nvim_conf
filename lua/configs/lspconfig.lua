-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Enhance capabilities with code action support
local capabilities = vim.deepcopy(nvlsp.capabilities)
capabilities.textDocument.codeAction = {
  dynamicRegistration = true,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = (function()
        local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
        table.sort(res)
        return res
      end)()
    }
  }
}

-- Enhanced on_attach function
local enhanced_on_attach = function(client, bufnr)
  -- Call the original NvChad on_attach
  nvlsp.on_attach(client, bufnr)

  -- Add code action specific keymaps
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  
  -- Show code actions using built-in LSP
  vim.keymap.set('n', '<leader>ca', function()
    vim.lsp.buf.code_action({
      context = {
        only = {
          "quickfix",
          "refactor",
          "source",
        },
      },
    })
  end, bufopts)
  
  -- Show code actions in visual mode
  vim.keymap.set('v', '<leader>ca', function()
    vim.lsp.buf.range_code_action({
      context = {
        only = {
          "quickfix",
          "refactor",
          "source",
        },
      },
    })
  end, bufopts)
  
  -- Use Telescope for code actions
  vim.keymap.set('n', '<leader>ta', ':Telescope lsp_code_actions<CR>', bufopts)
end

-- Configure servers
local servers = { "html", "cssls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = enhanced_on_attach,
    on_init = nvlsp.on_init,
    capabilities = capabilities,
    single_file_support = true
  }
end

-- Rust LSP setup
lspconfig.rust_analyzer.setup {
  on_attach = enhanced_on_attach,
  on_init = nvlsp.on_init,
  capabilities = capabilities,
  single_file_support = true
}

-- Python LSP setup
lspconfig.pyright.setup{
  on_attach = function(client, bufnr)
    -- Call the enhanced on_attach first
    enhanced_on_attach(client, bufnr)
    -- Your custom on_attach logic here
    print("Pyright LSP initialized for: " .. vim.fn.getcwd())
  end,
  capabilities = capabilities,
  single_file_support = true,
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace"
      }
    }
  }
}

-- Configure code action signs and UI
vim.fn.sign_define("LspDiagnosticsSignHint", {
  text = "💡",
  texthl = "LspDiagnosticsSignHint"
})

-- Configure how code actions appear
vim.lsp.handlers['textDocument/codeAction'] = vim.lsp.with(
  vim.lsp.handlers.codeAction, {
    show_source = true
  }
)
