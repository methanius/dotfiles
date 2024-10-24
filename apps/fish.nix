{pkgs, ...}:
{
    programs.fish = {
        enable = true;
        generateCompletions = true;
        preferAbbrs = true;
        shellAbbrs = { 
            vi = "nvim";
            vim = "nvim";
            gsu = "git submodule update --init --recursive";
            gss = "git submodule sync --recursive";
            cmlb = "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=on;cmake --build build -j15";
            cmlbrel = "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=on -DCMAKE_BUILD_TYPE=Release;cmake --build build -j15";
            cmlbreldeb = "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=on -DCMAKE_BUILD_TYPE=RelWithDebInfo;cmake --build build -j15";
            cat = "bat";
        };
    };
}
