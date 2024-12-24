{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    dive # explore docker layers
    skopeo # copy/sync images between registries and local storage
    go-containerregistry # provides `crane` & `gcrane`, it's similar to skopeo

    kubectl
  ];


}