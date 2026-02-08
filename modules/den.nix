{ inputs, den, __findFile ? __findFile, ... }: {
	_module.args.__findFile = den.lib.__findFile;

	systems = [ "x86_64-linux" "aarch64-linux" ];
	imports = [
		inputs.den.flakeModule

		(inputs.den.namespace "minego" false)
		(inputs.den.namespace "utils" false)
	];
}
