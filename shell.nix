{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    buildInputs = with pkgs; [nodejs-18_x];
    #      ++ [
    #        (haskellPackages.ghcWithPackages (ghcPkgs:
    #          with ghcPkgs; [
    #            haskell-language-server
    #
    #            xmonad
    #            xmonad-contrib
    #            xmobar
    #          ]))
    #      ];
  }
