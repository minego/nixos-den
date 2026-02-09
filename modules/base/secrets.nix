{
	flake.modules.nixos.base = { inputs, lib, pkgs, ... }: {
		imports = [
			inputs.agenix.nixosModules.default
		];

		environment.systemPackages = [

		] ++ lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
			inputs.agenix.packages.x86_64-linux.default
		] ++ lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64) [
			inputs.agenix.packages.aarch64-linux.default
		];
	};
}
