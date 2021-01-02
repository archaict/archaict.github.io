let

  nixpkgs = builtins.fetchTarball {
    name = "nixpkgs-unstable-2020-01-02";
    url = https://github.com/NixOS/nixpkgs/archive/56bb1b0f7a33e5d487dc2bf2e846794f4dcb4d01.tar.gz;
    sha256 = "1wl5yglgj3ajbf2j4dzgsxmgz7iqydfs514w73fs9a6x253wzjbs";
  };

in

{ pkgs ? import nixpkgs {} }:

with pkgs;

let

  hugo-theme-terminal = runCommand "hugo-theme-terminal" {
    pinned = builtins.fetchTarball {
      name = "hugo-theme-terminal-2020-11-16";
      url = https://github.com/panr/hugo-theme-terminal/archive/c3f51a4c11cf8626316f561002245367d7c4fc37.tar.gz;
      sha256 = "14949wsf05627yxmqrphl5gyv8fggjxizx5xlmvqd7h23cfjk1gs";
    };

    patches = [];

    preferLocalBuild = true;
  }
  ''
    cp -r $pinned $out
    chmod -R u+w $out

    for p in $patches; do
      echo "Applying patch $p"
      patch -d $out -p1 < "$p"
    done
  '';

in

mkShell {
  buildInputs = [
    hugo
  ];

  shellHook = ''
    mkdir -p themes
    ln -snf "${hugo-theme-terminal}" themes/hugo-theme-terminal
  '';
}
