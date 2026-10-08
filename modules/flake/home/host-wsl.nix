# Home-Manager host: WSL.
#
# Per-host bits for the WSL workstation. Sets identity, repo path, and the
# WSL-specific PATH/PIP_EXTRA_INDEX_URL plumbing for accessing internal
# Azure DevOps package feeds.
#
# Pairs with modules/flake/hosts/wsl.nix which builds the actual
# homeConfiguration entry from base + workstation-user + this host module.
{
  flake.modules.homeManager.host-wsl =
    { pkgs, ... }:
    {
      home = {
        username = "clausormann";
        homeDirectory = "/home/clausormann";
      };

      my.repoPath = "/home/clausormann/dotfiles";

      # WSL leaves extraRuntimePackages empty: prebuilt plugin binaries can
      # link against system glibc on WSL/Ubuntu, unlike NixOS where the
      # wrapped nvim's PATH must carry gcc/cargo/etc. for plugin builds.
      my.editor.neovim.extraRuntimePackages = with pkgs; [
        nodejs
        bash-language-server
        clang-tools
        lua-language-server
      ];

      targets.genericLinux.enable = true;
    };
}
