{ minego, inputs, den, ... }: {
	minego.gaming.provides = {
		min = { host, ... }: {
			nixos = { pkgs, ... }: {
				boot.kernelModules = [ "ntsync" ];

				hardware = {
					graphics.enable32Bit = true;
					steam-hardware.enable = true;
				};

				programs = {
					steam = {
						enable = true;

						extraCompatPackages = with pkgs; [
							proton-ge-bin
							steamtinkerlaunch
						];

						gamescopeSession = {
							enable					= true;
							args					= [ "--default-touch-mode" "4" ];
						};

						# Enable extest to translate x11 input events to uinput for wayland
						extest.enable				= true;
					};

					gamemode.enable					= true;
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
			};
		};

		max = den.lib.parametric {
			includes = [
				minego.gaming._.min
			];

			nixos = { pkgs, ... }: {
				imports = [
					inputs.nix-gaming.nixosModules.platformOptimizations
					inputs.nix-gaming.nixosModules.pipewireLowLatency
				];

				hardware.opentabletdriver.enable = true;

				services = {
					pipewire.lowLatency = {
						enable = true;
					};
				};
				programs = {
					steam = {
						platformOptimizations.enable = true;
						remotePlay.openFirewall = true;
						dedicatedServer.openFirewall= true;
						localNetworkGameTransfers.openFirewall = true;
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
		};
	};
}
