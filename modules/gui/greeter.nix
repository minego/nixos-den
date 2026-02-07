{ inputs, ... }: {
	minego.gui._.greeter = {
		nixos = { ... }: {
			imports = [
				inputs.dms.nixosModules.greeter
			];

			programs.dank-material-shell.greeter = {
				enable			= true;
				compositor.name	= "niri";
				configHome		= "/home/m"; # Use DMS config from user m
			};
		};
	};
}
