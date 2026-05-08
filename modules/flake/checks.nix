# perSystem.checks — gates every commit during the dendritic migration.
# Currently runs nixfmt (RFC-style) in check mode across the repo's .nix files.
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks.nixfmt = pkgs.runCommand "nixfmt-check" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
        cd ${inputs.self}
        nixfmt --check $(find . -name '*.nix' -not -path './.*')
        touch $out
      '';
    };
}
