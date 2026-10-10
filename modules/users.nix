# The user account itself
{ pkgs, globals, ... }:
{
    users.users.${globals.username} = {
        isNormalUser = true;
        description = "${globals.username}";
        extraGroups = [ "wheel" ]; # Enable "sudo" for the user.
        shell = pkgs.zsh;
        home = "/home/${globals.username}";
    };
}
