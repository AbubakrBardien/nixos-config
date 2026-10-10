{ pkgs, globals, ... }:
{
    programs.zsh = {
        enable = true;
        histFile = "${globals.xdg.dataHome}/zsh/history";
    };

    environment.sessionVariables = {
        ZDOTDIR = "${globals.xdg.configHome}/zsh";
        ZINIT_HOME = "${globals.xdg.dataHome}/zinit/zinit.git"; # Directory to store Zinit and Plugins
        STARSHIP_CONFIG = "${globals.xdg.configHome}/starship/starship.toml";
    };

    users.users.${globals.username}.packages = [
        pkgs.nushell
        pkgs.starship
        #pkgs.carapace # Needed for Nushell for auto-completions
    ];
}
