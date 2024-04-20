# dotfiles-darwin

使用 Nix 管理 dotfiles

## 操作步骤
- 根据 [nix-darwin](https://github.com/LnL7/nix-darwin#flakes) 文档初始化
  - 替换 hostname `scutil --get LocalHostName`
  - 安装 `nix --experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .`
    - 手动备份文件(`mv /etc/zshrc /etc/bashrc.before-nix-darwin`)
  - 构建 `darwin-rebuild switch --flake .`

## reference
- 