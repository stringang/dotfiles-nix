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

    initExtra = ''
      # https://github.com/zsh-users/zsh-autosuggestions/issues/132#issuecomment-491248596
      bindkey ',' autosuggest-accept
    '';
  };
}
