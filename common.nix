# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

with pkgs;

# let
# layout = ./symbols/star_oath;
# in
# rec
{
  imports =
    [ # Include the results of the hardware scan.
      # ./hardware-configuration.nix
    ];


  # networking.hostName = "nixos"; # Define your hostname.
  #  networking.networkmanager.enable = true;

  networking = {
    networkmanager.enable = true;
#    wireless = {
#      enable = true;  # Enables wireless support via wpa_supplicant.
#      interfaces = [ "wlp2s0" ];
#      networks = {
#        "Avenet-5G" = {
#         psk = "ToWhomandWhere?";
#      };
#    };
#  };
};

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # unfree packages
  nixpkgs.config.allowUnfree = true;

# bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # Enable the X11 windowing system.
 #services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  services.xserver.extraLayouts.star_oath = {
  description = "Star oath layout";
  languages   = [ "eng" ];
  symbolsFile = ./symbols/star_oath;
};
 services.xserver = {
    enable = true;   
    displayManager.sddm.enable = true;
    desktopManager = {
  #    default = "plasma5";
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
      # gnome = {
        # enable = true;
      # };
      plasma5 = {
        enable = true;
      };
    };
   # displayManager.sessionCommands = ''
       # ${xorg.xkbcomp}/bin/xkbcomp ${layout} $DISPLAY &
     # '';
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
    displayManager.defaultSession = "plasma";
  };




  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    extraUsers.avery = {
      description = "L. Avery Randall";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    };
  };
programs.nm-applet.enable = true;
programs.zsh = {
  enable = true;
  shellAliases = {
      vim = "nvim";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
  }; 
# Fonts
  fonts = {
    fontDir = {
      enable = true;
    };
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      #corefonts # Microsoft free fonts
      inconsolata # monospaced
      unifont # some international languages
      font-awesome-ttf
      freefont_ttf
      opensans-ttf
      liberation_ttf
      liberationsansnarrow
      ttf_bitstream_vera
      libertine
      ubuntu_font_family
      gentium
      # Good monospace fonts
      jetbrains-mono
      fira-code
      fira-code-symbols
      proggyfonts
      source-code-pro
    ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xorg.xkbcomp
    neovim
    plasma-thunderbolt
    libnotify
    unzip
    fbterm
    minecraft
    spotify
    wget
    firefox
    zotero
    zoom
    evince
    cinnamon.nemo
    git
    gh
    mu
    tmux
    kitty
    emacs
    dropbox-cli
    pandoc
    google-chrome
    oh-my-zsh
    zsh
    texlive.combined.scheme-medium
    xorg.xkill
    aspell
    aspellDicts.en
    killall
    ranger
    nitrogen
    gcc
    autorandr
    nox
    compton
  ];
  # dropbox setup
  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
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
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


}

