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

		# TODO These should be defined in the module that uses them!
		age.secrets.hostblack-cloudflare-user = {
			file			= ./../../secrets/hotblack-cloudflare-user.age;
			owner			= "root";
			group			= "users";
			mode			= "400";
		};
		age.secrets.hostblack-cloudflare-key = {
			file			= ./../../secrets/hotblack-cloudflare-key.age;
			owner			= "root";
			group			= "users";
			mode			= "400";
		};
		age.secrets.mosquitto = {
			file			= ./../../secrets/mosquitto.age;
			owner			= "root";
			group			= "users";
			mode			= "440";
		};
	};
}
