{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    buildInputs = [nodejs-18_x shellcheck];

    shellHook = ''
      echo "hello nix develop"
      # exec ${stdenv.shell}
    '';
  }
