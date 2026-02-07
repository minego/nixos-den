{
	minego.apps._.appimage = {
		nixos = {
			programs.appimage = {
				enable							= true;
				binfmt							= true;
			};
		};
	};
}
