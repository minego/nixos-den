{ inputs, ... }: {
	den.default = {
		nixos = {
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
		};
	};
}
