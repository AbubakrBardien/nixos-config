{ config, globals, ... }:

let
    systemPkgCount = builtins.toString (builtins.length config.environment.systemPackages);
    userPkgCount = builtins.toString (builtins.length config.users.users.${globals.username}.packages);
in
{
    system.activationScripts.pkgCount.text = ''
        echo "${systemPkgCount} (system), ${userPkgCount} (user)" > /var/cache/nix-pkg-count
        chmod 644 /var/cache/nix-pkg-count
    '';
}
