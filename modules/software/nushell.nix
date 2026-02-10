let
	module = { inputs, pkgs, lib, ... }: {
		imports = [
			inputs.nix-index-database.nixosModules.nix-index
		];
		programs.nix-index-database.comma.enable = true;

		nixpkgs.overlays = [
			inputs.nix-your-shell.overlays.default
		];

		environment.systemPackages = with pkgs; [
			nix-your-shell
			starship

			nushell
			nushell-plugin-gstat	# git status
			nushell-plugin-polars

			carapace				# Command argument completion for common tools
		];
	};
in {
	flake.modules.nixos.software = module;
	flake.modules.nixos.software_shell_nu = module;
}
