-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local AutoQuit = vim.api.nvim_create_augroup("AutoQuit", { clear = true })
local AutoCmd = vim.api.nvim_create_autocmd

AutoCmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})
-- When you enter q!, the command-line window will exit automatically.
AutoCmd("CmdwinEnter", {
  group = AutoQuit,
  desc = "Auto quit command-line window",
  callback = function()
    vim.cmd("quit")
    vim.cmd("qall")
  end,
})

-- Ensure smooth exit when a sidebar is present.
AutoCmd("BufEnter", {
  group = AutoQuit,
  desc = "Quit Neovim if only sidebar windows remain",
  callback = function()
    -- 只在有多个窗口时检查，避免刚打开文件就退出
    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins <= 1 then
      return
    end

    local sidebar_fts = {
      ["neo-tree"] = true,
      ["NvimTree"] = true,
      ["qf"] = true, -- 快速修复窗口
      ["help"] = true, -- 帮助窗口
      ["fugitive"] = true, -- Git相关窗口
      ["noice"] = true,
      ["snacks_notif"] = true,
    }

    local has_non_sidebar = false

    -- 检查所有窗口
    for _, winid in ipairs(wins) do
      if vim.api.nvim_win_is_valid(winid) then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        -- 如果发现任何非侧边栏窗口，设置标志
        if not sidebar_fts[filetype] then
          has_non_sidebar = true
          break -- 找到一个非侧边栏窗口就足够，可以提前退出循环
        end
      end
    end

    -- 只有当所有窗口都是侧边栏时才执行退出操作
    if not has_non_sidebar then
      if #vim.api.nvim_list_tabpages() > 1 then
        vim.cmd("tabclose")
      else
        vim.cmd("qall")
      end
    end
  end,
})
