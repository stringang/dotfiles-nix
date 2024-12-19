{
  lib,
  inputs,
  darwinModules,
  homeModules ? [],
  myvars,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs myvars),
  ...
}: let
  inherit (myvars) system;
  inherit (inputs) nixpkgs-darwin home-manager nix-darwin;
in
  nix-darwin.lib.darwinSystem {
    inherit system specialArgs;
    modules =
      darwinModules
      ++ [
        {nixpkgs.pkgs = import nixpkgs-darwin {inherit system;};}
      ]
      ++ (
        lib.optionals ((lib.lists.length homeModules) > 0)
        [
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              verbose = true;
              backupFileExtension = "home-manager.backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${myvars.username}.imports = homeModules;
              extraSpecialArgs = specialArgs;
            };
          }
        ]
      );
  }