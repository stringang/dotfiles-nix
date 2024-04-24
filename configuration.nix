{ config, lib, pkgs, inputs, ... }:

{
  services.nix-daemon.enable = true;

  launchd.daemons.nix-daemon.serviceConfig.EnvironmentVariables.https_proxy = "http://127.0.0.1:7890";
  launchd.daemons.nix-daemon.serviceConfig.EnvironmentVariables.http_proxy = "http://127.0.0.1:7890";

  nix = {
    package = pkgs.nix;

    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];

      substituters = [
        "https://mirrors.bfsu.edu.cn/nix-channels/store/"
        "https://mirror.sjtu.edu.cn/nix-channels/store/"
      ];

      trusted-users = ["root" "gang.liu"];

    };
  };

  programs.zsh = {
    enable = true;
    promptInit = lib.mkForce "";
  };

  system = {
    configurationRevision = with inputs; self.rev or self.dirtyRev or null;
    stateVersion = 4;
  };

  # The platform the configuration will be used on.
  nixpkgs = {
    hostPlatform = "x86_64-darwin";
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs;
    [
      vim
    ];

}