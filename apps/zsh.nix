{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    defaultKeymap = "viins";
    autocd = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 100000;
      share = true;
      size = 100000;
    };
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      ls = "eza";
      cat = "bat";
      gsu = "git submodule update --init --recursive";
      gss = "git submodule sync --recursive";
      cmlb = "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=on;cmake --build build -j15";
      cmlbrel = "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=on -DCMAKE_BUILD_TYPE=Release;cmake --build build -j15";
      cmlbreldeb = "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=on -DCMAKE_BUILD_TYPE=RelWithDebInfo;cmake --build build -j15";
    };
    plugins = [
      {
        name = "zsh-expand";
        src = pkgs.fetchFromGitHub {
          owner = "MenkeTechnologies";
          repo = "zsh-expand";
          rev = "v5.2.0";
          sha256 = "sha256-pcYYTQsh2c57U7kVYgCDMi7Z4lAjncQzapfPpTRgKZI=";
        };
      }
    ];
  };
}
