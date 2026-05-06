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

    initContent = ''
              source "''${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/wezterm.sh"
              autoload -Uz add-zsh-hook

      # Resolve an entered command to its first external/alias target (best-effort)
              _wezterm_resolve_cmd() {
                emulate -L zsh
                setopt extendedglob

                local cmd="$1"
                local exp
                local -a w
                local i=0

                # Resolve alias chains up to a small limit to avoid loops
                while (( i < 10 )); do
                  (( i++ ))

                  # If it's an alias, expand to the alias value and take its first word
                  if [[ -n "''${aliases[$cmd]-}" ]]; then
                    exp="''${aliases[$cmd]}"
                    w=(''${(z)exp})
                    cmd="''${w[1]}"
                    continue
                  fi

                  break
                done

                print -r -- "$cmd"
              }

              _wezterm_prog_preexec() {
                emulate -L zsh
                local cmdline="$1"
                local -a words
                words=(''${(z)cmdline})
                local cmd="''${words[1]}"

                # Resolve aliases like vi/vim -> nvim
                cmd="$(_wezterm_resolve_cmd "$cmd")"

                __wezterm_set_user_var "WEZTERM_PROG" "$cmd"
              }

              add-zsh-hook preexec _wezterm_prog_preexec
    '';
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
