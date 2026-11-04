/*nixfmt:disable*/
{ lib, pkgs, globals, ... }:
/*nixfmt:enable*/
let
    # Sets PATH and HOME (udev provides neither), then runs the stowed script.
    batteryWrapper = pkgs.writeShellScript "battery-popup-udev" ''
        exec >>/tmp/battery-popup.log 2>&1   # temporary, for debugging
        set -x

        export PATH=${
            lib.makeBinPath [
                pkgs.bash
                pkgs.coreutils
                pkgs.dunst
            ]
        }:$PATH
        export HOME=/home/${globals.username}
        exec ${globals.scripts}/battery_popup_charging.sh "$1"
    '';

    runAsUser =
        state: "${pkgs.util-linux}/bin/runuser -u ${globals.username} -- ${batteryWrapper} ${state}";
in
{
    services.udev.extraRules = ''
        SUBSYSTEM=="power_supply", KERNEL=="AC0", ACTION=="change", ATTR{online}=="1", RUN+="${runAsUser "1"}"
        SUBSYSTEM=="power_supply", KERNEL=="AC0", ACTION=="change", ATTR{online}=="0", RUN+="${runAsUser "0"}"
    '';

    environment.systemPackages = [ pkgs.acpi ]; # dunst is already installed using "background-services.nix"
}
