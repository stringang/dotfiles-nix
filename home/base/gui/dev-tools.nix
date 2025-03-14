{pkgs-stable, ...}: {
  home.packages = with pkgs-stable; [
    # mitmproxy # http/https proxy tool
    # insomnia # REST client
    # wireshark # network analyzer

    # IDEs
    # jetbrains.idea-community
    jetbrains.pycharm-professional
  ];
}
