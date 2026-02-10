let
	module = { inputs, ... }: {
		nixpkgs.overlays = [
			inputs.nix-your-shell.overlays.default
		];
	};
in {
	flake.modules.nixos.software = module;
	flake.modules.nixos.software_nix-your-shell = module;
}
