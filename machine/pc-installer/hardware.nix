{...}: {
  boot.initrd.availableKernelModules = ["nvme" "ahci" "xhci_pci" "usbhid" "uas" "sd_mod"];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = true;
}
