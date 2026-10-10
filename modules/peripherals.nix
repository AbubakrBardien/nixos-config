{ pkgs, globals, ... }:
{
    # Gaming Mouse Configuration Daemon
    services.ratbagd.enable = true;

    # GTK frontend for "ratbagd"
    users.users.${globals.username}.packages = [ pkgs.piper ];
}
