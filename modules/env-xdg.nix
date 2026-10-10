# XDG base directories, and tools moved to follow them

{ globals, ... }:

let
    cargoHome = "${globals.xdg.dataHome}/cargo";
    rustupHome = "${globals.xdg.dataHome}/rustup";
    rustToolchains = "${rustupHome}/toolchains/stable-x86_64-unknown-linux-gnu/bin";
    scripts = "${globals.xdg.dataHome}/custom_scripts";
in
{
    nix.settings."use-xdg-base-directories" = true;

    environment.sessionVariables = {
        ##########################
        ## XDG Base Directories ##
        ##########################

        XDG_CONFIG_HOME = globals.xdg.configHome;
        XDG_DATA_HOME = globals.xdg.dataHome;
        XDG_CACHE_HOME = globals.xdg.cacheHome;
        XDG_STATE_HOME = globals.xdg.stateHome;

        #############################################
        ## Moving Files/Folders based on XDG Specs ##
        #############################################

        ## Python Files
        IPYTHONDIR = "${globals.xdg.configHome}/ipython";
        PYTHON_HISTORY = "${globals.xdg.stateHome}/python_history";

        ## Rust Files
        CARGO_HOME = "${cargoHome}";
        RUSTUP_HOME = "${rustupHome}";
        RUST_TOOLCHAINS = "${rustToolchains}";

        ## Java Files
        GRADLE_USER_HOME = "${globals.xdg.dataHome}/gradle";
        _JAVA_OPTIONS = "-Djavafx.cachedir=${globals.xdg.cacheHome}/openjfx -Dswt.library.path=${globals.xdg.cacheHome}/swt";

        ## .NET Core Files
        DOTNET_CLI_HOME = "${globals.xdg.dataHome}/dotnet";
        NUGET_PACKAGES = "${globals.xdg.cacheHome}/NuGetPackages";

        ## Other Files
        /*nixfmt:disable*/
        JUPYTER_CONFIG_DIR =    "${globals.xdg.configHome}/jupyter";
        LINKS_CFG_ANON =        "${globals.xdg.configHome}/links";
        NPM_CONFIG_USERCONFIG = "${globals.xdg.configHome}/npm/npmrc";
        PARALLEL_HOME =         "${globals.xdg.configHome}/parallel";
        CAROOT =                "${globals.xdg.dataHome}/certs";
        GNUPGHOME =             "${globals.xdg.dataHome}/gnupg";
        GOPATH =                "${globals.xdg.dataHome}/go";
        PASSWORD_STORE_DIR =    "${globals.xdg.dataHome}/pass";
        CUDA_CACHE_PATH =       "${globals.xdg.cacheHome}/nv";
        W3M_DIR =               "${globals.xdg.stateHome}/w3m";
        /*nixfmt:enable*/

        ###########
        ## Other ##
        ###########

        SCRIPTS = "${scripts}";
        TRASHDIR = "${globals.xdg.dataHome}/Trash";
        SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/keyring/ssh";

        PATH = [
            "${cargoHome}/bin"
            "${rustToolchains}"
            "$HOME/.local/bin"
            "${scripts}"
            "${scripts}/count_packages"
            "${scripts}/hide_apps"
            "${globals.xdg.dataHome}/npm/bin"
        ];
    };
}
