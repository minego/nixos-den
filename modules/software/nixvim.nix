let 
	module = { inputs, pkgs, ... }: {
		nixpkgs.overlays = [
			inputs.nixvim.overlays.default
		];

		environment.shellAliases = {
			vi				= "nvim";
			vim				= "nvim";
		};

		environment.variables = {
			KEYTIMEOUT		= "1";
			VISUAL			= "nvim";
			EDITOR			= "nvim";
			SUDO_EDITOR		= "nvim";
			LC_CTYPE		= "C";
		};

		environment.systemPackages = [
			pkgs.neovim
		];
	};
in {
	flake.modules.nixos.software		= module;
	flake.modules.nixos.software_nixvim	= module;
}
