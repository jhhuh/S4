{

  inputs = {
    haedosa.url = "github:haedosa/flakes/22.05";
    nixpkgs.follows = "haedosa/nixpkgs";
    flake-utils.follows = "haedosa/flake-utils";
  };

  outputs = input@{self, nixpkgs, flake-utils, ...} :
    {
      overlay = final: prev: {
        s4 = final.callPackage ./default.nix {};
      };
    }
    //
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };

      in {

        packages.default = pkgs.s4;
        apps.default = {
          type = "app";
          program = "${pkgs.s4}/bin/S4";
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ lua python3Full openblas ];
        };

      });

}
