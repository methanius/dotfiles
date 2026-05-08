{ config, ... }:
{
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
}
