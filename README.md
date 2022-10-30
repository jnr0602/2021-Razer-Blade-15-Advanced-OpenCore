2021 Razer Blade 15 Advanced - OpenCore - macOS Ventura
===================

- [2021 Razer Blade 15 Advanced - OpenCore - macOS Ventura](#2021-razer-blade-15-advanced---opencore---macos-ventura)
  - [Hardware](#hardware)
  - [Additional Notes](#additional-notes)
    - [SMBIOS](#smbios)
    - [Battery](#battery)
    - [Sleep](#sleep)
    - [Using external displays](#using-external-displays)
  - [Resources](#resources)

## Hardware

**Razer Blade Advanced Early 2021 (RZ09-0367)**

| | Spec | macOS 13 compatibility |
| ---: | :--- | :--- |
| ``Chipset`` | Mobile Intel HM470 | No issues |
| ``CPU`` | Intel Core i7-10875H processor, 8 Cores / 16 Threads, 2.3GHz / 5.1GHz, 16MB Cache | No issues |
| ``Memory`` | 32GB dual-channel DDR4-2933MHz, up to 64GB | No issues |
| ``GPU`` | Intel UHD Graphics 630 | No issues |
| ``dGPU`` | Nvidia 3080 Max-Q (16GB GDDR6 VRAM) | Disabled for macOS. |
| ``Storage`` | NVMe CA5-8D1024 1TB NVMe M.2 SSD | No Issues  |
| ``Screen`` | 15.6" QHD 240Hz, 2560 x 1440 IPS |  Only works at 60hz for now. I'm trying to figure out what else I can do to get it working at a higher refresh rate. |
| ``Webcam`` | Windows Hello built-in IR HD webcam (1MP / 720P) |  No issues. Windows Hello is not supported in macOS |
| ``WiFi`` | BCM943602CS Airport Card (BCM43602 802.11ac) | Works natively. This card is from a 2015 MacBook Pro 15" and can be found for [fairly cheap on eBay](https://www.ebay.com/sch/i.html?_nkw=BCM943602CS). I had to run an extra antenna cable to get the best compatibility. However, you should be able to use the [BCM94360CS2](https://www.ebay.com/sch/i.html?_nkw=BCM94360CS2) from a 2015 MacBook Pro 13" (it only has two antenna cables). |
| ``Input & Output`` | USB 3.2 Gen 2 (USB-A) x3 | No issues |
| | USB-C 3.2 Gen 2 x2 (Shared with Thunderbolt 3 Port) | No issues |
| | Thunderbolt 3 (USB-C) | USB-C works (both USB 2 and 3 devices), Thunderbolt is untested. |
| | HDMI 2.1 | HDMI connected directly to Nvidia GPU and will not work in macOS |
| | UHS-III SD card reader | Untested, macOS shows card reader in System Information |
| ``Sound`` | Realtek ALC298 | Working after adjusting codec. At some point I will create a PR for the official AppleALC repo |
| ``Microphone`` | | Working after adjusting codec. |
| ``Battery`` | 80Wh | Seems to work just fine with decent battery life with ACPI patches. |
| ``Keyboard`` | Per key RGB Powered by Razer Chroma anti-ghosting backlit keyboard | No issues. I use a modified version of [BlvckBytes](https://github.com/BlvckBytes) for [MenuBar app](https://github.com/BlvckBytes/RazerControl/releases) to control Razer Blade keyboard and logo RGB lighting. Capslock light needs to have Karabiner Elements installed to see the light. |
| ``Touchpad`` | Glass touchpad (Microsoft Precision Touchpad) | No issues with proper ACPI patches and I2C kexts. Palm rejection isn't as good as I'd like, but it's not too big of deal. |

## Additional Notes

### SMBIOS

You will need to generate your own MLB/ROM/SN/SmUUID if you use my `config.plist` (they are currently blank). I am currently using `MacBookPro16,3` SMBIOS to help with battery life.

### Battery
Battery life is pretty decent. I can get around 4 hours on a single charge. I'm using the `MacBookPro16,3` SMBIOS since those MacBook models don't have a dGPU. However, I'm not sure if it really makes a difference vs `MacBookPro16,1` SMBIOS.

~~Battery life is kinda iffy. On Linux/Windows I can get 4-6 hours of battery, but on macOS using `16,1` bios it is always around 1-2 hours. I'm currently experimenting with using `MacBookPro16,3` SMBIOS to help with battery life. I've noticed with the `16,1` bios, occasionally the iGPU frequency stays really high and uses more watts (CPU package total is around 10-12W even at idle). This may be attributed to the `16,1` and `16,4` MacBooks having a switchable dGPU and power management gets messed up on the hackintosh side (I can't confirm though, just a guess). `16,2` and `16,3` MacBooks are the 13" without a dGPU. They also are 10th Gen Intel CPUs as well. So hopefully it's a more compatible SMBIOS for the Razer Blade 15. So far my testing has shown that CPU package total is around 2-3W at idle using the `16,3` bios. YMMV.~~

I also noticed that `mds_stores` (aka Spotlight Indexing) was causing my machine to use quite a lot CPU in the background and drain battery very quickly. I have disabled Spotlight for the time being using the following command.

```bash
sudo mdutil -a -i off
```

You can turn it back on by running
```bash
sudo mdutil -a -i on
```

### Sleep

Sleep generally works well. At first, the machine would not turn on the screen after wake from sleep when I closed to lid to initiate sleep. After some research, I added the `SSDT-PTSWAK.aml` ACPI file to try and force the EC to show that the lid was open (inspiration was from [vampjaz's repo](https://github.com/vampjaz/razer_blade_stealth_hackintosh) on the Razer Blade Stealth since they had the same issue). Occasionally this fix doesn't work, but all it takes to fix is to wait for the machine to fall back asleep and then press the power button to wake the computer.

### Using external displays
Although the RB15 has it's DP and HDMI ports connected to the dGPU, I've had great success using DisplayLink adapters to drive my dual 4K monitors at 60hz. I'm currently using the [Plugable USBC-6950-DP](https://plugable.com/products/usbc-6950-dp/) adapter. DisplayLink is great for the tasks I use macOS for (coding, browsing the web, watching videos, etc.). I did try it on Windows and played a game and it did okay, but seemed to frame skip occasionally.


## Resources
My setup is based off the following repos:
* https://github.com/stonevil/Razer_Blade_Advanced_early_2019_Hackintosh
* https://github.com/vampjaz/razer_blade_stealth_hackintosh
* https://github.com/Narcoroni/Razer-Blade-2021-Hackintosh


