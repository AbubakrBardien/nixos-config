{ globals, ... }:
{
    hardware = {
        cpu.intel.updateMicrocode = true;
        enableAllFirmware = true; # Install extra hardware firmware
        brillo.enable = true; # Brightness and Keyboard Backlight control
    };

    services = {
        thermald.enable = true; # Intel Thermal Management Daemon
        udisks2.enable = true;
        libinput.enable = true; # Touchpad support
        dunst.enable = true; # Notification Daemon
        printing.enable = true;
    };

    # Needed for brightness buttons to work
    users.users.${globals.username}.extraGroups = [ "video" ];
}
