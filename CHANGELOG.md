# Version 0.3 (2021-07-05)
- Added `enable_integrity_monitoring` and `enable_secure_boot` both to `true` as default
- Added `target_tags` to the ingress-nginx firewall rule
- Removed Service Account impersonation (this should be set outside of this module)
- Possibility to define custom cluster's master authorized networks
- Possibility to specify the HTTP endpoint for the automatic retrival of the machine's public IP (used as default master authorized network)

# Version 0.2 (2021-06-28)
- Added support for custom node pools tains and labels

# Version 0.1 (2021-06-24)
- First release!