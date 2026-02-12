let 
	module = { inputs, pkgs, ... }: let
		nvim		= pkgs.neovim;
		nvimcmd		= "${nvim}/bin/nvim";

		manpager	= (pkgs.writeShellScriptBin "manpager" ''
			${nvimcmd} +"set nomodified" +Man! -
		'');

		gitpager	= (pkgs.writeShellScriptBin "gitpager" ''
			${nvimcmd} +"set nomodified" +Man! +'set syntax=diff' -
		'');
	in {
		nixpkgs.overlays = [
			inputs.nixvim.overlays.default
		];

		environment.shellAliases = {
			vi				= nvimcmd;
			vim				= nvimcmd;
		};

		environment.variables = {
			KEYTIMEOUT		= "1";
			VISUAL			= nvimcmd;
			EDITOR			= nvimcmd;
			SUDO_EDITOR		= nvimcmd;
			LC_CTYPE		= "C";
			PAGER			= "manpager";
			MANPAGER		= "manpager";
			GIT_PAGER		= "gitpager";
		};

		environment.systemPackages = [
			nvim
			manpager
			gitpager
		];
	};
in {
	flake.modules.nixos.software		= module;
	flake.modules.nixos.software_nixvim	= module;
}
