return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "meuter/lualine-so-fancy.nvim",
      "nvim-mini/mini.icons",
    },
    opts = {
      options = {
        theme = "auto",
        section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
        globalstatus = true,
        refresh = {
          statusline = 100,
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
      sections = {
        lualine_a = {
          { "mode" },
        },
        lualine_b = {
          { "fancy_branch" },
          { "fancy_diff" },
        },
        lualine_c = {
          { "fancy_cwd", substitute_home = true },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename" },
          { "fancy_diagnostics" },
          {
            function()
              return " "
            end,
            color = function()
              local status = require("sidekick.status").get()
              if status then
                return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
              end
            end,
            cond = function()
              local status = require("sidekick.status")
              return status.get() ~= nil
            end,
          },
        },
        lualine_x = {
          { "fancy_macro" },
          {
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = function()
              return { fg = Snacks.util.color("Debug") }
            end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = Snacks.util.color("Special") }
            end,
          },
        },
        lualine_y = {
          { "fancy_searchcount" },
          { "fancy_location" },
        },
        lualine_z = {
          { "fancy_lsp_servers" },
        },
      },
    },
  },
  {
    "vimpostor/vim-tpipeline",
    dependencies = "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_restore = 0

      -- local function get_tmux_option(opt)
      --   local output = vim.fn.system("tmux show -g " .. opt)
      --   local value = output:match('"(.*)"') or output:gsub(opt .. " ", ""):gsub("\n", "")
      --   return vim.trim(value)
      -- end
      --
      -- local tmux_left = get_tmux_option("status-left")
      -- local tmux_right = get_tmux_option("status-right")
      -- vim.api.nvim_create_autocmd("VimLeavePre", {
      --   callback = function()
      --     if vim.fn.exists("$TMUX") == 1 and vim.fn.getenv("TMUX") ~= "" then
      --       vim.fn.system("tmux set -w status-left " .. vim.fn.shellescape(tmux_left))
      --       vim.fn.system("tmux set -w status-right " .. vim.fn.shellescape(tmux_right))
      --       vim.fn.system("tmux refresh-client -S")
      --     end
      --   end,
      -- })
      -- vim.api.nvim_create_autocmd("VimLeave", {
      --   callback = function()
      --     vim.fn.system("tmux set status on")
      --   end,
      -- })
    end,
  },
}
