{
	flake.modules.nixos.base = { ... }: {
		boot = {
			loader.systemd-boot.enable	= true;

			# Using tempfs causes build failures on systems without a lot of
			# memory.
			tmp = {
				useTmpfs				= false;
				cleanOnBoot				= true;
			};

			plymouth.enable				= true;
			consoleLogLevel				= 3;
			initrd = {
				verbose					= false;
				systemd.enable			= true;
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

		systemd.settings.Manager = {
			DefaultTimeoutStopSec		= "10s";
		};

		services.fwupd.enable			= true;
		security.rtkit.enable			= true;
		services.dbus.implementation	= "broker";

		time.timeZone					= "America/Vancouver";

		hardware = {
			enableRedistributableFirmware	= true;
		};

		i18n = {
			defaultLocale				= "en_US.UTF-8";
			supportedLocales			= [ "all" ];
			extraLocaleSettings = {
				LC_ALL					= "en_US.UTF-8"; 
				LC_ADDRESS				= "en_US.UTF-8";
				LC_IDENTIFICATION		= "en_US.UTF-8";
				LC_MEASUREMENT			= "en_US.UTF-8";
				LC_MONETARY				= "en_US.UTF-8";
				LC_NAME					= "en_US.UTF-8";
				LC_NUMERIC				= "en_US.UTF-8";
				LC_PAPER				= "en_US.UTF-8";
				LC_TELEPHONE			= "en_US.UTF-8";
				LC_TIME					= "en_US.UTF-8";
			};
		};

	};
}
