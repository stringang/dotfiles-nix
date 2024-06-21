{...}: {
  # `brew list`
  homebrew = {
    enable = true;

    # `brew list --formula`
    brews = [];

    # `brew list --cask`
    # https://github.com/laixintao/myrc/blob/master/brew-cask.list
    casks = [
      iterm2
      postman
      wireshark
      telegram
      virtualbox
      sourcetrail
      snipaste
      vagrant
      vmware-fusion
    ];
  };
}
