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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/stringang/nix-secrets.git";
      flake = false;
    };
  };

  # flake 输出
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    nix-darwin,
    home-manager,
    agenix,
    secrets,
    ...
  }:
    {
      formatter."x86_64-darwin" = nixpkgs.legacyPackages."x86_64-darwin".alejandra;

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#gangliu-MacBook-Pro
      darwinConfigurations."gangliu-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        # pure evaluation 模式，
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
          agenix.darwinModules.default
          # ./secrets/secrets.nix
        ];
        # 传递 inputs 给 darwinSystem
        specialArgs = {inherit inputs;};
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."gangliu-MacBook-Pro".pkgs;
    }
    //
    # use by `nix develop`
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        nodejs = pkgs.nodejs-18_x;
        yarn = pkgs.yarn.override {inherit nodejs;};
      in {
        devShells.default = import ./shell.nix {inherit pkgs;};

        #        devShells.default = pkgs.mkShell {
        #          nativeBuildInputs = with pkgs; [
        #            nodejs
        #            yarn
        #          ];

        #                  buildInputs = with pkgs; (lib.optionals (!stdenv.isDarwin) [libsecret libkrb5]
        #                    ++ (with xorg; [libX11 libxkbfile])
        #                    ++ lib.optionals stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
        #                      #              AppKit
        #                    ]));
        #        };
      }
    );
}
