# Network Security Playbook

Practical, copy-ready snippets I use in network and cloud security work: hardening baselines, quick exposure checks, detection rules and change runbooks. Each file is short, commented, and meant to be adapted, not pasted blindly.

| Area | File | What it's for |
|---|---|---|
| AWS | [`aws/open-admin-ports.sh`](aws/open-admin-ports.sh) | Find security groups exposing SSH, RDP, databases… to `0.0.0.0/0` or `::/0` in every region (read-only) |
| FortiGate | [`fortigate/management-hardening.conf`](fortigate/management-hardening.conf) | Management plane: no admin on WAN, trusted hosts, lockout, strong crypto, password policy |
| Cisco ASA | [`cisco-asa/management-hardening.txt`](cisco-asa/management-hardening.txt) | SSH / ASDM only from the admin network, modern ciphers, AAA, logging |
| Juniper SRX | [`juniper-srx/management-hardening.set`](juniper-srx/management-hardening.set) | Host-inbound traffic per zone, SSH and login hygiene |
| Wazuh | [`wazuh/local_rules.xml`](wazuh/local_rules.xml) | Alert on SSH logins from outside the admin network |
| Runbooks | [`runbooks/firewall-cutover.md`](runbooks/firewall-cutover.md) | Firewall migration / cutover checklist with validation tests and rollback |

### Try the AWS check without an AWS account

```bash
./aws/open-admin-ports.sh --from-json aws/sample-security-groups.json
```

## Related

- [fw-rule-audit](https://github.com/hrkh1990/fw-rule-audit): audit Cisco ASA rule bases before a migration

## About

Maintained by [Hamidreza Khazaie](https://www.secureops.it), network & cloud security consultant in Rome. Issues and suggestions welcome.

Snippets are provided as-is (MIT). Always test in a lab or maintenance window first.
