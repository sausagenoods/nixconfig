{ config, pkgs, inputs, lib, ... }:

{
  home.username = "siren";
  home.homeDirectory = "/home/siren";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    jq
    firefox
    wofi
    hyprpaper
    element-desktop
    grim
    slurp
    keepassxc
    nerdfonts
    font-awesome
    pavucontrol
    pulseaudio
    git
    swaybg
    chromium
    waybar
    monero-gui
    thunderbird
    transmission
    imv
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
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 15;
    x11.enable = true;
    gtk.enable = true;
  };
}
