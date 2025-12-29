# Nix DMS Plugins
This flake contains packages for all plugins in the [dms plugin registry](https://github.com/AvengeMedia/dms-plugin-registry).

## Installation

## Usage
Plugin packages are available as flake package outputs or attributes in `default.nix`.
The attribute name for packages are determined by the `id` property in the plugin registry.
The `id` is the last portion of the url of the "Install" button in the [plugin store](https://danklinux.com/plugins).
For example, the url for the "Hyprland Submap" plugin is `dms://plugin/install/dankBatteryAlerts`, so the id is `dankBatteryAlerts`.

### With flakes
Add this project as a flake input:
```nix
inputs.nix-dms-plugins.url = "github:pacman99/nix-dms-plugins";
```

Then install any plugin package with the NixOS or Home Manager module options:
```nix
{ pkgs, inputs, ... }: {
  programs.dankMaterialShell = {
    plugins = {
      DankBatteryAlerts.src = inputs.nix-dms-plugins.packages.${pkgs.system}.dankBatteryAlerts;
    };
  };
}
```

### Without flakes
Fetch this project with `fetchTarball` then install any plugin package with the NixOS or Home Manager module options
```nix
{ pkgs, ... }:
let
  nix-dms-plugins = import
    (builtins.fetchTarball "https://github.com/pacman99/nix-dms-plugins/archive/main.tar.gz")
    { inherit pkgs; };
in
{
  programs.dankMaterialShell = {
    plugins = {
      DankBatteryAlerts.src = nix-dms-plugins.dankBatteryAlerts;
    };
  };
}
```
