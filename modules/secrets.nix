{ inputs, ... }: {
	den.default.nixos = { lib, pkgs, ... }: {
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

	# TODO Move these into the spot they are being used...
	minego.secrets._ = {
		hotblack-cloudflare-user.nixos = {
			age.secrets.cloudflare-user = {
				file			= ./../secrets/cloudflare-user.age;
				owner			= "root";
				group			= "users";
				mode			= "400";
			};
		};
		hotblack-cloudflare-key.nixos = {
			age.secrets.cloudflare-user = {
				file			= ./../secrets/cloudflare-key.age;
				owner			= "root";
				group			= "users";
				mode			= "400";
			};
		};
		mosquitto = {
			age.secrets.cloudflare-user = {
				file			= ./../secrets/mosquitto.age;
				owner			= "root";
				group			= "users";
				mode			= "440";
			};
		};
	};

	# Add these to the modules/hosts/hotblack/default.nix when that gets added
	#
	#den.aspects.hotblack.includes = [
	#	<minego/secrets/hotblack-cloudflare-user>
	#	<minego/secrets/hotblack-cloudflare-key>
	#];
}

