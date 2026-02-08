{
	minego.gui = {
		nixos = { pkgs, ... }: {
			nixpkgs.overlays = [
				(_: super: {
					# Fonts
					monaspace = super.stdenv.mkDerivation {
						name			= "monaspace";
						version			= "1.000";

						src = super.fetchFromGitHub {
							owner		= "githubnext";
							repo		= "monaspace";
							rev			= "2bddc16670ec9cf00435a1725033f241184dedd1";
							sha256		= "sha256-YgpK+a66s8YiJg481uFlRKUvu006Z2sMOpuvPFcDJH4=";
						};

						installPhase = ''
							mkdir -p $out/share/fonts/OTF/
							cp -r fonts/otf/* $out/share/fonts/OTF/
						'';
					};

					sparklines = super.stdenv.mkDerivation {
						name			= "sparklines";
						version			= "2.0";

						src = super.fetchzip {
							url			= "https://github.com/aftertheflood/sparks/releases/download/v2.0/Sparks-font-complete.zip";
							stripRoot	= false;
							hash		= "sha256-xp/rCZpitX2IZO1Tvl3Me1WSPsxy55BDDuoQzQGBlII=";
						};

						installPhase = ''
							mkdir -p $out/share/fonts/OTF/
							cp -r Sparks/*.otf $out/share/fonts/OTF/
						'';
					};
				})
			];

			fonts.packages = with pkgs; [
				# nerdfonts
				nerd-fonts.monaspace
				nerd-fonts.terminess-ttf
				nerd-fonts.ubuntu
				nerd-fonts.ubuntu-sans
				nerd-fonts.roboto-mono
				nerd-fonts.profont
				nerd-fonts.iosevka-term
				nerd-fonts.hack

				noto-fonts
				noto-fonts-cjk-sans
				noto-fonts-color-emoji
				liberation_ttf
				fira-code
				fira-code-symbols
				mplus-outline-fonts.githubRelease
				proggyfonts
				terminus_font

				monaspace
				sparklines

				nanum
			];
				
			fonts.fontconfig.defaultFonts = {
				serif						= [ "Noto Serif" ];
				sansSerif					= [ "Monaspace Neon Light" "Noto Sans" ];
			};
		};
	};
}
