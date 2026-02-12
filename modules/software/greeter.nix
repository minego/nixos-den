let
	module = { inputs, ... }: {
		imports = [
			inputs.dms.nixosModules.greeter
		];

		programs.dank-material-shell.greeter = {
			enable			= true;
			compositor.name	= "niri";
			configHome		= "/home/m"; # Use DMS config from user m
		};
	};
in {
	# The DMS greeter is included in the main desktop aspect
	flake.modules.nixos.software_greeter	= module;
	flake.modules.nixos.software_desktop	= module;
}

