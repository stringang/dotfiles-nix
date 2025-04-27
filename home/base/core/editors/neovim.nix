{
  config,
  pkgs,
  ...
}: let
  # nvim 配置目录
  configPath = "${config.home.homeDirectory}/github/dotfiles-nix/home/base/core/editors/nvim";
in {
  # 设置 neovim 的配置(软链接)目录
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;

  programs = {
    neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
    };
  };
}
