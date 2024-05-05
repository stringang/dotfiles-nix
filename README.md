# dotfiles-darwin

使用 Nix 管理 dotfiles

## 操作步骤
- 根据 [nix-darwin](https://github.com/LnL7/nix-darwin#flakes) 文档初始化
  - 替换 hostname `scutil --get LocalHostName`
  - 安装 `nix --experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .`
    - 手动备份文件(`mv /etc/zshrc /etc/bashrc.before-nix-darwin`)
  - 构建 `darwin-rebuild switch --flake .`

## pitfalls
- 频繁操作导致 github rate limit，然后配置了 `access-tokens`(`~/.config/nix/nix.conf`)，之后在非 sudo 环境遇到 (`Bad credentials`)，[之后删除 `access-tokens` 才行](https://discourse.nixos.org/t/nix-commands-fail-github-requests-401-without-sudo/30038)。原因是配置的 token 设置了有效期。
- 重新打开终端 build 才会生效

## reference
- 