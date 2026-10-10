{ pkgs, globals, ... }:

let
    # Custom xdg-open wrapper calling handlr
    custom-xdg-open = pkgs.writeShellScriptBin "xdg-open" ''
        exec ${pkgs.handlr}/bin/handlr open "$@"
    '';
in
{
    programs = {
        kdeconnect.enable = true;
        obs-studio.enable = true;
        steam.enable = true;
    };

    users.users.${globals.username}.packages = [
        custom-xdg-open
        pkgs.handlr-regex

		/*nixfmt:disable*/

		## Default graphical packages
        pkgs.rofi # App Launcher
        pkgs.wofi # App Launcher # currently using this one
        pkgs.waybar # Status Bar

        ## Default Apps
		pkgs.pcloud        # Cloud Storage service
		pkgs.proton-vpn    # VPN
		pkgs.qalculate-gtk # Calculator
		pkgs.qbittorrent   # BitTorrent Client
		pkgs.thunderbird   # Email Client
		pkgs.zathura       # PDF Viewer
	    pkgs.obsidian      # Note Taking App
        pkgs.brave         # Browser
        pkgs.ghostty       # Terminal
        pkgs.gimp          # Image Editor
        pkgs.gthumb        # Image Viewer
        pkgs.mpv           # Video Player
        pkgs.nemo          # File Manager
    	pkgs.onlyoffice-desktopeditors # Office Suite

		/*nixfmt:enable*/
        pkgs.lutris
        pkgs.ppsspp
        pkgs.protonup-qt
        pkgs.showmethekey
        pkgs.hypridle # Is launched in Hyprland dotfiles
    ];

    environment.sessionVariables.BROWSER = "brave";
}
