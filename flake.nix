{
  description = "gang.liu macOS system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, nix-darwin, home-manager, ...}:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#gangliu-MacBook-Pro
    darwinConfigurations."gangliu-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        # `nix-darwin` main config
        configuration
        # `home-manager` module config
        home-manager.darwinModules.home-manager
          {
              # hardcode see: https://github.com/nix-community/home-manager/issues/4026
              users.users."gang.liu".home = "/Users/gang.liu";

              home-manager.verbose = true;
              home-manager.backupFileExtension = "hm_bak~";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."gang.liu" = import ./home;
          }
       ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."gangliu-MacBook-Pro".pkgs;
  };
}
