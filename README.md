# ❄️ My NixOS Configuration

This repository holds the configuration for all my Linux systems.

## Nix

Everything is managed thanks to a [nix flake](https://nixos.wiki/wiki/Flakes): `flake.nix`.
It relies heavily on the [Dendritic pattern](https://github.com/mightyiam/dendritic).
Each file is a [flake-parts](https://flake.parts) module.

### Repository structure

Everything is stored under the `modules/` folder and imported automatically thanks to [vic/import-tree](https://github.com/vic/import-tree).

### Adding a host

Hosts are defined by adding a value to the top level `config.nixosHosts` set,
following the schema defined in `modules/hosts/meta.nix` which includes host
specific options that can be used in modules.

The `modules` list on each host is used to define the aspects that should be
enabled for that host.

### Defining an aspect

An aspect is an optional module, which can be enabled for a host, by name. When
an aspect is included in the module list for a host it will be added with the
host options as an argument.

```
	{
		flake.modules.nixos.my_fancy_aspect = { host, ... }: {
			...
		};
	}
```
