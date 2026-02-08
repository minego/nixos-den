{
	flake.modules.nixos.base = { inputs, host, ... }: {
		nixpkgs.config.allowUnfree			= true;
		nix = {
			optimise.automatic				= true;
			registry.nixpkgs.flake			= inputs.nixpkgs;
			gc.automatic					= true;
			settings = {
				keep-outputs				= true;
				keep-derivations			= true;
				use-xdg-base-directories	= true;
				auto-optimise-store			= true;

				experimental-features		= ["nix-command" "flakes"];
			};
		};

		nixpkgs.hostPlatform				= host.system;
		documentation = {
			doc.enable						= false;
			info.enable						= false;
			dev.enable						= true;
		};

		system.stateVersion					= "26.05";
	};
}
