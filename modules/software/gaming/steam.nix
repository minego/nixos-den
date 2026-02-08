let
	module = { inputs, host, pkgs, ... }: {
		imports = [
			inputs.nix-gaming.nixosModules.platformOptimizations
			inputs.nix-gaming.nixosModules.pipewireLowLatency
		];

		boot.kernelModules								= [ "ntsync" ];

		hardware = {
			graphics.enable32Bit						= true;
			steam-hardware.enable						= true;
		};

		services.pipewire.lowLatency.enable				= true;

		programs = {
			steam = {
				enable									= true;

				extraCompatPackages = with pkgs; [
					proton-ge-bin
					steamtinkerlaunch
				];

				gamescopeSession = {
					enable								= true;
					args								= [ "--default-touch-mode" "4" ];
				};

				# Enable extest to translate x11 input events to uinput for wayland
				extest.enable							= true;

				platformOptimizations.enable			= true;
				remotePlay.openFirewall					= true;
				dedicatedServer.openFirewall			= true;
				localNetworkGameTransfers.openFirewall	= true;
			};

			gamemode.enable								= true;

			gamescope = {
				enable = true;
				args = [
					"-W ${toString host.primaryDisplay.width}"
					"-H ${toString host.primaryDisplay.height}"
					"-r ${toString host.primaryDisplay.refresh}"
					"-O ${host.primaryDisplay.name}"
					"-f"
					"--adaptive-sync"
					"--mangoapp"
				];
			};
		};

		environment.systemPackages = with pkgs; [
			mangohud
			protonplus
			protontricks
			protonup-qt
			adwsteamgtk
		];
	};
in {
	flake.modules.nixos.software_gaming	= module;
	flake.modules.nixos.software_steam	= module;
}

