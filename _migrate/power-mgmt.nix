{ minego, ... }: {
	minego.power-mgmt = {
		nixos = { pkgs, lib, ... }: {
			environment.systemPackages = with pkgs; [
				acpi
			];

			services = {
				# Don't shutdown if someone hits the power button!
				logind.settings.Login = {
					HandleLidSwitch		= "suspend";
					SleepOperation		= "suspend";
					HandlePowerKey		= lib.mkDefault "suspend";
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

		provides = {
			ignorePowerKey = {
				includes = [ minego.power-mgmt ];

				nixos = { lib, ... }: {
					services.logind.settings.Login = {
						HandlePowerKey		= lib.mkForce "ignore";
					};
				};
			};
		};
	};
}
