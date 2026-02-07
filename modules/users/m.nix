{ den, minego, ... }: {
	den.aspects.m = {
		includes = [
			den._.primary-user
			minego.shell
			minego.apps._.coreutils
			minego.apps._.dev
		];

		nixos = { pkgs, ... }: {
			users.users.m = {
				shell = pkgs.zsh;
				extraGroups = [
					"adb"
					"docker"
					"wireshark"
					"video"
					"input"
					"dialout"
					"media"

					"kvm"
					"libvirtd"
					"docker"
				];
			};
		};
	};
}
