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
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      require("dapui").setup()
      require("dap-go").setup()
      require("dap-python").setup "python"
      --require("dap-python").setup "$MASON/packages/debugpy/venv/bin/python"

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

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F8>", dap.continue, { desc = "continue" })
      vim.keymap.set("n", "<F9>", dap.step_into, { desc = "step into" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "step over" })
      vim.keymap.set("n", "<F7>", dap.step_out, { desc = "step out" })
      vim.keymap.set("n", "<F6>", dap.step_back, { desc = "step back" })
      vim.keymap.set("n", "<F12>", dap.restart, { desc = "restart" })

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
