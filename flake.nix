{
  description = "Development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem(system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      shell = pkgs.mkShell {
        packages = with pkgs; [
          bundler
          graphviz
          libyaml
          postgresql
          ruby
        ];
      };
      lib = pkgs.lib;
      id = lib.last (lib.strings.splitString "/" "${shell}");
    in {
      devShells.default = pkgs.mkShell {
        packages = shell.drvAttrs.nativeBuildInputs;
        shellHook = ''
          export BUNDLE_PATH=.bundle/${id}
        '';
      };
    }
  );
}
