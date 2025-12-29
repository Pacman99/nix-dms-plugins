# Nix DMS Plugins
This flake contains packages for all plugins in the [dms plugin registry](https://github.com/AvengeMedia/dms-plugin-registry).
Plugins automatically are updated daily.

## Installation

### With flakes
Add this project as a flake input:
```nix
{
  inputs = {
    nix-dms-plugins.url = "github:pacman99/nix-dms-plugins";
    nix-dms-plugins.inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Add the NixOS or Home Manager module:
```nix
{
  # Same module for NixOS and Home Manager
  imports = [ inputs.nix-dms-plugins.modules.default ];
}
```

### Without flakes
Fetch this project with `fetchTarball` then import the module.
```nix
{ pkgs, ... }:
let
  nix-dms-plugins = builtins.fetchTarball "https://github.com/pacman99/nix-dms-plugins/archive/main.tar.gz";

  # Only needed if installing packages manually without NixOS/HM module
  nix-dms-plugins-pkgs = import nix-dms-plugins { inherit pkgs; };
in
{
  # Add NixOS/HM module
  imports = [ "${nix-dms-plugins}/module.nix" ]; # Same module path for NixOS and Home Manager
}
```

## Usage
Plugin packages are available as flake package outputs or attributes in `default.nix`.
Instead of using packages directly, the recommended way to use this project is to
import the NixOS or Home Manager module which will add all plugins disabled by default.
Then to use a plugin it just needs to be enabled.

The attribute name for plugins are determined by the `id` property in the plugin registry.
The `id` is the last portion of the url of the "Install" button in the [plugin store](https://danklinux.com/plugins).
For example, the url for the "DankBatteryAlerts" plugin is `dms://plugin/install/dankBatteryAlerts`, so the id is `dankBatteryAlerts`.


Install any plugin package with the NixOS or Home Manager module options:
```nix
{ pkgs, inputs, ... }: {
  programs.dankMaterialShell = {
    plugins = {
      dankBatteryAlerts.enable = true;

      # To manually install a plugin without NixOS/HM module
      # With flakes:
      dankBatteryAlerts.src = inputs.nix-dms-plugins.packages.${pkgs.system}.dankBatteryAlerts;
      # without flakes:
      dankBatteryAlerts.src = nix-dms-plugins-pkgs.dankBatteryAlerts;
    };
  };
}
```
