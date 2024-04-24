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

  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#gangliu-MacBook-Pro
    darwinConfigurations."gangliu-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        # `nix-darwin` main config
        ./configuration.nix
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
       specialArgs = { inherit inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."gangliu-MacBook-Pro".pkgs;
  };
}
