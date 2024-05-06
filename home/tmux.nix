{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    terminal = "xterm-256color";
    mouse = true;
    keyMode = "vi";

    # oh my tmux https://github.com/gpakosz/.tmux
    plugins = with pkgs.tmuxPlugins; [
      sensible
      cpu
      continuum
      {
        plugin = resurrect;
        #  extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = yank;
        #  extraConfig = '''';
      }
      {
        plugin = dracula; # theme
        extraConfig = ''
          set -g @dracula-plugins "cpu-usage battery time"
          set -g @dracula-show-battery true
          set -g @dracula-show-powerline true
          set -g @dracula-show-weather false
          set -g @dracula-show-fahrenheit false
          set -g @dracula-show-location false
          set -g @dracula-show-network false
          set -g @dracula-show-cpu-usage true
          set -g @dracula-time-format "%F %R"
          set -g @dracula-refresh-rate 10
        '';
      }
    ];
  };
}
