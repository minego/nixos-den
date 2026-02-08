{ config, ... }: let
	top = config;
in {
	flake.modules.nixos.hardware_laptop = {
		imports = with top.flake.modules.nixos; [
			hardware_powermgmt
			hardware_bluetooth
			hardware_audio
			hardware_8bitdo
			hardware_keyboard

			performance_responsive
		];
	};
}
