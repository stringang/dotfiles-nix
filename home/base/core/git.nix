{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) mynur;
in {
  home.packages = with pkgs; [
    git-lfs
    git-extras
  ];

  programs.git = {
    enable = lib.mkDefault true;

    lfs.enable = true;

#    includes = [
#      {path = "${mynur.legacyPackages.${pkgs.system}.catppuccinThemes.delta}/catppuccin.gitconfig";}
#    ];
    delta = {
      enable = true;
      options = {
#        features = "catppuccin-mocha";
      };
    };

    extraConfig = {
      core = {
        editor = "vim";
      };
      color = {
        ui = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      fetch = {
        prune = true;
      };
      log = {
        date = "format-local:%Y-%m-%d %H:%M:%S";
      };
    };

    ignores = [
      "*~"
      ".DS_Store"
    ];
  };
}