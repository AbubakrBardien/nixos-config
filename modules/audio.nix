{ pkgs, globals, ... }:
{
    services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa = {
            enable = true; # Needed for Wine/Proton games
            support32Bit = true; # Audio Support for 32-bit games
        };
    };

    # GTK app for Volume Control
    users.users.${globals.username}.packages = [ pkgs.pavucontrol ];
}
