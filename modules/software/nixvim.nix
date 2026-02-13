let 
	module = { inputs, pkgs, ... }: let
		nvim		= pkgs.neovim;
		nvimcmd		= "${nvim}/bin/nvim";

		pager	= (pkgs.writeShellScriptBin "pager" ''
			${nvimcmd} +"set nomodified" +Man! +"set nonumber norelativenumber" -
		'');

		gitpager	= (pkgs.writeShellScriptBin "gitpager" ''
			${nvimcmd} +"set nomodified" +Man! +"set nonumber norelativenumber" +"set syntax=diff" -
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
			PAGER			= "pager";
			pager			= "pager";
			GIT_PAGER		= "gitpager";
		};

		environment.systemPackages = [
			nvim
			pager
			gitpager
		];
	};
in {
	flake.modules.nixos.software		= module;
	flake.modules.nixos.software_nixvim	= module;
}
