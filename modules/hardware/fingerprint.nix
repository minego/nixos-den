{
	flake.modules.nixos.hardware_fingerprint = {
		services.fprintd.enable			= true;

		security.pam.services = {
			swaylock.fprintAuth = true;
			gtklock.fprintAuth = true;
		};

	};
}
