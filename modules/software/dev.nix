{
	flake.modules.nixos.software_dev = { pkgs, ... }: {
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

			mitmproxy
		];

		security.pki.certificateFiles = [ ./../../assets/mitmproxy-ca-cert.pem ];
	};
}
