# Standalone Home-Manager configuration for the WSL host.
#
# This is the single source of truth for "who runs HM on WSL and where their
# repo lives". Adding a second standalone HM host is a matter of dropping a
# new file under modules/flake/hosts/ following this same shape; see
# _example.nix.disabled for a template.
{
  self,
  config,
  inputs,
  withSystem,
  ...
}:
{
  flake.homeConfigurations."clausormann@wsl" = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        config.flake.modules.homeManager.base
        config.flake.modules.homeManager.workstation-user
        ../../../hosts/wsl/home.nix
        {
          home = {
            username = "clausormann";
            homeDirectory = "/home/clausormann";
          };
          my.repoPath = "/home/clausormann/dotfiles";
          my.editor.neovim.extraRuntimePackages = with pkgs; [
            gcc
            gnumake
            cargo
            rustc
            nodejs
            bash-language-server
            clang-tools
            lua-language-server
          ];
        }
      ];
    }
  );
}
