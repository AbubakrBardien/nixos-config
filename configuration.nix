# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
    config,
    lib,
    pkgs,
    ...
}:
{
    imports = [
        ./hardware-configuration.nix # Include the results of the hardware scan
        ./count-packages.nix
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
        extraGroups = [
            "wheel"
            "networkmanager"
        ]; # Enable ‘sudo’ for the user.
        shell = pkgs.zsh;
        home = "/home/abubakr";
        packages = with pkgs; [
            # Neovim bundled with pre-compiled Tree-sitter parsers
            (neovim.override {
                configure = {
                    customRC = ''
                        " Preserve Nix-provided plugins (like nvim-treesitter with all grammars) in runtimepath
                        let g:nix_rtp = &runtimepath

                        " Add user init.lua config path
                        let config_dir = expand('~/.config/nvim')
                        if isdirectory(config_dir)
                          let &runtimepath = config_dir . ',' . &runtimepath . ',' . g:nix_rtp . ',' . config_dir . '/after'
                          source ~/.config/nvim/init.lua
                        endif
                    '';
                    packages.myPlugins = {
                        start = [
                            pkgs.vimPlugins.nvim-treesitter.withAllGrammars
                        ];
                    };
                };
            })
            ripgrep # this or similar tool required by telescope.nvim

            # Language Servers

            /*nixfmt:disable*/
            lua-language-server  # Lua
            clang-tools          # C/C++ # includes clangd and clang-format 
            bash-language-server # Bash
            pyright              # Python
            nil                  # Nix

            # Linters
            shellcheck # Bash
            statix     # Nix

            # Formatters
            shfmt  # Bash
            stylua # Lua
            nixfmt # Nix

            # Debug Adapters
            vscode-extensions.vadimcn.vscode-lldb.adapter # C/C++ # codelldb
            # Python's debugger listed later in this file
            /*nixfmt:enable*/

            adapta-gtk-theme
            arc-theme
            awww
            bat
            bat-extras.core
            brave
            brillo
            #carapace # Needed for Nushell for auto-completions
            catt
            cava
            cbonsai
            cmatrix
            cowsay
            delta
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

            (python3.withPackages (ps: [
                ps.debugpy # Python Debugger, needed for Neovim
                ps.subliminal
                ps.argcomplete
            ]))

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

    programs.steam.enable = true;

    programs.zsh = {
        enable = true;
        histFile = "$XDG_DATA_HOME/zsh/history";
    };

    programs.kdeconnect.enable = true;
    programs.obs-studio.enable = true;

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [
        acpi
        alsa-utils
        gcc # or clang (needed for treesitter, and C/C++ user-projects in general)
        tree-sitter
        inotify-tools
        #intel-ucode
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        wireplumber
        stow

        (makeDesktopItem {
            name = "cava";
            desktopName = "Cava";
            exec = "cava";
            terminal = true;
            icon = "ghostty";
        })

        (makeDesktopItem {
            name = "cbonsai";
            desktopName = "CBonsai";
            exec = "cbonsai -li";
            terminal = true;
            icon = "ghostty";
        })

        (makeDesktopItem {
            name = "cmatrix";
            desktopName = "CMatrix";
            exec = "cmatrix -b";
            terminal = true;
            icon = "ghostty";
        })

        (makeDesktopItem {
            name = "gotop";
            desktopName = "GoTop";
            exec = "gotop";
            terminal = true;
            icon = "ghostty";
        })

        (makeDesktopItem {
            name = "pipes";
            desktopName = "Pipes";
            exec = "pipes.sh";
            terminal = true;
            icon = "ghostty";
        })
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
    environment.sessionVariables = rec {
        ##########################
        ## XDG Base Directories ##
        ##########################

        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";

        #############################################
        ## Moving Files/Folders based on XDG Specs ##
        #############################################

        ## Python Files
        IPYTHONDIR = "${XDG_CONFIG_HOME}/ipython";
        PYTHON_HISTORY = "${XDG_STATE_HOME}/python_history";

        ## Rust Files
        CARGO_HOME = "${XDG_DATA_HOME}/cargo";
        RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
        RUST_TOOLCHAINS = "${RUSTUP_HOME}/toolchains/stable-x86_64-unknown-linux-gnu/bin";

        ## Java Files
        GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
        _JAVA_OPTIONS = "-Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx -Dswt.library.path=${XDG_CACHE_HOME}/swt";

        ## .NET Core Files
        DOTNET_CLI_HOME = "${XDG_DATA_HOME}/dotnet";
        NUGET_PACKAGES = "${XDG_CACHE_HOME}/NuGetPackages";

        ## Other Files
        CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
        GOPATH = "${XDG_DATA_HOME}/go";
        JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";
        NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
        PARALLEL_HOME = "${XDG_CONFIG_HOME}/parallel";
        PASSWORD_STORE_DIR = "${XDG_DATA_HOME}/pass";
        W3M_DIR = "${XDG_STATE_HOME}/w3m";
        GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
        STARSHIP_CONFIG = "${XDG_CONFIG_HOME}/starship/starship.toml";
        CAROOT = "${XDG_DATA_HOME}/certs";
        LINKS_CFG_ANON = "${XDG_CONFIG_HOME}/links";

        #############
        ## Z Shell ##
        #############

        ZDOTDIR = "$HOME/.config/zsh";
        ZINIT_HOME = "${XDG_DATA_HOME}/zinit/zinit.git"; # Set the directory to store Zinit and Plugins

        ####################################
        ## My Other Environment Variables ##
        ####################################

        SCRIPTS = "${XDG_DATA_HOME}/my_scripts";

        ## Default CLI Programs
        EDITOR = "nvim";
        #export AUR_HELPER="paru"

        ###########
        ## Other ##
        ###########

        TRASHDIR = "${XDG_DATA_HOME}/Trash";
        SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/keyring/ssh";

        ###############
        ## Graphical ##
        ###############

        BROWSER = "brave";

        ###################################
        ## Graphics Driver Configuration ##
        ###################################

        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";

        ##########################
        ## Cursor Configuration ##
        ##########################

        XCURSOR_SIZE = "24";
        HYPRCURSOR_SIZE = "24";

        ###########
        ## Other ##
        ###########

        QT_STYLE_OVERRIDE = "kvantum";

        # Hints electron apps to use Wayland
        NIXOS_OZONE_WL = "1";

        # Enable hardware acceleration / GPU rendering on Wayland
        WLR_NO_HARDWARE_CURSORS = "1";

        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";

        PATH = [
            "${CARGO_HOME}/bin"
            "${RUST_TOOLCHAINS}"
            "$HOME/.local/bin"
            "${SCRIPTS}"
            "${SCRIPTS}/count_packages"
            "${SCRIPTS}/hide_apps"
            "${XDG_DATA_HOME}/npm/bin"
        ];
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

    ## Hibernattion Settings

    # Swapfile Configuration
    swapDevices = [
        {
            device = "/swapfile";
            size = 10 * 1024; # Size in MB (10GB = 10240)
        }
    ];

    boot.resumeDevice = "/dev/nvme0n1p7";
    boot.kernelParams = [ "resume_offset=34816" ];

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
    hardware.brillo.enable = true;

    nix.settings."use-xdg-base-directories" = true;
}
