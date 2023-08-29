{ config, pkgs, ... }:

{
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
  home.activation = {
    linkDesktopApplications = {
      after = [ "writeBoundary" "createXdgUserDirectories" ];
      before = [ ];
      data = ''
        rm -rf ${config.xdg.dataHome}/"applications/home-manager"
        mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
        cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
      '';
    };
  };
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
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    calibre # ebook management
    chromium # in case firefox doesn't work
    # emacs # yes
    (emacs.override {
      withXwidgets = true;
      withPgtk = true;
    })
    dropbox-cli
    fira-code # font with ligatures
    firefox
    fd # find
    gcc # cpp compiler
    git # version contol
    gimp # image editor
    glslang
    gnumake
    gnupg # encryption
    gnome.gnome-settings-daemon
    gnome.gnome-themes-extra
    graphviz # graphs (org roam)
    httpie
    hugo # website engine
    hunspell # spel check for libreoffice
    imagemagick
    isync # email syncing
    isort
    ispell
    jdk11 # Java
    julia # language
    ledger # money management
    libreoffice-qt # word processor, calc, presentations, etc
    libtool
    maim # screenshots
    multimarkdown
    mu # email viewer
    nerdfonts
    nixfmt
    nodejs
    nodejs
    obs-studio # screen recording
    pass # password manager
    passff-host # bridge to pass firefox
    (pcmanfm.override { withGtk3 = true; }) # file browser
    pinentry # ask for passwords graphically
    pueue # process queue
    playerctl
    python310
    ripgrep # Doom emacs dep
    shellcheck # sh
    shfmt # sh
    sioyek # pdf viewer focused on research
    scrot
    slock
    spotify # music
    sqlite # Doom emacs dep (lookup)
    texlive.combined.scheme-full # LaTeX
    tlp
    upower
    vlc # Video/Audio player
    vim # fallback text editor
    wineWowPackages.stable # Wine 32 n 64 bit
    wordnet # Doom emacs dep (lookup)
    xclip
    wget
    wl-clipboard # for images in emacs
  ];

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
  home.sessionVariables = { EDITOR = "emacs"; };

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

      if test -f $HOME/.config/fish/config.base.fish;
      then
        source $HOME/.config/fish/config.base.fish
      fi
    '';
  };
  programs.zsh = {
    enable = true;
    initExtra = ''

      if [ -f $HOME/.config/zsh/.zshrc ];
      then
        source $HOME/.config/zsh/.zshrc
      fi'';
  };
}
