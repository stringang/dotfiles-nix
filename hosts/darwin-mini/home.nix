{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/by-name/ma/maven/package.nix
    ((maven.override {
        jdk_headless = jdk8_headless;
      })
      .overrideAttrs
      (finalAttrs: previousAttrs: {
        version = "3.6.3";
        # 使用 fetchTarball 下载后文件名是 `/nix/store/hash-digest-source` 格式，导致 installPhase 失败
        # 下载的文件会自动解压（`unpackPhase`）
        src = builtins.fetchurl {
          url = "https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz";
          sha256 = "1i9qlj3vy4j1yyf22nwisd0pg88n9qzp9ymfhwqabadka7br3b96";
          # hash = "sha512-c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0";
        };
      }))

    python312Full # Python interpreter
    python312Packages.argcomplete
    python312Packages.pip # Pip installer
    python312Packages.conda
  ];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
    '';
  };

  programs.go = rec {
    enable = true;
    # package = pkgs-unstable.go_1_23;
    goPath = "go";
    goBin = "${goPath}/bin";
  };

  home.sessionPath = [
    "$GOPATH/bin"
  ];

  home.sessionVariables = {
    GO111MODULE = "on";
    GOPROXY = lib.concatStringsSep "|" [
      "https://goproxy.cn"
      "https://goproxy.io"
      "https://proxy.golang.org"
      "direct"
    ];
  };

  programs.zsh = {
    shellAliases = {
      mac_spoof = "sudo ifconfig en1 ether 61:ab:01:64:ea:be";
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk8;
  };
}
