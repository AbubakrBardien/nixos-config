# Neovim and the tooling it relies on
{ pkgs, globals, ... }:
{
    environment.sessionVariables.EDITOR = "nvim";

    users.users.${globals.username}.packages = [
        # Neovim bundled with pre-compiled Tree-sitter parsers
        (pkgs.neovim.override {
            configure = {
                customRC = ''
                    " Preserve Nix-provided plugins (like nvim-treesitter with all grammars) in runtimepath
                    let g:nix_rtp = &runtimepath

                    " Add user init.lua config path
                    let config_dir = expand('~/.config/nvim')
                    if isdirectory(config_dir)
                      let &runtimepath = config_dir . ',' . &runtimepath . ',' . g:nix_rtp . ',' . config_dir . '/after'
                      source ~/.config/nvim/init.lua
                    endif
                '';
                packages.myPlugins = {
                    start = [
                        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
                    ];
                };
            };
        })
        pkgs.ripgrep # this or similar tool required by telescope.nvim
        pkgs.gcc # or clang (needed for treesitter, and C/C++ user-projects in general)
        pkgs.tree-sitter

		/*nixfmt:disable*/

        # Language Servers
        pkgs.lua-language-server  # Lua
        pkgs.clang-tools          # C/C++ # includes clangd and clang-format 
        pkgs.bash-language-server # Bash
        pkgs.pyright              # Python
        pkgs.nil                  # Nix

        # Linters
        pkgs.shellcheck # Bash
        pkgs.statix     # Nix

        # Formatters
        pkgs.shfmt  # Bash
        pkgs.stylua # Lua
        pkgs.nixfmt # Nix

        /*nixfmt:enable*/	

        # Debug Adapters
        pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter # C/C++ (codelldb)

        # Python: debugpy is the Neovim debug adapter; the rest are for general use.
        # Kept as ONE environment so only one `python3` ends up on PATH.
        (pkgs.python3.withPackages (ps: [
            ps.debugpy
            ps.subliminal
            ps.argcomplete
        ]))
    ];
}
