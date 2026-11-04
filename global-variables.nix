let
    xdg = {
        configHome = "$HOME/.config";
        cacheHome = "$HOME/.cache";
        dataHome = "$HOME/.local/share";
        stateHome = "$HOME/.local/state";
    };
in
{
    username = "abubakr";

    inherit xdg;

    scripts = "${xdg.dataHome}/custom_scripts";
}
