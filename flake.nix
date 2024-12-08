{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gnumake
            go
            openstackclient-full

            bashInteractive
          ];
          shellHook = ''
            if [ -r devstack-env.sh ]; then
              . ./devstack-env.sh
            fi

            if [ -r acceptance-tests-env.sh ]; then
              . ./acceptance-tests-env.sh
            fi
          '';
        };
      });
}
