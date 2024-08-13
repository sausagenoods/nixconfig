{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.crypted.device = "/dev/nvme0n1p1";

  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';

  networking.hostName = "eek14";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vilnius";

  programs.zsh.enable = true;
  programs.sway.enable = true;

  users.users.siren = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "audio" "dialout" "docker" "vboxusers" "adbusers" "wireshark" ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    wayland
    xdg-utils
    htop
    brightnessctl
    clinfo
    mpv
    git
    alacritty
    zsh-completions
    zsh-autosuggestions
    imv
    jq
    firefox
    wofi
    hyprpaper
    grim
    slurp
    keepassxc
    pavucontrol
    pulseaudio
    element-desktop-wayland
    swaybg
    chromium
    waybar
    monero-cli
    thunderbird
    obs-studio
    monero-gui
    networkmanagerapplet
    dig
    whois
    libreoffice
    file
    unzip
    wl-clipboard
    transmission
    gimp
    ffmpeg
    libwebp
    pwgen
    gnome.adwaita-icon-theme
    tmux
    filezilla
    go
    gcc
    dunst
    vscodium
    krita
    v2raya
  ];

  fonts.packages = with pkgs; [
    inter
    font-awesome
    terminus-nerdfont
  ];

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.blueman.enable = true;

  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    };
  };

  # Suspend-then-hibernate everywhere
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=2m
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=3m";

  networking.firewall = {
    checkReversePath = false;
    allowedTCPPorts = [ 8000 5000 8081 5175 5173 3000 8384 ];
    allowedUDPPorts = [ 51820 37923 ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.wireshark.enable = true;

  system.stateVersion = "23.05";
}
