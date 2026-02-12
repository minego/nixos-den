let
	module = { pkgs, ... }: {
		services.gnome.gnome-keyring.enable = true;

		environment.systemPackages = with pkgs; [
			seahorse
		];

		xdg.portal.extraPortals = with pkgs; [
			gnome-keyring
		];

		security.pam.services.login.enableGnomeKeyring = true;
		security.pam.services.greetd.enableGnomeKeyring = true;
		security.pam.services.su.enableGnomeKeyring = true;
		security.pam.services.sshd.enableGnomeKeyring = true;
		
	};
in {
	flake.modules.nixos.software_desktop	= module;
}

