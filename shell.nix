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

  coder = runCommand "coder" {
    pinned = builtins.fetchTarball {
      name = "coder";
      url = https://github.com/luizdepra/hugo-coder/archive/dbe21a7fdf0d5556de5b2f2f8bdf4f64228ca241.tar.gz;
      sha256 = "076l5vwqh2kkrcqkpbnx3lwx5qy3kn5iz8xnc2f90pxp66zn1sdg";
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
    ln -snf "${coder}" themes/coder
  '';
}
