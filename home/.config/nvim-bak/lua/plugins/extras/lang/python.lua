-- LSP configuration setup
local setup_lsp = function()
  -- local config = require("plugins.configs.lspconfig")
  -- local on_attach = config.on_attach
  -- local capabilities = config.capabilities
  local lspconfig = require("lspconfig")

  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
          disable = { "different-requires" },
        },
      },
    },
  })

  lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
  })

  local servers = { "pyright", "ruff_lsp" }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
      -- on_attach = on_attach,
      -- capabilities = capabilities,
      filetypes = { "python" },
    })
  end
end

-- null-ls (none-ls) configuration
local setup_null_ls = function()
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  local null_ls = require("null-ls")

  local opts = {
    sources = {
      null_ls.builtins.formatting.black,
      null_ls.builtins.diagnostics.mypy.with({
        extra_args = function()
          local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
          return { "--python-executable", virtual .. "/bin/python3" }
        end,
      }),
    },
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({
          group = augroup,
          buffer = bufnr,
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
  }
  return opts
end

-- Plugin configuration
return {
  {
    "nvim-neotest/nvim-nio",
  },
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   dependencies = "mfussenegger/nvim-dap",
  --   config = function()
  --     local dap = require("dap")
  --     local dapui = require("dapui")
  --     dapui.setup()
  --     dap.listeners.after.event_initialized["dapui_config"] = function()
  --       dapui.open()
  --     end
  --     dap.listeners.before.event_terminated["dapui_config"] = function()
  --       dapui.close()
  --     end
  --     dap.listeners.before.event_exited["dapui_config"] = function()
  --       dapui.close()
  --     end
  --   end,
  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   -- config = function(_, opts)
  --   --   require("core.utils").load_mappings("dap")
  --   -- end,
  -- },
  -- {
  --   "mfussenegger/nvim-dap-python",
  --   ft = "python",
  --   dependencies = {
  --     "mfussenegger/nvim-dap",
  --     "rcarriga/nvim-dap-ui",
  --     "nvim-neotest/nvim-nio",
  --   },
  --   config = function(_, opts)
  --     local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
  --     require("dap-python").setup(path)
  --     -- require("core.utils").load_mappings("dap_python")
  --   end,
  -- },
  {
    "nvimtools/none-ls.nvim",
    ft = { "python" },
    opts = setup_null_ls,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "debugpy",
        "mypy",
        "ruff-lsp",
        "pyright",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = setup_lsp,
  },
}
