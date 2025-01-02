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
  programs.hyprland.enable = true;
  services.tailscale.enable = true;

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
    element-desktop
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
    transmission_4
    gimp
    ffmpeg
    libwebp
    pwgen
    adwaita-icon-theme
    tmux
    filezilla
    go
    gcc
    dunst
    vscodium
    krita
    ncdu
    openvpn
    nodejs
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
    NIXOS_OZONE_WL = 1;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = "HibernateDelaySec=20m";
  environment.etc."systemd/system-sleep/loginctl-unlock-sessions-post-hibernation".source =
    pkgs.writeShellScript "loginctl-unlock-sessions-post-hibernation" ''
      [ "$1$SYSTEMD_SLEEP_ACTION" == "posthibernate" ] && ${pkgs.systemd}/bin/loginctl unlock-sessions
    '';
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

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

  hardware.bluetooth = {
    enable = true;
  };

  programs.wireshark.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "23.05";
}
