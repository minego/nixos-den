let
	module = { inputs, ... }: {
		imports = [
			inputs.nix-index-database.nixosModules.nix-index
		];
		programs.nix-index-database.comma.enable = true;
	};
in {
	flake.modules.nixos.software = module;
	flake.modules.nixos.software_nix-index = module;
}
