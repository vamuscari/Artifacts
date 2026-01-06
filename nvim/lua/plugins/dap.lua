return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",

      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim", -- Automatic DAP adapter installation
      "Jorenar/nvim-dap-disasm", -- Disassembly view
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"
      local disasm = require "dap-disasm"

      -- Setup mason-nvim-dap for automatic adapter installation
      require("mason-nvim-dap").setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          "codelldb", -- For Swift/C/C++/Rust debugging
        },
      }

      require("dapui").setup {
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
          {
            elements = { { id = "disassembly", size = 1 } },
            position = "right",
            size = 100,
          },
        },
      }
      require("dap-go").setup()
      require("dap-python").setup "python"
      require("dap-disasm").setup {
        dapui_register = true,
        winbar = false,
      }
      --require("dap-python").setup "$MASON/packages/debugpy/venv/bin/python"

      -- Configure codelldb adapter for Swift/C/C++
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- Swift debugging configuration
      dap.configurations.swift = {
        {
          name = "Launch Swift",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- C/C++ compile and debug helpers
      local function get_executable_path()
        local file = vim.fn.expand "%:p"
        local name = vim.fn.expand "%:t:r"
        local dir = vim.fn.expand "%:p:h"
        return dir .. "/" .. name
      end

      local function compile_cpp()
        local file = vim.fn.expand "%:p"
        local output = get_executable_path()
        local ext = vim.fn.expand "%:e"
        local compiler = ext == "c" and "clang" or "clang++"
        local cmd = string.format("%s -g -o %s %s", compiler, output, file)
        vim.notify("Compiling: " .. cmd, vim.log.levels.INFO)
        vim.fn.jobstart(cmd, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify("Compiled successfully: " .. output, vim.log.levels.INFO)
            else
              vim.notify("Compilation failed", vim.log.levels.ERROR)
            end
          end,
          on_stderr = function(_, data)
            if data and #data > 1 then
              vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
            end
          end,
        })
      end

      -- C/C++ debugging configuration
      dap.configurations.cpp = {
        {
          name = "Launch C++",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", get_executable_path(), "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Compile keymaps (only for C/C++ files)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
          vim.keymap.set("n", "<leader>rm", compile_cpp, { buffer = true, desc = "compile C/C++" })
        end,
      })

      require("nvim-dap-virtual-text").setup {
        -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
            return "*****"
          end

          if #variable.value > 15 then
            return " " .. string.sub(variable.value, 1, 15) .. "... "
          end

          return " " .. variable.value
        end,
      }

      vim.keymap.set("n", "<leader>rb", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
      vim.keymap.set("n", "<leader>rc", dap.run_to_cursor, { desc = "run to cursor" })
      vim.keymap.set("n", "<leader>ru", ui.toggle, { desc = "toggle DAP UI" })
      vim.keymap.set("n", "<leader>ro", dap.repl.open, { desc = "open REPL" })
      vim.keymap.set("n", "<leader>ra", function()
        vim.cmd "DapDisasm"
      end, { desc = "toggle disassembly" })

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<leader>rl", dap.continue, { desc = "continue" })
      vim.keymap.set("n", "<leader>rj", dap.step_into, { desc = "step into" })
      vim.keymap.set("n", "<leader>rn", dap.step_over, { desc = "step over" })
      vim.keymap.set("n", "<leader>rk", dap.step_out, { desc = "step out" })
      vim.keymap.set("n", "<leader>rh", dap.step_back, { desc = "step back" })
      vim.keymap.set("n", "<leader>rs", function()
        if dap.session() then
          dap.restart()
        else
          local configs = dap.configurations[vim.bo.filetype]
          if not configs or #configs == 0 then
            vim.notify("No DAP configuration for filetype: " .. vim.bo.filetype, vim.log.levels.ERROR)
            return
          end
          if #configs == 1 then
            dap.run(configs[1])
          else
            vim.ui.select(configs, {
              prompt = "Select configuration:",
              format_item = function(config)
                return config.name
              end,
            }, function(config)
              if config then
                dap.run(config)
              end
            end)
          end
        end
      end, { desc = "start/restart" })

      -- vim.keymap.set("n", "<F8>", dap.continue, { desc = "continue" })
      -- vim.keymap.set("n", "<F9>", dap.step_into, { desc = "step into" })
      -- vim.keymap.set("n", "<F10>", dap.step_over, { desc = "step over" })
      -- vim.keymap.set("n", "<F7>", dap.step_out, { desc = "step out" })
      -- vim.keymap.set("n", "<F6>", dap.step_back, { desc = "step back" })
      -- vim.keymap.set("n", "<F12>", dap.restart, { desc = "restart" })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
