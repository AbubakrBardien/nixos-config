{ config, ... }:
{
    boot = {
        resumeDevice = "/dev/disk/by-label/nixos";
        kernelParams = [
            "resume_offset=34816"
        ]
        ++ (
            # Add the NVMe workaround when the machine actually uses NVMe
            if builtins.elem "nvme" config.boot.initrd.availableKernelModules then
                [ "nvme_core.default_ps_max_latency_us=0" ]
            else
                [ ]
        );
    };

    systemd.sleep.settings.Sleep = {
        AllowSuspendThenHibernate = true;
        HibernateDelaySec = 300; # hibernate after 5 min
    };

    services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

    # Swapfile Configuration
    swapDevices = [
        {
            device = "/swapfile";
            size = 10 * 1024; # Size in MB (10GB = 10240MB)
        }
    ];
}
