{ ... }: {
	minego.apps._.git = {
		nixos = { pkgs, ... }: {
			programs = {
				git = {
					enable						= true;
					lfs = {
						enable					= true;
						enablePureSSHTransfer	= true;
					};

					config = [{
						user = {
							name				= "Micah N Gorrell";
							email				= "m@minego.net";
						};

						init.defaultBranch		= "main";
						pull.rebase				= true;
						push.autoSetupRemote	= true;
						fetch.prune				= true;

						url."git@gitlab.com:" = {
							insteadOf			= [ "https://gitlab.com" ];
						};
					}

					{
						includeIf = let
							venafi-ssh-config = pkgs.writeText "gitconfig" ''
								[diff]
								external = ${pkgs.difftastic}/bin/difft

								[user]
								email = "micah.gorrell@cyberark.com";
								name = "Micah N Gorrell";
								'';
						in {
							"hasconfig:remote.*.url:git@gitlab.com:venafi/**".path = venafi-ssh-config;

							"gitdir=~/src/vaas/**".path			= venafi-ssh-config;
							"gitdir=~/src/venafi/**".path		= venafi-ssh-config;
							"gitdir=~/src/share/venafi/**".path	= venafi-ssh-config;
						};
					}];
				};
			};
		};
	};
}
