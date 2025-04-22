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
    casks = [
      "vagrant"
      "virtualbox"
      # "vmware-fusion"
    ];
  };
}
