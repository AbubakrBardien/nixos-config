{ pkgs, globals, ... }:
{
    networking = {
        hostName = "nixos";
        networkmanager.enable = true; # Enables nmcli and nmtui
        firewall.enable = true;
    };

    users.users.${globals.username} = {
        packages = [ pkgs.networkmanagerapplet ]; # GUI for network management
        extraGroups = [ "networkmanager" ];
    };
}
