{
	flake.modules.nixos.users_m = { pkgs, ... }: {
		users.users.m = {
			description		= "Micah N Gorrell";
			shell			= pkgs.zsh;
			isNormalUser	= true;

			extraGroups = [
				"wheel"

				"wireshark"
				"video"
				"input"
				"dialout"
				"media"
			];

			openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrr0jgE0HE25pM0Mpqz1H8Bu3VczJa1wSIcJVLbPtiL m@dent"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHeoTPiXAOmtOWU5oAajvYX+QBOUVF3yyObGii16BQ/+ m@lord"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWCk1KpqchVgLCWC711+F1fnRnp6so3FwLpPYG85xIi m@hotblack"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOpMsaa0+ZPrF3dTHcXXXRiA/qfGYtF1wehO0UkEaWV m@zaphod"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyOr1jFfS3I12H73/phT6OLCcz5joIYOVOQgiR1OpHv m@random"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6XNKufvADcA5zNAp5mYVBA2kQ2OIXIOq9enSyUmJsM m@marvin"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpCf3ELP19jIwlrm9zMiPhzHUAQQ1shXgIrbrYmPpnj phone"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6avo8bo4p2UsXer2yUPkS5s4E/m5fMkhX9WnzrffwJ m@wonko"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJ7500iF9Quza4AIpfXulyqljvL70nR75cFbf2j4IUL m@trillian"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAoPDMLS3e4Tho8taOOMiWxm//Cl740Qkw3TWsRDEzg8 m@wowbagger"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIEcebCWo0hCFtXGKPp+00b+yDIkxrFa56r9O3Qg9+oQ m@agrajag"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMKXoe/DDKeCriRgggP2GtQKnBL735+pX3TRnnGY6KcL micah.gorrell@cyberark.com"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeEbhtPh89IAirnW03UmjH0F68Zwh+z2xHUwG7ztISb m@dishoftheday"
			];

			initialHashedPassword = "$y$j9T$oBNqVU4HCc3Jw.H413Vfs0$YozYZu0aOlPgyZ146Z2ZOb69HSbXfw9VrO9xzz3Fw/3";
		};
	};
}
