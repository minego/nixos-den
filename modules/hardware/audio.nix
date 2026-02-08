{
	flake.modules.nixos.hardware_audio = { pkgs, lib, ... }: {
		# Enable sound with pipewire.
		services.pulseaudio.enable			= false;
		security.rtkit.enable				= true;

		services.pipewire = {
			enable							= lib.mkForce true;
			audio.enable					= true;
			wireplumber = {
				enable						= true;
			};

			alsa = {
				enable						= true;
				support32Bit				= true;
			};
			pulse.enable					= true;
			# jack.enable					= true;
		};

		# Enable bluetooth
		hardware.bluetooth = {
			enable							= true;
			powerOnBoot						= true;
			settings.General.Experimental	= true;
		};
		services.blueman.enable				= true;

		systemd.user.services.mpris-proxy = {
			description						= "Mpris proxy";
			after							= [ "network.target" "sound.target" ];
			wantedBy						= [ "default.target" ];
		};

		environment = {
			systemPackages = with pkgs; [
				pavucontrol
				pamixer
				alsa-utils
			];
		};
	};
}
