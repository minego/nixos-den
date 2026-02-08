{ minego, ... }: {
	minego.boot = {
		nixos = {
			boot = {
				loader.systemd-boot.enable				= true;

				# Using tempfs causes build failures on systems without a lot of
				# memory.
				tmp.useTmpfs							= false;

				tmp.cleanOnBoot							= true;
			};

			systemd.settings.Manager = {
                DefaultTimeoutStopSec					= "10s";
			};

			hardware.enableRedistributableFirmware		= true;
		};

		provides.graphical = {
			includes = [ minego.boot ];

			nixos = {
				boot = {
					plymouth.enable			= true;
					consoleLogLevel			= 3;
					initrd = {
						verbose				= false;
						systemd.enable		= true;
					};
					kernelParams = [
						"quiet"
						"splash"
						"intremap=on"
						"boot.shell_on_fail"
						"udev.log_priority=3"
						"rd.systemd.show_status=auto"
					];
				};
			};
		};
	};
}
