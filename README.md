cf_update_dns
=============

Script to update CloudFlare DNS through the API system

You need to fill in the following two variables with your data:

- CF_TOKEN
- CF_EMAIL

```bash
Usage: cf_update_dns.sh <oldip> <newip> <domain>
```

**KNOWN ISSUES**

service_mode is set to 1 for all updates, that means CloudFlare is turned ON for all updates. This should be configurable in either the script, or via the CLI.

For now, the workaround is to just login to the UI and click on the "Cloud" to turn it off.
