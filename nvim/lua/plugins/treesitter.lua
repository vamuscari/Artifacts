return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      -- Install parsers using vim.treesitter.language.add
      local parsers = {
        -- General Languages
        "c",
        "zig",
        "perl",
        "go",
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
      }

      -- Auto-install parsers
      for _, parser in ipairs(parsers) do
        vim.cmd("TSInstall " .. parser)
      end

      -- Enable highlighting using native API (only if parser exists)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype

          -- Skip special buffers and filetypes without parsers
          if ft == "" or vim.bo[buf].buftype ~= "" then
            return
          end

          -- Try to start treesitter, but don't error if parser doesn't exist
          local ok = pcall(vim.treesitter.start, buf)
          if not ok then
            return
          end
        end,
      })

      -- Enable indentation (experimental, only if treesitter is active)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype

          -- Skip special buffers
          if ft == "" or vim.bo[buf].buftype ~= "" then
            return
          end

          -- Only set indentexpr if treesitter is available for this filetype
          if pcall(vim.treesitter.start, buf) then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Incremental selection keymaps
      vim.keymap.set("n", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").init_selection()
      end, { desc = "Init Selection" })
      vim.keymap.set("x", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").node_incremental()
      end, { desc = "Increment Selection" })
      vim.keymap.set("x", "<bs>", function()
        require("nvim-treesitter.incremental_selection").node_decremental()
      end, { desc = "Decrement Selection" })

      -- Custom textobject navigation using native treesitter API
      local function get_node_at_cursor()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row, col = cursor[1] - 1, cursor[2]
        return vim.treesitter.get_node { pos = { row, col } }
      end

      local function find_parent_of_type(node, types)
        if not node then
          return nil
        end
        local current = node
        while current do
          if vim.tbl_contains(types, current:type()) then
            return current
          end
          current = current:parent()
        end
        return nil
      end

      local function find_next_node(types, forward)
        local node = get_node_at_cursor()
        if not node then
          return nil
        end

        local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
        local bufnr = vim.api.nvim_get_current_buf()

        -- Get root node
        local parser = vim.treesitter.get_parser(bufnr)
        if not parser then
          return nil
        end

        local trees = parser:parse()
        if not trees or #trees == 0 then
          return nil
        end

        local root = trees[1]:root()

        -- Find all matching nodes
        local matches = {}
        local function traverse(n)
          if vim.tbl_contains(types, n:type()) then
            local start_row = n:start()
            table.insert(matches, { node = n, row = start_row })
          end
          for child in n:iter_children() do
            traverse(child)
          end
        end

        traverse(root)

        -- Sort by row
        table.sort(matches, function(a, b)
          return a.row < b.row
        end)

        -- Find next/previous
        if forward then
          for _, match in ipairs(matches) do
            if match.row > cursor_row then
              return match.node
            end
          end
        else
          for i = #matches, 1, -1 do
            if matches[i].row < cursor_row then
              return matches[i].node
            end
          end
        end

        return nil
      end

      local function goto_node(node, to_end)
        if not node then
          vim.notify("No node found", vim.log.levels.WARN)
          return
        end

        local start_row, start_col, end_row, end_col = node:range()
        if to_end then
          vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
        else
          vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
        end
      end

      -- Function navigation
      local function_types = {
        "function_declaration",
        "function_definition",
        "method_declaration",
        "method_definition",
        "function_item", -- Rust
        "function", -- Generic
        "arrow_function",
        "function_expression",
      }

      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        local node = find_next_node(function_types, true)
        goto_node(node, false)
      end, { desc = "Next function start" })

      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        local node = find_next_node(function_types, false)
        goto_node(node, false)
      end, { desc = "Previous function start" })

      vim.keymap.set({ "n", "x", "o" }, "]F", function()
        local node = find_next_node(function_types, true)
        goto_node(node, true)
      end, { desc = "Next function end" })

      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        local node = find_next_node(function_types, false)
        goto_node(node, true)
      end, { desc = "Previous function end" })

      -- Class navigation
      local class_types = {
        "class_declaration",
        "class_definition",
        "struct_item", -- Rust
        "enum_declaration",
        "interface_declaration",
        "type_declaration",
      }

      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        local node = find_next_node(class_types, true)
        goto_node(node, false)
      end, { desc = "Next class start" })

      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        local node = find_next_node(class_types, false)
        goto_node(node, false)
      end, { desc = "Previous class start" })

      vim.keymap.set({ "n", "x", "o" }, "]C", function()
        local node = find_next_node(class_types, true)
        goto_node(node, true)
      end, { desc = "Next class end" })

      vim.keymap.set({ "n", "x", "o" }, "[C", function()
        local node = find_next_node(class_types, false)
        goto_node(node, true)
      end, { desc = "Previous class end" })

      -- Peek definition using floating window
      local function peek_definition(types)
        local node = get_node_at_cursor()
        if not node then
          vim.notify("No node at cursor", vim.log.levels.WARN)
          return
        end

        local target = find_parent_of_type(node, types)
        if not target then
          vim.notify("No " .. table.concat(types, "/") .. " found", vim.log.levels.WARN)
          return
        end

        local start_row, start_col, end_row, end_col = target:range()
        local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

        -- Create floating window
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].filetype = vim.bo.filetype

        local width = math.min(vim.o.columns - 4, 80)
        local height = math.min(#lines, 20)

        local opts = {
          relative = "cursor",
          width = width,
          height = height,
          row = 1,
          col = 0,
          style = "minimal",
          border = "rounded",
        }

        vim.api.nvim_open_win(buf, false, opts)
      end

      vim.keymap.set("n", "<leader>ck", function()
        peek_definition(function_types)
      end, { desc = "Peek function definition" })

      vim.keymap.set("n", "<leader>cK", function()
        peek_definition(class_types)
      end, { desc = "Peek class definition" })
    end,
  },
  -- NOTE: nvim-treesitter-textobjects is currently incompatible with nvim-treesitter main branch
  -- The plugin requires the deprecated nvim-treesitter.configs module
  -- Textobject functionality can be implemented using native treesitter queries when needed
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   enabled = false,
  -- },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
}
