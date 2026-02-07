{ __findFile, ... }: {
	minego.workstation.includes = [
		<minego/shell>
		<minego/apps/dev>
		<minego/apps/nixvim>

		<minego/apps/appimage>

		# <minego/apps/kitty>
		# <minego/apps/git>
		# <minego/apps/nh>
		# <minego/apps/nix-tools>
	];
}
