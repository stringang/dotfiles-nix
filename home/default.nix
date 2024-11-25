{
  config,
  lib,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  #  home.username = "gang.liu";
  #  home.homeDirectory = "/Users/gang.liu";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  home = {
    packages = with pkgs; [
      kcat
      minio-client
      shellcheck
      skopeo
      dive
      vagrant
      # dev env
      caddy
      nodejs_20
      corepack_20
      go_1_22
      python311
      # python311Packages.conda
      # reattach-to-user-namespace # for tmux
    ];

    sessionVariables = {};

    file = {
      ".ssh/config".source = ../config/ssh/config;
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      ignores = [
        ".DS_Store"
        ".idea/"
      ];
      extraConfig = {
        init.defaultBranch = "main";
      };

      lfs.enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  imports = [
    ./zsh.nix
    ./tmux.nix
  ];
}
