-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.inlay_hints = true
vim.g.transparent = true
vim.g.bordered = vim.g.transparent
vim.o.winborder = vim.g.bordered and "rounded" or "none"

local opt = vim.opt
-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 2
opt.shiftwidth = 0
opt.expandtab = true
opt.autoindent = true

-- 读取文件
opt.autoread = true
opt.autowrite = true -- Enable auto write

-- 防止包裹
opt.wrap = false

-- 光标行
opt.cursorline = true
-- opt.colorcolumn = "150"

-- 启用鼠标
opt.mousemoveevent = true
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- 默认新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 延迟
opt.timeout = true
opt.timeoutlen = 300 -- 用于 which-key / leader 快捷键延迟
opt.ttimeout = true
opt.ttimeoutlen = 30 -- 仅影响 Esc/方向键识别
