{
  myvars,
  pkgs,
  ...
}: let
  inherit (myvars) hostname;
in {
  networking.hostName = hostname;
  #  networking.computerName = hostname;
  #  system.defaults.smb.NetBIOSName = hostname;

  homebrew = {
    masApps = {
      "Microsoft Word" = 462054704;
    };

    taps = [
      "localsend/localsend"
      "hashicorp/tap"
    ];

    casks = [
      "vagrant"
      "virtualbox"
      # "vmware-fusion"
      "telegram"
      "wireshark"
      "sequel-ace" # database management
      "goland"
      "intellij-idea"
    ];
  };
}
