return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        indent = {
          enabled = true,
          -- only_current = true,
          -- only_scope = true,
          -- char = "⋮",
          char = "",
          -- char = "⁘",
          hl = {
            "RainbowDelimiterViolet",
            "RainbowDelimiterOrange",
            "RainbowDelimiterYellow",
            "RainbowDelimiterGreen",
            "RainbowDelimiterCyan",
            "RainbowDelimiterBlue",
            "RainbowDelimiterRed",
          },
        },
        scope = {
          enabled = true,
          -- char = "⁚",
          char = "│",
          -- char = "║",
          underline = false,
          only_current = true,
          hl = "RainbowDelimiterRed", ---@type string|string[] hl group for scopes
        },
        chunk = {
          -- when enabled, scopes will be rendered as chunks, except for the
          -- top-level scope which will be rendered as a scope.
          enabled = true,
          -- only show chunk scopes in the current window
          only_current = true,
          hl = "RainbowDelimiterRed", ---@type string|string[] hl group for chunk scopes
          char = {
            -- corner_top = "┌",
            -- corner_bottom = "└",
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = "─",
          },
        },
      },
      dashboard = {
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = "󰙏", key = "l", desc = "LeetCode", action = ":Leet" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          -- Used by the `header` section
          header = [[         
                             █████                                          
                            ▒▒███                                           
 ████████   ██████   █████  ███████   ████████   ██████  ████████    ██████ 
▒▒███▒▒███ ███▒▒███ ███▒▒  ▒▒▒███▒   ▒▒███▒▒███ ███▒▒███▒▒███▒▒███  ███▒▒███
 ▒███ ▒███▒███ ▒███▒▒█████   ▒███     ▒███ ▒███▒███ ▒███ ▒███ ▒███ ▒███████ 
 ▒███ ▒███▒███ ▒███ ▒▒▒▒███  ▒███ ███ ▒███ ▒███▒███ ▒███ ▒███ ▒███ ▒███▒▒▒  
 ▒███████ ▒▒██████  ██████   ▒▒█████  ▒███████ ▒▒██████  ████ █████▒▒██████ 
 ▒███▒▒▒   ▒▒▒▒▒▒  ▒▒▒▒▒▒     ▒▒▒▒▒   ▒███▒▒▒   ▒▒▒▒▒▒  ▒▒▒▒ ▒▒▒▒▒  ▒▒▒▒▒▒  
 ▒███                                 ▒███                                  
 █████                                █████                                 
▒▒▒▒▒                                ▒▒▒▒▒                                  ]],
        },
        -- item field formatters
        sections = {
          {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
        },
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    main = "rainbow-delimiters.setup",
  },
  {
    "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    opts = {
      -- char = "|",
      -- char = "",
      -- char = "┇",
      -- char = "∶",
      -- char = "∷",
      -- char = "║",
      char = "⋮",
      -- char = "",
      -- char = "󰮾",
      virtcolumn = "120",
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },
  {
    "tummetott/reticle.nvim",
    event = "VeryLazy",
    cmd = {
      "ReticleToggleCursorline",
      "ReticleToggleCursorcolumn",
      "ReticleToggleCursorcross",
    },
    opts = {
      on_startup = {
        cursorline = true,
        cursorcolumn = false,
      },

      disable_in_insert = true,
      disable_in_diff = true,
      always_highlight_number = true,
      -- Define filetypes which are ignored by the plugin
      ignore = {
        cursorline = {
          "DressingInput",
          "FTerm",
          "NvimSeparator",
          "NvimTree",
          "TelescopePrompt",
          "Trouble",
          "snacks_picker_input",
          "snacks_terminal",
          "snacks_dashboard",
        },
        cursorcolumn = {
          "snacks_picker_input",
          "snacks_picker_list",
          "snacks_terminal",
          "snacks_dashboard",
          "mason",
          "lazy",
          "fzf",
        },
      },

      -- Specify filetypes where the cursorline and/or cursorcolumn should be
      -- explicitly disabled. Typically, you would include these filetypes in
      -- the 'ignored' table. However, there are situations where plugins enable
      -- cursorline/cursorcolumn without offering a configuration option for
      -- disabling them. By adding these filetypes to the 'never' table, you
      -- can override the plugin's settings and turn off these features.
      never = {
        cursorline = {},
        cursorcolumn = {},
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    cond = vim.g.neovide == nil,
    opts = { -- Default  Range
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      stiffness_insert_mode = 0.7,
      trailing_stiffness_insert_mode = 0.7,
      damping = 0.95,
      damping_insert_mode = 0.95,
      distance_stop_animating = 0.5,
    },
    specs = {
      -- disable mini.animate cursor
      {
        "nvim-mini/mini.animate",
        optional = true,
        opts = {
          cursor = { enable = false },
        },
      },
    },
  },
}
