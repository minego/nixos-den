{ __findFile, ... }: {
	den.default = {
		includes = [
			<den/define-user>
			({ host, ... }: {
				${host.class}.networking.hostName = host.name;
			})
		];

		nixos = { ... }: {
			documentation.doc.enable		= false;
			documentation.info.enable		= false;
			documentation.dev.enable		= true;

			services.dbus.implementation	= "broker";
			system.stateVersion				= "26.05";
			time.timeZone					= "America/Vancouver";
			boot.initrd.systemd.enable		= true;

			i18n = {
				defaultLocale				= "en_US.UTF-8";
				supportedLocales			= [ "all" ];
				extraLocaleSettings = {
					LC_ALL							= "en_US.UTF-8"; 
					LC_ADDRESS						= "en_US.UTF-8";
					LC_IDENTIFICATION				= "en_US.UTF-8";
					LC_MEASUREMENT					= "en_US.UTF-8";
					LC_MONETARY						= "en_US.UTF-8";
					LC_NAME							= "en_US.UTF-8";
					LC_NUMERIC						= "en_US.UTF-8";
					LC_PAPER						= "en_US.UTF-8";
					LC_TELEPHONE					= "en_US.UTF-8";
					LC_TIME							= "en_US.UTF-8";
				};
			};
		};
	};
}
