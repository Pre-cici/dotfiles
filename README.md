# Dotfiles

个人终端、编辑器和桌面配置。通用配置使用 GNU Stow 管理，平台专用配置放在 `mac/` 和 `win/`。

## 目录

```text
.
├── fastfetch/      # 系统信息展示
├── fzf/            # 模糊搜索
├── git/            # Git 配置与全局忽略规则
├── kitty/          # 终端、主题和快捷键
├── mac/            # karabiner
├── nvim/           # Neovim 配置（Git 子模块）
├── opencode/       # OpenCode 配置与技能
├── tmux/           # 会话管理、快捷键和状态栏
├── win/            # GlazeWM、WezTerm、YASB
├── zsh/            # 环境变量、Zim、Powerlevel10k
└── stow-all.sh     # 安装依赖并链接终端配置
```

## 获取配置

```sh
git clone --recurse-submodules https://github.com/Pre-cici/dotfiles.git ~/Dotfiles
cd ~/Dotfiles
```

已有仓库补全子模块：

```sh
git submodule update --init --recursive
```

## 链接配置

安装 GNU Stow 后，在仓库根目录执行。先预演，确认没有已有文件冲突：

```sh
stow --simulate --verbose --target="$HOME" zsh git nvim fastfetch tmux fzf
stow --target="$HOME" zsh git nvim fastfetch tmux fzf
```

也可以单独部署，例如 Kitty：

```sh
stow --target="$HOME" kitty
```

Stow 将包内路径映射到 Home，例如 `kitty/.config/kitty/` 对应 `~/.config/kitty/`。已有同名文件应先自行备份、整理，再链接。

### macOS

`mac/` 里面保存了Karabiner改键配置，

```sh
mkdir -p "$HOME/.config/karabiner"
ln -s "$HOME/Dotfiles/mac/karabiner/karabiner.json" \
  "$HOME/.config/karabiner/karabiner.json"
```

### Windows

`win/` 保存 GlazeWM、WezTerm 和 YASB 配置，按各软件的配置路径单独部署。

## 安装脚本

```sh
bash stow-all.sh
```

脚本支持 Homebrew、APT、DNF 和 Pacman，安装依赖、初始化子模块、链接 `zsh git nvim fastfetch tmux fzf`，并安装 tmux 插件管理器 TPM。它不会自动部署 Kitty、OpenCode 或平台专用配置，也不会执行 `git pull`。

当前 Linux 部署仍需检查软件版本：Ubuntu 22.04 默认源中的 fzf 不支持配置使用的 `fzf --zsh`，Neovim 版本也较旧；fastfetch、yazi 可能缺包。TPM 安装后，在 tmux 中按 `Ctrl+a`，再按 `Shift+i` 安装插件。

## 日常维护

- Zsh 环境变量位于 `zsh/.zshenv`，交互配置位于 `zsh/.config/zsh/.zshrc`。
- tmux 前缀键为 `Ctrl+a`，前缀后按 `r` 重新加载配置。
- Kitty 配置可用 `⌘⇧,` 手动加载；部分选项需要重启生效。
- Neovim 是独立仓库，修改和提交需在子模块内处理。
- 链接后的配置通常直接指向仓库文件，修改后可用 `git diff` 检查变化。
