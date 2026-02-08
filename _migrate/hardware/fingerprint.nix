{
	minego.hardware._."fingerprint" = {
		nixos = { ... }: {
			services.fprintd.enable			= true;

			security.pam.services = {
				swaylock.fprintAuth = true;
				gtklock.fprintAuth = true;
			};

		};
	};
}
