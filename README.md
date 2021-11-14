# range-images

A collection of Amazon Machine Images built with Packer for blue team simulations.

Some of these images are intentionally compromised/misconfigured/insecure and they should not be exposed publicly to the internet.

## Images

### Blue

Images (mis)configured for blue team use.

| Name | Operating System | Version | Description |
| ---- | ---------------- | ------- | ----------- |
| blue-debian-dnsmasq | Debian | 9 | Debian image configured with dnsmasq |
| blue-redhat-lamp | Red Hat Linux | 7.0 | Red Hat image configured as a LAMP stack |
| blue-ubuntu-lamp | Ubuntu Server | 18.04 | Ubuntu Server image configured as a LAMP stack |
| blue-ubuntu-mongodb | Ubuntu Server | 18.04 | Ubuntu Server image configured with MongoDB |
| blue-ubuntu-splunk | Ubuntu Server | 18.04 | Splunk SIEM for network/event monitoring|
| blue-ubuntu-workstation | Ubuntu Server | 16.04 | Ubuntu workstation |

### Red

Images configured for red team use.

| Name | Operating System | Version | Description |
| ---- | ---------------- | ------- | ----------- |
| red-kali | Kali Linux | 2021.3 | Kali image preinstalled with a variety of tools |
