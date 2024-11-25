# dotfiles-nix

使用 Nix 管理 dotfiles

#### Table of Content
- [使用](#操作步骤)
- [caveats](#pitfalls)
- [Zsh](#zsh)
  - [MAC spoof](#mac-spoofing) 

## 操作步骤
- 根据 [nix-darwin](https://github.com/LnL7/nix-darwin#flakes) 文档初始化
  - 替换 hostname `scutil --get LocalHostName`
  - 安装 `nix --experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .`
    - 手动备份文件(`mv /etc/zshrc /etc/bashrc.before-nix-darwin`)
  - 构建 `darwin-rebuild switch --flake .`

## pitfalls
- 频繁操作导致 github rate limit，然后配置了 `access-tokens`(`~/.config/nix/nix.conf`)，之后在非 sudo 环境遇到 (`Bad credentials`)，[之后删除 `access-tokens` 才行](https://discourse.nixos.org/t/nix-commands-fail-github-requests-401-without-sudo/30038)。原因是配置的 token 设置了有效期。
- [重新打开终端 build 才会生效](https://github.com/LnL7/nix-darwin/issues/919#issuecomment-2094711044)
- [安装包的方式-声明式优先](https://github.com/NixOS/nixpkgs/pull/77960)
- garbage 导致 `darwin-system.drv` 被删除，`darwin-rebuild` 失败，必须再次安装 `nix-darwin`。
  - 没有使用 sudo 进行 `sudo nix-collect-garbage -d` 导致
    - sudo 删除还是有同样问题
  - darwin-rebuild --list-generations

## zsh

### mac spoofing
```shell
openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/:$//'
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
ifconfig en0 ether
# Change the MAC address  14:7d:da:a9:a8:8c(mbp)/84:8c:8d:b1:22:26(router)
sudo ifconfig en0 ether d8:18:fd:c0:41:96
networksetup -detectnewhardware
# Turn off the Wi-Fi device:
networksetup -setairportpower en0 off
```


## reference
- [nixos-config](https://github.com/dustinlyons/nixos-config)
- [flake schema](https://nixos.wiki/wiki/Flakes#Output_schema)
- [macos-defaults](https://github.com/yannbertrand/macos-defaults)
- [macos privacy guide](https://www.privacyguides.org/en/os/macos-overview/#mac-address-randomization)