{lib, pkgs, ...}: {
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

}