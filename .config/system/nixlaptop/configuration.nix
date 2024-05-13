# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ libs, config, pkgs, home-manager, ... }:

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
    # <home-manager/nixos>
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
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };
  # Docker
  virtualisation.docker.enable = true;
  # dconf
  programs.dconf = { enable = true; };
  # fish
  programs.fish.enable = true;

  # Kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  ## X Config
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    # Configure keymap in X11
    xkb.layout = "us, es";
    xkb.variant = "altgr-intl";
    xkb.options = "grp:win_space_toggle";
    # Display Manager
    displayManager = {
      gdm.enable = true; # gnome
      # sddm.enable = true;
      # sddm.theme = "catppuccin-sddm-corners";
      # defaultSession = "none+exwm";
      defaultSession = "gnome";
    };
    desktopManager.gnome.enable = true;
    # EXWM
    #   windowManager.exwm = {
    #     enable = true;
    #     enableDefaultConfig = false;
    #     loadScript = "(exwm-enable)";
    #   };
  };
  # Emacs
  # services.emacs.enable = true;
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:0lhx2fkf8q56wsaywahjfyxzrnarbm8zjwzcrlc0i7klq3j4c2dq";
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # Bluetooth battery
  hardware.bluetooth.settings = {
    General = { Experimental-Features = true; };
  };
  # Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations
  # rtkit is optional but recommended
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;
  # };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mbarria = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "plugdev"
    ]; # Enable ‘sudo’ for the user.
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
    # (catppuccin-gtk.override {
    #   accents = [
    #     "mauve"
    #   ]; # You can specify multiple accents here to output multiple themes
    #   size = "standard";
    #   # tweaks =
    #   # [ "rimless" "black" ]; # You can also specify multiple tweaks here
    #   variant = "frappe";
    # })
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
    glibcLocales # started having issues with locales, no clue why
    git # version contol
    gnumake
    gnupg # encryption
    gtk3
    gtk4
    gtk-engine-murrine # for installing gnome themes
    i3lock-fancy
    isort
    libtool
    maim # screenshots
    multimarkdown
    playerctl
    pueue # process queue
    # (python310.withPackages my-python-packages)
    # python311
    scrot
    slock
    tlp
    upower
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    wezterm # terminal emulator
    xdotool
    xorg.xdpyinfo
    xorg.xev
    xorg.xhost
    xorg.xinit
    xorg.xmodmap
    xorg.xwininfo
    # hyprland/wayland
    # waybar # bar
    # dunst # notifications
    # rofi-wayland # app launcher
    # swww # wallpaper
    # networkmanagerapplet
    # flameshot # screenshots
    # hyprkeys # extract keys
    # copyq # clipboard
    # xdg-desktop-portal-hyprland
    # catppuccin-sddm-corners # sddm theme
    # wireplumber # audio control
    # ## Only on unstable as of 04/03/2024
    # hyprlock # lockscreen
    # hypridle # idle daemon
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
      pkgs.gedit # text editor
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

  # Make systemd see my programs
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/home/mbarria/.nix-profile/bin:/run/current-system/sw/bin"
  '';

  ## Services
  systemd.services = {
    # pueue
    pueued = {
      description = "Pueue Daemon";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        User = "mbarria";
        ExecStart = "${pkgs.pueue}/bin/pueued -vv";
      };
    };
  };

  # VPN
  services.openvpn.servers = {
    uss = {
      config = "config /home/mbarria/.config/vpn/uss/clientconfig.ovpn ";
    };
  };
  # # Dropbox as a service
  # networking.firewall = {
  #   allowedTCPPorts = [ 17500 30000 ];
  #   allowedUDPPorts = [ 17500 ];
  # };

  # systemd.user.services.dropbox = {
  #   description = "Dropbox";
  #   wantedBy = [ "graphical-session.target" ];
  #   environment = {
  #     QT_PLUGIN_PATH = "/run/current-system/sw/"
  #       + pkgs.qt5.qtbase.qtPluginPrefix;
  #     QML2_IMPORT_PATH = "/run/current-system/sw/"
  #       + pkgs.qt5.qtbase.qtQmlPrefix;
  #   };
  #   serviceConfig = {
  #     ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
  #     ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
  #     KillMode = "control-group"; # upstream recommends process
  #     Restart = "on-failure";
  #     PrivateTmp = true;
  #     ProtectSystem = "full";
  #     Nice = 10;
  #   };
  # };
  # udev rules
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.udev.extraRules = ''
    # Rules for Oryx web flashing and live training
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

    # Legacy rules for live training over webusb (Not needed for firmware v21+)
      # Rule for all ZSA keyboards
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
      # Rule for the Moonlander
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
      # Rule for the Ergodox EZ
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
      # Rule for the Planck EZ
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

    # Wally Flashing rules for the Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

    # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
    # Keymapp Flashing rules for the Voyager
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';

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
