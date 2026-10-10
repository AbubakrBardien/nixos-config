{ pkgs, globals, ... }:

let
    terminalApp =
        {
            name,
            desktopName,
            exec,
        }:
        pkgs.makeDesktopItem {
            inherit name desktopName exec;
            terminal = true;
            icon = "com.mitchellh.ghostty";
        };
in
{
    environment.systemPackages = [
        pkgs.git
        pkgs.vim # For fixing things as root
    ];

    users.users.${globals.username}.packages = [
        pkgs.acpi # Needed in my battery pop-up script
        pkgs.awww # Wallpaper Setter
        pkgs.bat # better "cat" display
        pkgs.bat-extras.core
        pkgs.cowsay
        pkgs.delta # better "git diff" display
        pkgs.duf # display Disk Space
        pkgs.dust # disk Usage Viewer
        pkgs.fastfetch
        pkgs.fd # better "find" command
        pkgs.ffsubsync # needed my MPV plugin: "autosubsync"
        pkgs.figlet
        pkgs.git
        pkgs.git-filter-repo
        pkgs.htop
        pkgs.hyperfine # very useful benchmarking tool
        pkgs.hyprshot # Screenshot Tool
        pkgs.jp2a # convert JPEG, PNG and WebP images to ASCII
        pkgs.lolcat
        pkgs.lsd # better "ls" display
        pkgs.serve # used to run my Browser Startpage
        pkgs.sl
        pkgs.stow
        pkgs.tealdeer # A very fast implementation of "tldr" in Rust
        pkgs.timg # A terminal image and video viewer
        pkgs.tokei # Fast Code Counting tool
        pkgs.trash-cli
        pkgs.unzip
        pkgs.wlr-randr # Keep if you switch away from hyprland
        pkgs.xdg-ninja
        # pkgs.carapace # Needed for Nushell for auto-completions

        # Terminal Apps, with Desktop Entries generated below
        pkgs.cava
        pkgs.cbonsai
        pkgs.cmatrix
        pkgs.gotop
        pkgs.pipes
    ]
    ++ map terminalApp [
		/*nixfmt:disable*/
        { name = "cava";    desktopName = "Cava";    exec = "cava"; }
        { name = "cbonsai"; desktopName = "CBonsai"; exec = "cbonsai -li"; }
        { name = "cmatrix"; desktopName = "CMatrix"; exec = "cmatrix -b"; }
        { name = "gotop";   desktopName = "GoTop";   exec = "gotop"; }
        { name = "pipes";   desktopName = "Pipes";   exec = "pipes.sh"; }
		/*nixfmt:enable*/
    ];
}
