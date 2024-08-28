{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      LANG = "en_US.UTF-8";
    };

    localVariables = {
      ZSH_AUTOSUGGEST_STRATEGY = ["history" "completion"];
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";

      plugins = [
        "git"
        "golang"
        "docker"
      ];
    };

    # bindkey | grep I
    initExtra = ''
      # https://github.com/zsh-users/zsh-autosuggestions/issues/132#issuecomment-491248596
      # https://github.com/zsh-users/zsh-autosuggestions/issues/532
      bindkey '$' autosuggest-accept
    '';
  };
}
