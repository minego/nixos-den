let
	module = {
		programs.appimage = {
			enable							= true;
			binfmt							= true;
		};
	};
in {
	flake.modules.nixos.software_appimage	= module;
	flake.modules.nixos.software_desktop	= module;
}
