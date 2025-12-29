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
          plugins = builtins.fromJSON (builtins.readFile ./plugins-prefetch.json);
        in lib.mapAttrs (name: plugin:
          pkgs.stdenvNoCC.mkDerivation {
            name = plugin.meta.id;
            src = pkgs.fetchgit {
              inherit (plugin) url rev hash;
            };

            preferLocalBuild = true;
            allowSubstitutes = false;
            installPhase = ''
              mkdir -p $out
              cp -r ./${plugin.meta.path or "./"}/* $out
            '';
            meta = {
              inherit (plugin.meta) description;
              homepage = plugin.meta.repo;
              platforms = lib.platforms.all;
            };
          }) plugins
      );
    };
}
