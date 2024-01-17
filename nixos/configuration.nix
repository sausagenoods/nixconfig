{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [ # Include the results of the hardware scan.
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
    extraGroups = [ "wheel" "video" "networkmanager" "audio" "dialout" "docker" "vboxusers" "adbusers" ];
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [
  {
    users = [ "siren" ];
    commands = [
      {
        command = "${pkgs.light}/bin/light -U 5";
        options = [ "NOPASSWD" ];
      }
      {
        command = "${pkgs.light}/bin/light -A 5";
        options = [ "NOPASSWD" ];
      }
    ];
  }];

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
    foot
    zsh
    zsh-completions
    zsh-powerlevel10k
    zsh-autosuggestions

    jq
    firefox
    wofi
    hyprpaper
    grim
    slurp
    keepassxc
    font-awesome
    pavucontrol
    pulseaudio
    element-desktop-wayland
    swaybg
    chromium
    waybar
    monero-cli
    thunderbird
  ];

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  virtualisation.docker.enable = true;

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

  networking.firewall.allowedTCPPorts = [ 8000 5000 8081 ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  services.tor.enable = true;
  services.tor.client.enable = true;

  system.stateVersion = "23.05";
}

