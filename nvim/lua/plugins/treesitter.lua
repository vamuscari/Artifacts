return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      local configs = require "nvim-treesitter.configs"

      ---@diagnostic disable-next-line: missing-fields
      configs.setup {
        highlight = { enable = true },
        --indent = { enable = true },
        ensure_installed = {
          -- General Languages
          "c",
          "zig",
          "perl",

          -- Mobile
          "dart",
          "swift",

          -- Web
          "html",
          "css",
          "scss",
          "javascript",
          "jsdoc",
          "jsonc",
          "markdown",
          "markdown_inline",
          "tsx",
          "typescript",
          "terraform",
          "angular",

          -- Data Science
          "python",
          "julia",
          "r",

          -- DB / Data
          "json",
          "sql",
          "query",
          "xml",
          "yaml",
          "toml",

          -- System
          "regex",
          "diff",
          "bash",
          "lua",
          "luadoc",
          "luap",
          "vim",
          "vimdoc",
          "ssh_config",
          "tmux",
        },
        -- List of parsers to ignore installing (or "all")
        ignore_install = {
          "csv", -- Conflics with rainbow csv. Also, its highlighting is terrible
          "tsv",
        },
        sync_install = false,
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
          },
          lsp_interop = {
            enable = true,
            peek_definition_code = {
              ["<leader>ck"] = "@function.outer",
              ["<leader>cK"] = "@class.outer",
            },
          },
        },
        auto_install = true,
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    enabled = true,
    config = function()
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require "nvim-treesitter.textobjects.move" ---@type table<string,fun(...)>
      local configs = require "nvim-treesitter.configs"
      for name, fn in pairs(move) do
        if name:find "goto" == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find "[%]%[][cC]" then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
}
