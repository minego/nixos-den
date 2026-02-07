{ ... }: {
	minego.apps._.chromium = {
		nixos = { pkgs, config, ... }:
		let
		in {
			age.secrets.chromium-sync-oauth = {
				file			= ./../../secrets/chromium-sync-oauth.age;
				owner			= "root";
				group			= "users";
				mode			= "440";
			};

			# Enabling sync for chromium:
			#	https://www.learningtopi.com/sbc/chromium-sync/
			#
			#	NOTE: Each google account used for sync MUST be a member of both groups
			#	listed on that page. Read the instructions carefully when adding a new
			#	account.
			#
			#	The wrapper below reads the secrets from the .age file and sets them
			#	as environment variables before starting chromium.
			nixpkgs.overlays = [
				(_: super: {
					chromium = super.symlinkJoin {
						name								= "chromium";
						paths = [
							(super.writeShellScriptBin "chromium" ''
								. ${config.age.secrets.chromium-sync-oauth.path}

								exec ${super.chromium}/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland $@
								'')
							super.chromium
						];
					};
				})
			];

			environment.systemPackages = with pkgs; [
				chromium
			];

			programs.chromium = {
				enable									= true;

				# View details about chrome policies by visiting:
				#		chrome://policy/
				extraOpts = {
					# FUCK YOUR A.I. BULLSHIT
					AIModeSettings						= 1;
					GenAiDefaultSettings				= 2;

					# BrowserSignin						= 0;
					SyncDisabled						= false;
					PasswordManagerEnabled				= false;
					BuiltInDnsClientEnabled				= true;
					MetricsReportingEnabled				= false;
					SpellcheckEnabled					= true;
					SpellcheckLanguage					= [ "en-US" ];

					FullRestoreEnabled                  = true;
					FullRestoreMode                     = 1; # Always restore the last session
					RestoreOnStartup                    = 1; # Restore the last session

					# Default to "web" for google searches
					DefaultSearchProviderEnabled		= true;
					DefaultSearchProviderSearchURL		= "https://www.google.com/search?q={searchTerms}&udm=14";

					"3rdparty".extensions = {
						# Bitwarden
						"nngceckbapebfimnlniiiahkandclblb" = {
							environment.base			= "https://bitwarden.minego.net";
						};

						# Surfingkeys
						"gfbliohnnapiefjpjlpjnehglfpaknnc" = {
							incognito					= true;
							newAllowFileAccess			= true;

							preferences = {
								showModeStatus			= true;
								showProxyInStatusBar	= true;
								omnibarPosition			= "bottom";
								caseSensitive			= false;
								smartCase				= true;

								proxy = {
								};
							};
						};
					};
				};

				extensions = [
					"gfbliohnnapiefjpjlpjnehglfpaknnc" # Surfingkeys
					"nngceckbapebfimnlniiiahkandclblb" # Bitwarden
					"gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
					"cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
					"dofmpfndepckmehaaoplniohdibnplmg" # Tab Group Focus (Open new tabs in the current tab group)
					"glnpjglilkicbckjpbgcfkogebgllemb" # Okta
					# "epmieacohbnladjdcjinfajhepbfaakl" # Blackout
					# "ebboehhiijjcihmopcggopfgchnfepkn" # CHROLED - Borderless, pure black theme
					"padekgcemlokbadohgkifijomclgjgif" # Proxy SwitchyOmega
					"fnaicdffflnofjppbagibeoednhnbjhg" # floccus (bookmark and tab sync)
					"fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
				];
			};

			xdg.mime = {
				enable = true;

				defaultApplications = {
					"text/html"					= "chromium.desktop";
					"x-scheme-handler/http"		= "chromium.desktop";
					"x-scheme-handler/https"	= "chromium.desktop";
					"x-scheme-handler/about"	= "chromium.desktop";
					"x-scheme-handler/unknown"	= "chromium.desktop";
				};
			};

			environment.sessionVariables = {
				BROWSER			= "${pkgs.chromium}/bin/chromium";
				DEFAULT_BROWSER	= "${pkgs.chromium}/bin/chromium";
			};
		};
	};
}

