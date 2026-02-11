let
	module = { inputs, pkgs, ... }: {
		imports = [
			inputs.nix-index-database.nixosModules.nix-index
		];
		programs.nix-index-database.comma.enable = true;

		environment.systemPackages = with pkgs; [
			nix-your-shell
			starship

			nushell
			nushell-plugin-gstat	# git status
			nushell-plugin-polars

			carapace				# Command argument completion for common tools
		];

		nixpkgs.overlays = [
			inputs.nix-your-shell.overlays.default

			(_: super: {

			})
		];
	};
in {
	flake.modules.nixos.software = module;
	flake.modules.nixos.software_shell_nu = module;
}
