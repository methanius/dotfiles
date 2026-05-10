# I am a big fan of proton. Here I'm configuring proton pass
{
  flake.modules.homeManager.workstation-user = {
    pkgs,
    config,
    ...
  }: {
    home.packages = [pkgs.proton-pass pkgs.proton-pass-cli];
  };
}
