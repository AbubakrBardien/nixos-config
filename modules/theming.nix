# GTK/Qt themes, icons, cursors, fonts, gsettings
{ pkgs, ... }:
{
    # Enable Qt module integration
    qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
    };

    gtk.iconCache.enable = true; # Automatic update of the desktop icon cache

    # Required for GTK/gsettings changes to persist and take effect on Wayland
    programs.dconf.enable = true;

    # Link GSettings schemas and desktop themes globally
    environment.pathsToLink = [
        "/share/gsettings-schemas"
        "/share/icons"
        "/share/themes"
    ];

    fonts.packages = [
        pkgs.corefonts # Times New Roman, Arial, Courier New, etc.
        pkgs.inter # GUI Font
        pkgs.nerd-fonts.jetbrains-mono # Terminal Font
    ];

    environment = {
        sessionVariables = {
            XCURSOR_SIZE = "24";
            HYPRCURSOR_SIZE = "24";
            XCURSOR_THEME = "Adwaita";
            HYPRCURSOR_THEME = "Adwaita";

            GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
        };
        systemPackages = [
            /*nixfmt:disable*/
            pkgs.glib                      # Provides gsettings CLI
            pkgs.gsettings-desktop-schemas # Provides org.gnome.desktop.interface schemas
            pkgs.arc-theme                 # Provides Arc-Dark GTK theme
            pkgs.papirus-icon-theme        # Provides Papirus-Dark icons
            pkgs.libsForQt5.qtstyleplugins # GTK style plugin for Qt
            /*nixfmt:enable*/

            pkgs.noto-fonts-emoji-blob-bin
            pkgs.adapta-gtk-theme
            pkgs.kdePackages.breeze-gtk
        ];
    };
}
