{pkgs, ...}: {
  home.packages = with pkgs; [
    shellcheck
    skopeo
    dive
  ];
}