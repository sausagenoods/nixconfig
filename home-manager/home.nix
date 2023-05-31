{ config, pkgs, inputs, lib, ... }:

{
  home.username = "siren";
  home.homeDirectory = "/home/siren";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    jq
    firefox
    wofi
    hyprpaper
    element-desktop
    grim
    slurp
    keepassxc
  ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "DejaVu Sans Mono:size=10";
        dpi-aware = "yes";
        include = "/home/siren/.config/foot/catppuccin-mocha.conf";
        pad = "10x10";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      #csd = {
      #   border-width = 20;
      #};
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };
  #programs.xdg.enable = true;
}
