{
	inputs = {
		nixpkgs = {
			url = "github:nixos/nixpkgs/nixos-unstable";
		};

		nci = {
			url = "github:90-008/nix-cargo-integration";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		parts = {
			url = "github:hercules-ci/flake-parts";
			inputs.nixpkgs-lib.follows = "nixpkgs";
		};

		crate = {
			url = "github:dead10ck/nu_plugin_dns";
			flake = false;
		};
	};

	outputs = inputs @ { parts, nci, ... }: parts.lib.mkFlake {inherit inputs;} (let
		crateName = "nu_plugin_dns";
	in {
		systems = ["x86_64-linux"];
		imports = [
			nci.flakeModule

			({ inputs, ... }: {
				perSystem = { ... }: {
					nci.projects.${crateName} = {
						path = inputs.crate;
						profiles.release.runTests = false;
					};
					nci.crates.${crateName} = {
						profiles.release.runTests = false;
					};
				};
			})
		];
		perSystem = { config, ... }: let
			crateOutputs = config.nci.outputs.${crateName};
		in {
			# export the crate devshell as the default devshell
			devShells.default = crateOutputs.devShell;

			# export the release package of the crate as default package
			packages.default = crateOutputs.packages.release;
		};
	});
}
