{
	flake.modules.nixos.users_ha = {
		users.users.ha = {
			description		= "Home Assistant";

			isNormalUser	= true;

			openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARFptgxIDHgrVNuWVHUvU06STUjUtbKdcvilj5cnLn+ m@agrajag"
			];

			initialHashedPassword = "$y$j9T$oBNqVU4HCc3Jw.H413Vfs0$YozYZu0aOlPgyZ146Z2ZOb69HSbXfw9VrO9xzz3Fw/3";
		};
	};
}
