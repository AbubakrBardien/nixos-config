# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the Grub boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev"; # "nodev" Tells Grub to install for EFI mode
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true; # Automatically detects other OS's
  boot.loader.grub.extraEntries = ''
    menuentry "Arch Linux" {
      insmod part_gpt
      insmod fat
      insmod ext2
      set root=(hd0,gpt5)
      linux /vmlinuz-linux root=/dev/nvme0n1p6 rw loglevel=4
      initrd /initramfs-linux.img
    }
  '';
  boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
    pname = "distro-grub-themes-nixos";
    version = "3.1";
    src = pkgs.fetchFromGitHub {
      owner = "AdisonCavani";
      repo = "distro-grub-themes";
      rev = "v3.1";
      hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
    };
    nativeBuildInputs = [ pkgs.gnutar ];
    installPhase = ''
      mkdir -p $out
      # Unpack the nested nixos.tar file into $out where GRUB expects theme.txt
      tar -xf themes/nixos.tar -C $out
    '';
  };

  boot.supportedFilesystems = [ "ntfs" ]; # Enable kernel support for NTFS

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.dunst.enable = true;
  services.udisks2.enable = true; # udiskie

  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = false; # runs the login screen on X11
  #   settings = {
  #     Input = {
  #       EnabledLibinput = true;
  #     };
  #     Touchscreen = {
  #       Enable = true;
  #     };
  #   };
  # };

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # Enables the Intel Thermal Daemon service
  services.thermald.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abubakr = {
    isNormalUser = true;
    description = "Abubakr";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    home = "/home/abubakr";
    packages = with pkgs; [
      adapta-gtk-theme
      arc-theme
      awww
      bat-extras.core
      brave
      brillo      
      #carapace # Needed for Nushell for auto-completions
      catt
      cava
      cbonsai
      cmatrix
      cowsay
      deno # check if this is still needed
      duf
      dust
      #exodus # use PWA
      fastfetch
      fd
      ffsubsync # check if this is still needed 
      figlet
      ghostty
      gimp
      git
      git-filter-repo
      gotop
      gping
      gthumb
      handlr-regex
      htop
      hyperfine
      hypridle # consider removing if switching away from Hyprland
      hyprlock # consider removing if switching away from Hyprland
      hyprshot
      jp2a
      kdePackages.breeze-gtk
      qt6Packages.qtstyleplugin-kvantum
      #libsForQt5.qtstyleplugin-kvantum
      ldns # check if this is still needed 
      lolcat
      lsd
      lutris
      mediainfo
      mpv
      nemo
      networkmanagerapplet
      noto-fonts-emoji-blob-bin
      nushell
      nwg-look
      obsidian
      onlyoffice-desktopeditors
      papirus-icon-theme
      pavucontrol
      pcloud
      piper
      pipes
      proton-vpn      
      protonup-qt
      qalculate-gtk
      qbittorrent
      rofi
      sbctl
      serve
      showmethekey
      sl
      starship
      
      # Wrap python3 to expose the subliminal CLI binary:
      (python3.withPackages (ps: [ ps.subliminal ]))
      
      surfraw
      tealdeer
      thunderbird
      timg
      tokei
      tree      
      vesktop
      waybar
      wlr-randr # Keep if you switch away from hyprland
      wofi
      xdg-ninja
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Allows downloaded binaries to run on NixOS (Needed for Mason)
  programs.nix-ld.enable = true; 

  programs.steam.enable = true;
  programs.zsh.enable = true;
  programs.kdeconnect.enable = true;
  programs.obs-studio.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    acpi
    alsa-utils
    gcc # or clang (needed for treesitter, and C/C++ user-projects in general)
    inotify-tools
    #intel-ucode
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    wireplumber
    stow
  ];

fonts.packages = with pkgs; [
  corefonts # Times New Roman, Arial, Courier New, etc.
];

# Enable XDG Portals (Required for Hyprland to launch screens/workspaces properly)
xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
};

# Waylend environment variables (Crucial if you have dual GPUs or NVIDIA)
environment.sessionVariables = {
  # Hints electron apps to use Wayland
  NIXOS_OZONE_WL = "1";

  # Enable hardware acceleration / GPU rendering on Wayland
  WLR_NO_HARDWARE_CURSORS = "1";

  XDG_CURRENT_DESKTOP = "Hyprland";
  XDG_SESSION_TYPE = "wayland";
  XDG_SESSION_DESKTOP = "Hyprland";
};

#hardware.nvidia.modesetting.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
  
  # Swapfile Configuration
  swapDevices = [ { device = "/swapfile"; } ];
  
  # Hibernattion Settings
  boot.resumeDevice = "/dev/nvme0n1p7";

# 1. Enable Polkit in system configuration
security.polkit.enable = true;

# 2. Automatically start the GNOME Polkit agent on login
systemd.user.services.polkit-gnome-authentication-agent-1 = {
  description = "polkit-gnome-authentication-agent-1";
  wantedBy = [ "graphical-session.target" ];
  wants = [ "graphical-session.target" ];
  after = [ "graphical-session.target" ];
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    Restart = "on-failure";
    RestartSec = 1;
    TimeoutStopSec = 10;
  };
};

  # Enable unfree packages (SOF includes redistributable binary blobs)
  nixpkgs.config.allowUnfree = true;
  
  # Install extra hardware firmware (includes sof-firmware)
  hardware.enableAllFirmware = true;
  
  hardware.cpu.intel.updateMicrocode = true;

}

