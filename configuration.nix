{ ... }:
{
    _module.args.globals = import ./global-variables.nix;

    imports = [
        ./hardware-configuration.nix
        ./modules/apps.nix
        ./modules/audio.nix
        ./modules/background-services.nix
        ./modules/boot.nix
        ./modules/cli-tools.nix
        ./modules/dev-tools.nix
        ./modules/env-xdg.nix
        ./modules/hibernate.nix
        ./modules/login-manager.nix
        ./modules/networking.nix
        ./modules/peripherals.nix
        ./modules/shell-config.nix
        ./modules/theming.nix
        ./modules/users.nix
        ./modules/wayland-compositor.nix
        ./modules/extras/count-packages.nix
        ./modules/extras/dual-boot.nix
    ];

    time.timeZone = "Africa/Johannesburg";
    i18n.defaultLocale = "en_US.UTF-8";
    nixpkgs.config.allowUnfree = true; # Enable unfree packages (SOF includes redistributable binary blobs)

    # NEVER change this value after the initial install, for any reason.
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from
    system.stateVersion = "26.05";
}
