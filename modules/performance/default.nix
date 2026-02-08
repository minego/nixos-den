{ config, ... }: let
	top = config;
in {
	flake.modules.nixos.performance = { ... }: {
		boot.kernel.sysctl = {
			"transparent_hugepage"		= "always";
			"vm.nr_hugepages_defrag"	= 0;
			"ipcs_shm"					= 1;
			"default_hugepagez"			= "1G";
			"hugepagesz"				= "1G";
			"vm.compact_memory"			= 0;
		};
	};

	flake.modules.nixos.performance_responsive = {
		imports = with top.flake.modules.nixos; [
			performance
		];

		boot = {
			kernel.sysctl."vm.swappiness"	= 1;

			kernelParams = [
				"nowatchdog"
				"nosoftlockup"
				"audit=0"
				"skew_tick=1"
				"threadirqs"
				"preempt=full"
				"nohz_full=all"
			];
		};
	};

	flake.modules.nixos.performance_max = {
		imports = with top.flake.modules.nixos; [
			performance_responsive
		];

		boot.kernelParams = [
			"usbcore.autosuspend=60"
			"workqueue.power_efficient=false"
			"cpufreq.default_governor=performance"
		];
	};
}
