cf_update_dns
=============

Simple script that grabs all DNS records from CloudFlare for a given domain and updates the records through the CloudFlare API system with the given new IP address.

It beats having to do updates manually.


You need to fill in the following two variables with your data:

- CF_TOKEN
- CF_EMAIL

```bash
cf_update_dns.sh <oldip> <newip> <domain>
```

**KNOWN ISSUES**

service_mode is set to 1 for all updates, that means CloudFlare is turned ON for all updates. This should be configurable in either the script, or via the CLI.

For now, the workaround is to just login to the UI and click on the "Cloud" to turn it off.
