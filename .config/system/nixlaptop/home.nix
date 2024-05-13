{ config, pkgs, ... }:
let
  my-python-packages = ps:
    with ps; [
      numpy # Math
      matplotlib # Graphs
      scipy # Science
      python-lsp-server # language server protocol
      pip
    ];
in {
  # imports = [ ./alien.nix ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mbarria";
  home.homeDirectory = "/home/mbarria";
  nixpkgs.config.allowUnfree = true;
  targets.genericLinux.enable = true;
  # Make sure apps are seen by XDG
  xdg.mime.enable = true;
  xdg.systemDirs.data =
    [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    atool
    black # py
    betterdiscordctl
    calibre # ebook management
    carapace # better shell completions
    # catppuccin-gtk # theme
    celeste # rclone powered cloud sync
    chromium # in case firefox doesn't work
    clang-tools # working with C
    discord # chat
    # dropbox-cli
    evince # pdf reader
    fira-code # font with ligatures
    (firefox.override { nativeMessagingHosts = [ passff-host ]; })
    fd # find
    floorp-unwrapped # firefox-based browser
    gcc # cpp compiler
    git # version contol
    gimp # image editor
    glslang
    gnumake
    gnupg # encryption
    gnome.gnome-settings-daemon
    gnome.gnome-themes-extra
    gnomeExtensions.bluetooth-battery
    gnomeExtensions.appindicator
    graphviz # graphs (org roam)
    gr-framework # graphics (julia)
    httpie
    hugo # website engine
    hunspell # spel check for libreoffice
    hunspellDicts.en_US # hunspell dictionary
    hunspellDicts.es_CL # hunspell dictionary
    imagemagick
    inkscape-with-extensions # vector graphics
    isync # email syncing
    isort
    ispell # spellcheck
    jdk11 # Java
    julia-bin # language
    # jupyter # python notebook
    ledger # money management
    libreoffice-qt # word processor, calc, presentations, etc
    libsForQt5.dolphin # file manager
    libtool
    libxml2 # data formatting
    # lua54Packages.digestif # lsp server for LaTeX
    lxappearance # gtk theming
    maim # screenshots
    multimarkdown
    mu # email viewer
    nerdfonts # iconic fonts
    nixfmt # formatting tool for Nix
    nil # lsp
    nodejs
    oh-my-posh # shell theme
    okular # pdf
    obs-studio # screen recording
    pandoc # universal document converter
    # pass # password manager
    (pass.withExtensions (ext: with ext; [ pass-update pass-otp pass-audit ]))
    passff-host # bridge to pass firefox
    pdfpc # pdf
    pinentry-qt # ask for passwords graphically
    # pueue # process queue
    playerctl
    # python311
    (python311.withPackages my-python-packages)
    protonvpn-gui # vpn
    protontricks # make games run better
    ripgrep # Doom emacs dep
    rclone # cloud sync
    shellcheck # sh
    shfmt # sh
    sioyek # pdf viewer focused on research
    scrot
    slock
    spotify # music
    stdenv.cc.cc.lib # libstd++ (added for pyls)
    soulseekqt
    sqlite # Doom emacs dep (lookup)
    # texlive.combined.scheme-full # LaTeX
    tetrio-desktop
    texliveFull # LaTeX
    thefuck # command typo fixer
    tlp
    tridactyl-native # vim for firefox
    upower
    vlc # Video/Audio player
    vim # fallback text editor
    wineWowPackages.stable # Wine 32 n 64 bit
    wordnet # Doom emacs dep (lookup)
    xclip
    wezterm # term emulator + multiplexer
    wget
    wl-clipboard # for images in emacs
    xbindkeys # keybinds
    zip # zip and unzip; required to export org to ODT
  ];
  # emacs server
  services.emacs.enable = true;
  home.sessionVariables = { EDITOR = "${pkgs.emacs}/bin/emacsclient -t"; };
  # theming
  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Catppuccin-Frappe-Compact-Mauve-Dark";
  #     package = pkgs.catppuccin-gtk.override {
  #       accents = [ "mauve" ];
  #       size = "compact";
  #       tweaks = [ "rimless" "black" ];
  #       variant = "frappe";
  #     };
  #   };
  # };
  # Symlink theme
  # xdg.configFile = {
  #   "gtk-4.0/assets".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
  #   "gtk-4.0/gtk.css".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
  #   "gtk-4.0/gtk-dark.css".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  # };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mbarria/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Shell configuration
  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -f $HOME/.config/bash/.bashrc ];
      then
        source $HOME/.config/bash/.bashrc
      fi
    '';
  };
  programs.fish = {
    enable = true;
    shellInit = ''

      if test -f $HOME/.config/fish/config.base.fish
        source $HOME/.config/fish/config.base.fish
      end
    '';
  };
  programs.nushell = { enable = true; };

  # Systemd services

  # programs.zsh = {
  #   enable = true;
  #   initExtra = ''

  #     if [ -f $HOME/.config/zsh/.zshrc ];
  #     then
  #       source $HOME/.config/zsh/.zshrc
  #     fi'';
  # };
}
