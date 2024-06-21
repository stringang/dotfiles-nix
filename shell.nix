{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    buildInputs = with pkgs; [nodejs-18_x shellcheck];

    shellHook = ''
      echo "hello nix develop"
      exec ${stdenv.shell}
    '';
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
