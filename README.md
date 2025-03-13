# dotfiles-nix

使用 Nix 管理 dotfiles

## quick start 

- 手动安装 `nix` & `homebrew`
- 下载 nixpkgs 需开启 TUN 模式

### install
- 根据 [nix-darwin](https://github.com/LnL7/nix-darwin#flakes) 文档初始化
  - 替换 hostname `scutil --get LocalHostName`
  - 安装 `nix --experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#mini`
    - 手动备份文件(`mv /etc/zshrc /etc/bashrc.before-nix-darwin`)
  - 构建 `NIX_DEBUG=1 darwin-rebuild switch --flake .#mini --show-trace --print-build-logs --verbose`

## pitfalls
- 频繁操作导致 github rate limit，然后配置了 `access-tokens`(`~/.config/nix/nix.conf`)，之后在非 sudo 环境遇到 (`Bad credentials`)，[之后删除 `access-tokens` 才行](https://discourse.nixos.org/t/nix-commands-fail-github-requests-401-without-sudo/30038)。原因是配置的 token 设置了有效期。
- [重新打开终端 build 才会生效](https://github.com/LnL7/nix-darwin/issues/919#issuecomment-2094711044)
- [安装包的方式-声明式优先](https://github.com/NixOS/nixpkgs/pull/77960)
- garbage 导致 `darwin-system.drv` 被删除，`darwin-rebuild` 失败，必须再次安装 `nix-darwin`。
  - 没有使用 sudo 进行 `sudo nix-collect-garbage -d` 导致
    - sudo 删除还是有同样问题
  - darwin-rebuild --list-generations

## Troubleshooting

1. 通过 REPL 排查
```
# 进入 nix repl 解释器
nix --experimental-features 'nix-command flakes' repl
# 加载
nix-repl> :lf .

nix repl -f '<nixpkgs>'
```

2. 通过 build 结果分析

```
darwin-rebuild build --flake .#mini --show-trace --print-build-logs --verbose
```

## Nix

Nix 配置文件：
- `/etc/nix/nix.conf` 文件
- `NIX_CONFIG` 环境变量
- command line flags 方式 `--option <name> <value>`

```shell
# 查看配置
nix config show
# 指定 Nix 配置
NIX_CONFIG="substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" darwin-rebuild build  --flake .#mini -v
darwin-rebuild build --flake .#mini --option substituters "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
```

### Derivation

```shell
# 查看本地 drv 内容
nix derivation show /nix/store/j4avzn6fll1d1v588pss8nrmjfxlwlar-maven-3.6.3.drv
# 查看 pkgs 仓库 drv 内容
nix derivation show nixpkgs#maven
# 查看当前系统 drv 内容
nix derivation show -r /run/current-system
# 构建 drv
nix-store -r /nix/store/5y616j03c24dinqz74zr745i6nybmgkx-maven-3.9.9.drv
```

### stdenv

使用 `stdenv` 构建 derivation。


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