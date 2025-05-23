{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      LANG = "en_US.UTF-8";
    };

    localVariables = {
      DISABLE_MAGIC_FUNCTIONS = "true";
      HIST_STAMPS = "yyyy-mm-dd";
      ZSH_AUTOSUGGEST_STRATEGY = ["history" "completion"];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "golang"
        "docker"
        "extract"
        "vi-mode"
        "vagrant"
      ];
      theme = "robbyrussell";
    };

    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "nix-community";
          repo = "nix-zsh-completions";
          rev = "0.5.1";
          sha256 = "sha256-bgbMc4HqigqgdkvUe/CWbUclwxpl17ESLzCIP8Sz+F8=";
        };
      }
    ];

    initExtra = ''
      bindkey '$' autosuggest-accept
    '';

    shellAliases = {};
  };
}
