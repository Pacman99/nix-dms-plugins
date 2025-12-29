{
  outputs = { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
    in
    {
      checks = self.packages;
      packages = lib.genAttrs systems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in import ./default.nix { inherit pkgs; }
      );
    };
}
