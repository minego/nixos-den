{ config, ... }: let
	top = config;
in {
	flake.modules.nixos.software = { pkgs, ... }: {
		environment.shellAliases = {
			calc			= "eva";
			img				= "imv";
			feh				= "imv";
		};

		environment.systemPackages = with pkgs; [
			neovim
			dtach
			direnv

			nh
			eza

			ripgrep
			ripgrep-all

			eva # calculator repl
			bitwise		# A very handy simple cli calculator

			whois
			fd
			file
			fzf
			lsof
			inotify-tools
			killall
			pciutils
			procs
			psmisc
			psutils
			curl
			wget
			neofetch
			mdcat
			vivify
			jq
			unixtools.xxd
			htop
			bottom

			rsync
			strace
			traceroute
			ethtool
			linuxConsoleTools # jstest

			unrar
			unzip

			usbutils
			waypipe
			imv			# Like feh, but for wayland

			kitty.terminfo

			# Install my own custom scripts from the scripts dir
			(stdenv.mkDerivation {
				name		= "my-scripts";
				buildInputs	= [ bash ];
				src			= ./../../scripts;
				installPhase = ''
					mkdir -p $out/bin
					cp * $out/bin/
					chmod +x $out/bin/*
				'';
			})
		];
	};
}
