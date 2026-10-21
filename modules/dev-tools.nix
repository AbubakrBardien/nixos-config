# Neovim and the tooling it relies on
# Global Dev Tools
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
        pkgs.tree-sitter

		/*nixfmt:disable*/

        # Language Servers
        pkgs.lua-language-server  # Lua
        pkgs.bash-language-server # Bash
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
    ];
}
