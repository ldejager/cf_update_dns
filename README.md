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
