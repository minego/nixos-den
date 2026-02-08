let
	module = { inputs, lib, pkgs, host, ... }: {
		imports = [
			inputs.jovian-nixos.nixosModules.default
		];

		services.displayManager.autoLogin = {
			enable								= lib.mkForce true;
			user								= host.primaryUser;
		};

		# Disable regreet - Jovian uses greetd, but with its own greeter
		programs.regreet.enable					= lib.mkForce false;

		jovian.decky-loader = {
			enable								= true;
		};

		# Disable hypridle, since it conflicts with steam and sleep
		systemd.user.services.hypridle = {
			enable								= lib.mkForce false;
		};

		jovian = {
			steam = {
				enable							= true;
				autoStart						= true;
				user							= host.primaryUser;

				# Move this to the niri config...
				desktopSession					= "niri";
			};

			devices.steamdeck = {
				enable							= true;
				autoUpdate						= true;
				enableGyroDsuService			= true;
			};

			steamos.useSteamOSConfig			= true;
		};

		# The Steam Deck UI integrates with NetworkManager
		# networking.networkmanager.enable		= true;
		# networking.wireless.enable				= false;

		environment.systemPackages = with pkgs; [
			acpi
			mangohud
			steamdeck-firmware
			jupiter-dock-updater-bin
			chiaki-ng
			# heroic
			gogdl
			shadps4
		];
	};
in {
	flake.modules.nixos.software_steamos	= module;
}

