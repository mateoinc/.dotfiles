# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ libs, config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixlaptop"; # Define your hostname.
  # Look for config in hostname
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Santiago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };
  # Docker
  virtualisation.docker.enable = true;
  # dconf
  programs.dconf = { enable = true; };

  # Kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    # Configure keymap in X11
    layout = "us, es";
    xkbVariant = "intl";
    xkbOptions = "grp:win_space_toggle";
    # Display Manager
    displayManager = {
      gdm.enable = true; # gnome
      # sddm.enable = true;
      # defaultSession = "none+exwm";
      defaultSession = "gnome";
    };
    # Gnome in case of emergency
    desktopManager.gnome.enable = true;
    # EXWM
    windowManager.exwm = {
      enable = true;
      enableDefaultConfig = false;
      loadScript = "(exwm-enable)";
    };
  };
  # Emacs
  # services.emacs.enable = true;
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];
  # Nvidia Drivers
  nixpkgs.config.allowUnfree = true;

  # services.xserver.videoDrivers = [ "modeline" ];
  hardware = {
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio.support32Bit = true;
  };
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  hardware.nvidia.modesetting.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:3:0:0";
  };
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mbarria = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
  # Allow it to edit nix
  nix.settings.allowed-users = [ "@wheel" ];
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };
  programs.droidcam.enable = true;
  # Optimize store
  nix.settings.auto-optimise-store = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alsaUtils
    arandr
    brightnessctl
    cmake
    # catppuccin-gtk # theme for gnome
    (catppuccin-gtk.override {
      accents = [
        "mauve"
      ]; # You can specify multiple accents here to output multiple themes
      size = "standard";
      # tweaks =
      # [ "rimless" "black" ]; # You can also specify multiple tweaks here
      variant = "frappe";
    })
    dropbox-cli
    droidcam # use phone as webcam
    editorconfig-core-c
    # emacs # yes
    (emacs.override {
      withXwidgets = true;
      withPgtk = true;
    })
    fd # find
    nvidia-offload
    feh
    gcc # cpp compiler
    git # version contol
    gnumake
    gnupg # encryption
    gtk3
    gtk-engine-murrine # for installing gnome themes
    i3lock-fancy
    isort
    libtool
    maim # screenshots
    multimarkdown
    playerctl
    # (python310.withPackages my-python-packages)
    python311
    scrot
    slock
    tlp
    upower
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    xdotool
    xorg.xdpyinfo
    xorg.xev
    xorg.xhost
    xorg.xinit
    xorg.xmodmap
    xorg.xwininfo
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # Android sync
  programs.kdeconnect.enable = true;
  # List services that you want to enable:
  services.cron = {
    enable = true;
    systemCronJobs = [
      "@reboot  root /home/mbarria/Programs/nixos_clean.sh >> /home/mbarria/Logs/nixos_clean.log"
      "@reboot  root /home/mbarria/Programs/trim_generations.sh 5 14 system >> /home/mbarria/Logs/trim_generations.log"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs.gnome; [
      # cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  # Dropbox as a service
  networking.firewall = {
    allowedTCPPorts = [ 17500 30000 ];
    allowedUDPPorts = [ 17500 ];
  };

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/"
        + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/"
        + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # thiib.singleton"ib.singleton"s value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
