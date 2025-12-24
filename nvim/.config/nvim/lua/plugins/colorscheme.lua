---@diagnostic disable: missing-fields

local colorUtil = require("utils.color")

local use_lazyvim = true -- 设置为 false 使用旧格式

local colorscheme_for_lazyvim = {
  {
    "folke/tokyonight.nvim",
    lazy = true,
  },

  {
    "sainnhe/everforest",
    lazy = true,
  },

  {
    "sainnhe/gruvbox-material",
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true, -- disables setting the background color.
        float = {
          transparent = true, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = false,
          },
        },
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            -- Comment = { fg = colors.flamingo },
            -- TabLineSel = { bg = colors.pink },
            -- CmpBorder = { fg = colors.surface2 },
            Pmenu = { bg = colors.none },
            BlinkCmpMenuBorder = { bg = colors.none },
            DropBarMenuHoverIcon = { bg = colors.none, fg = colors.flamingo, reverse = false },
          }
        end,
        default_integrations = true,
        auto_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          notify = true,
          dropbar = {
            enabled = true,
            color_mode = false, -- enable color for kind's texts, not just kind's icons
          },
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })

      -- setup must be called before loading
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "nicholasxjy/bamboo.nvim",
    lazy = true,
    branch = "dev",
    config = function()
      local float_border_color = "#3B38A0"
      local float_title_fg = "#D92C54"
      local match_fg = "#e55285"
      local bg0 = "#222436"
      local normal_bg = vim.g.transparent and "none" or bg0
      local dim_bg = vim.g.transparent and normal_bg or colorUtil.darken("#161c2d", 0.25)
      local float_border_fg = vim.g.transparent and float_border_color or normal_bg
      require("bamboo").setup({
        style = "multiplex", -- choose between 'vulgaris' (regular), 'yorumi', 'multiplex' (greener), and 'light'
        toggle_style_key = nil,
        transparent = vim.g.transparent,
        dim_inactive = false,
        term_colors = true,
        ending_tildes = true,
        cmp_itemkind_reverse = false,
        code_style = {
          comments = { italic = true },
          conditionals = { italic = true, bold = false },
          keywords = { italic = false, bold = false },
          functions = {},
          namespaces = { italic = false },
          parameters = { italic = true },
          strings = {},
          variables = {},
        },
        lualine = {
          transparent = true,
        },
        highlights = {
          CursorLine = { bg = "#2f447f" },
          FloatTitle = { fg = float_title_fg, fmt = "bold" },
          NormalFloat = { bg = dim_bg, fg = "$fg" },
          FloatBorder = { bg = dim_bg, fg = float_border_fg },
          PmenuSel = { bg = "#2f2a7a", fg = "NONE", fmt = "italic" }, --"#2f447f" -- "#503240"
          Slimline = { bg = "NONE", fg = "$fg" },
          StatusLine = { bg = "NONE" },
          SnacksPickerBorder = { fg = float_border_fg, bg = normal_bg },
          SnacksPickerList = { bg = normal_bg },
          SnacksPickerTitle = { link = "FloatTitle" },
          SnacksPickerPreview = { bg = normal_bg },
          SnacksPickerPreviewTitle = { fg = "$cyan", fmt = "bold" },
          SnacksPickerInput = { bg = normal_bg, fg = "$fg" },
          SnacksPickerMatch = { fg = match_fg, fmt = "bold" },
          SnacksPickerCursorLine = { link = "PmenuSel" },
          SnacksPickerListCursorLine = { link = "PmenuSel" },
          SnacksPickerDir = { fg = "$grey", fmt = "italic" },
          FzfLuaTitle = { link = "FloatTitle" },
          FzfLuaPreviewTitle = { link = "SnauusPickerPreviewTitle" },
          FzfLuaCursorLine = { link = "PmenuSel" },
          BlinkCmpLabelMatch = { fg = match_fg, fmt = "bold" },
          LspInlayHint = { fg = "$grey", fmt = "italic" },
          DropBarMenuNormalFloat = { bg = "NONE" },
          DropBarMenuHoverEntry = { link = "PmenuSel" },
          DropBarMenuHoverIcon = { bg = "NONE", fg = "$fg" },
          TabLineFill = { bg = "NONE", fg = "$fg" },
          NvimDapVirtualText = { fg = "#6b7089" },
        },
        diagnostics = {
          darker = false,
          undercurl = true,
          background = true,
        },
      })
    end,
  },
}

local colorscheme = "everforest"
local schemes = {
  tokyonight = {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        ---@diagnostic disable-next-line: missing-fields
        style = "night", -- "storm", "moon", "night", "day"
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  everforest = {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.cmd.colorscheme("everforest")
    end,
  },

  ["gruvbox-material"] = {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  kanagawa = {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        background = {
          dark = "wave", -- "wave", "dragon", "lotus"
          light = "lotus",
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}

if use_lazyvim then
  return colorscheme_for_lazyvim
else
  return { schemes[colorscheme] }
end
