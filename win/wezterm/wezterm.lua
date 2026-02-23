local wezterm = require("wezterm") ---@type Wezterm

local config = wezterm.config_builder() ---@type Config

-- ===== 基础：WSL 默认启动 =====
config.default_domain = "WSL:Ubuntu-24.04" -- 你的发行版不是 Ubuntu 就改成 WSL:Debian / WSL:Arch 等
config.default_prog = { "wsl.exe", "-d", "Ubuntu-24.04" }

-- ===== 前端：更稳 =====
config.front_end = "OpenGL" -- 稳定优先；如果你想试 WebGpu，改成 "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- ===== 外观：字体/行距/边距/光标 =====
config.font = wezterm.font_with_fallback({
	{ family = "Maple Mono NF CN", weight = "Medium", harfbuzz_features = { "calt=1", "cv01=1" } },
})

config.font_rules = {
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font_with_fallback({
			{
				family = "MonaspiceRn Nerd Font",
				weight = "Bold",
				style = "Italic",
				harfbuzz_features = { "calt=1", "liga=1" },
			},
			{ family = "Maple Mono NF CN", weight = "Bold", style = "Italic" },
		}),
	},

	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font_with_fallback({
			{ family = "MonaspiceRn Nerd Font", weight = "Bold", harfbuzz_features = { "calt=1", "liga=1" } },
			{ family = "Maple Mono NF CN", weight = "Bold", harfbuzz_features = { "calt=1" } },
		}),
	},
}

config.font_size = 12
config.line_height = 1.0
config.cell_width = 1.0
config.bold_brightens_ansi_colors = true

config.window_padding = {
	left = 1,
	right = 1,
	top = 2,
	bottom = 2,
}

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true


-- ===== 终端体验 =====
-- config.scrollback_lines = 10000
config.audible_bell = "Disabled"
config.check_for_updates = false

-- ===== 复制粘贴：更顺手 =====
config.selection_word_boundary = " \t\n{}[]()\"'`,;:"

-- ===== 颜色：跟随系统主题/你也可以换主题名 =====
-- 你喜欢 tokyo night / catppuccin 可以告诉我，我给你配色
config.color_scheme = "Catppuccin Macchiato" -- mocha / frappe / latte

return config
