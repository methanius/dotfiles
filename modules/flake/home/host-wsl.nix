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
    { config, ... }:
    {
      home = {
        username = "clausormann";
        homeDirectory = "/home/clausormann";
      };

      my.repoPath = "/home/clausormann/dotfiles";

      # WSL leaves extraRuntimePackages empty: prebuilt plugin binaries can
      # link against system glibc on WSL/Ubuntu, unlike NixOS where the
      # wrapped nvim's PATH must carry gcc/cargo/etc. for plugin builds.
      my.editor.neovim.extraRuntimePackages = [ ];

      targets.genericLinux.enable = true;

      programs.zsh.envExtra = ''
        path+=('${config.home.homeDirectory}/.local/bin')
        export PATH
        if [ -f ~/pip-token-mftus ]; then
            for TOKEN in $(cat ~/pip-token-mftus)
            do
                export PIP_EXTRA_INDEX_URL="https://$TOKEN@pkgs.dev.azure.com/mft-energy/MFTUS/_packaging/mft-us-pip/pypi/simple/ https://$TOKEN@pkgs.dev.azure.com/mft-energy/_packaging/mft-energy-pip/pypi/simple/"
                export UV_INDEX="https://$TOKEN@pkgs.dev.azure.com/mft-energy/MFTUS/_packaging/mft-us-pip/pypi/simple/ https://$TOKEN@pkgs.dev.azure.com/mft-energy/_packaging/mft-energy-pip/pypi/simple/"
            done
        fi
      '';
    };
}
