{
	minego.apps._.dev = {
		nixos = { pkgs, ... }: {
			environment.systemPackages = with pkgs; [
				neovim
				dtach
				direnv

				man-pages
				man-pages-posix

				difftastic
				git
				gnumake
				cmake
				ninja
				pkg-config

				jq

				openssl
				openssl.dev
			];
		};
	};
}
