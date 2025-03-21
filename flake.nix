{
  description = "gang.liu macOS system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #    secrets = {
    #      url = "git+ssh://git@github.com/stringang/nix-secrets.git";
    #      flake = false;
    #    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    mylib = import ./lib {inherit lib;};

    genSpecialArgs = myvars: {
      inherit inputs mylib myvars;

      pkgs-stable = import inputs.nixpkgs {
        inherit (myvars) system;
        # pass-through Allow unfree packages
        config.allowUnfree = true;
      };
    };

    # common arguments pass to darwin & nixos hosts
    commonArgs = {inherit inputs lib mylib genSpecialArgs;};

    darwinHosts = {
      mini = rec {
        myvars = {
          system = "aarch64-darwin";
          username = "liugang";
          homeDirectory = "/Users/liugang";
          hostname = "liugang-mini";
        };
        # darwin 模块
        darwinModules = [
          ./modules/darwin
          (./. + "/hosts/darwin-mini")
        ];
        homeModules = [
          ./home/darwin
          (./. + "/hosts/darwin-mini/home.nix")
        ];
      };
      mbp = {
        myvars = {
          system = "x86_64-darwin";
          username = "liugang";
          homeDirectory = "/Users/liugang";
          hostname = "liugang-mbp";
        };
        darwinModules = [
          ./modules/darwin
          ./hosts/darwin-mbp
        ];
        homeModules = [
          ./home/darwin
          ./hosts/darwin-mbp/home.nix
        ];
      };
      work = {
        myvars = {
          system = "aarch64-darwin";
          username = "yuzhang";
          homeDirectory = "/Users/yuzhang";
          hostname = "yuzhang-mbp";
        };
        darwinModules = [
          ./modules/darwin
          ./hosts/darwin-work
        ];
        homeModules = [
          ./home/darwin
          ./hosts/darwin-work/home.nix
        ];
      };
    };
  in
    {
      darwinConfigurations =
        builtins.mapAttrs (
          _: value:
            mylib.macosSystem (commonArgs // value)
        )
        darwinHosts;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            nil
            taplo
            typos
          ];
        };

        # Format the nix code in this flake
        formatter =
          # alejandra is a nix formatter with a beautiful output
          pkgs.alejandra;
      }
    );
}
