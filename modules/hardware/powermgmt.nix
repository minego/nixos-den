{
	flake.modules.nixos.hardware_powermgmt = { pkgs, host, lib, ... }: {
		environment.systemPackages = with pkgs; [
			acpi
		];

		services = {
			# Don't shutdown if someone hits the power button!
			logind.settings.Login = {
				HandleLidSwitch		= "suspend";
				SleepOperation		= "suspend";

				HandlePowerKey		= if host.ignorePowerButton then
					lib.mkForce "ignore"
				else
					lib.mkForce "suspend";
			};

			upower = {
				enable				= true;
				criticalPowerAction	= "Hibernate";
			};

			# Thermald isn't currently available on aarch64
			thermald.enable			= (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64);
		};

		powerManagement.enable		= true;
		hardware.sensor.iio.enable	= true;
	};
}
