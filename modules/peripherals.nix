{ pkgs, globals, ... }:
{
    # Gaming Mouse Configuration Daemon
    services.ratbagd.enable = true;

    # GTK frontend for "ratbagd"
    users.users.${globals.username}.packages = [ pkgs.piper ];

    # Explicitly set Mouse DPI to 1000
    systemd.services.mouse-dpi = {
        description = "Set G502 X DPI";
        wantedBy = [
            "multi-user.target"
            "post-resume.target"
        ];
        after = [
            "ratbagd.service"
            "post-resume.target"
        ];
        requires = [ "ratbagd.service" ];
        serviceConfig.Type = "oneshot";
        script = ''
            ${pkgs.libratbag}/bin/ratbagctl "$(${pkgs.libratbag}/bin/ratbagctl list | head -n1 | cut -d: -f1)" dpi set 1000
        '';
    };
}
