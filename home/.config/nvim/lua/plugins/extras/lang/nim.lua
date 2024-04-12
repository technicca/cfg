return {
  -- FIXME: Using latest version of nim-langserver
  -- included from nim itself
  -- {
  --   "neovim/nvim-lspconfig",
  --   ft = { "nim" },
  --   opts = function(_, opts)
  --     opts.servers = {
  --       nim_langserver = {},
  --     }
  --   end,
  -- },
  {
    "alaviss/nim.nvim",
    ft = { "nim" },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations["nim"] = {
        {
          type = "codelldb",
          request = "launch",
          name = "Run Nim program",
          program = function()
            vim.cmd("!nimble build")
            local command = "fd . -t x"
            local bin_location = io.popen(command, "r")

            if bin_location ~= nil then
              return vim.fn.getcwd() .. "/" .. bin_location:read("*a"):gsub("[\n\r]", "")
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          end,
          args = function()
            if vim.g.nim_dap_argv ~= nil then
              return vim.g.nim_dap_argv
            end

            local argv = {}

            arg = vim.fn.input(string.format("Arguments: "))

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.nim_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "launch",
          name = "Run Nim program (new args)",
          program = function()
            vim.cmd("make")
            local command = "fd . -t x ."
            local bin_location = io.popen(command, "r")

            if bin_location ~= nil then
              return vim.fn.getcwd() .. "/" .. bin_location:read("*a"):gsub("[\n\r]", "")
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          end,
          args = function()
            local argv = {}

            arg = vim.fn.input(string.format("New Arguments: "))

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.nim_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["nim"] = { "nimpretty" },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local none_ls = require("none-ls")

      local nim_completion = {
        method = none_ls.methods.COMPLETION,
        filetypes = { "nim" },
        generator = {
          async = true,
          fn = function(params, done)
            vim.fn["nim#suggest#sug#GetAllCandidates"](function(start, candidates)
              local CompletionItemKind = vim.lsp.protocol.CompletionItemKind
              local kinds = {
                d = CompletionItemKind.Keyword,
                f = CompletionItemKind.Function,
                t = CompletionItemKind.Struct,
                v = CompletionItemKind.Variable,
              }
              local items = vim.tbl_map(function(candidate)
                return {
                  kind = kinds[candidate.kind] or CompletionItemKind.Text,
                  label = candidate.word,
                  documentation = candidate.info,
                }
              end, candidates)
              done({ items = items })
            end)
          end,
        },
      }

      none_ls.register(nim_completion)
    end,
  },
}
