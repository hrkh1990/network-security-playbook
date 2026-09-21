# Firewall cutover runbook

A template for replacing or migrating a firewall in a planned window. Copy it into your change ticket and fill in the blanks.

> I’d rather spend an extra day planning than an extra night rolling back.

## 1. Before the window

- [ ] Rule base reviewed: unused, shadowed and any-any rules removed or justified (see [fw-rule-audit](https://github.com/hrkh1990/fw-rule-audit))
- [ ] New config staged and peer-reviewed; diff attached to the change
- [ ] Test list agreed with the application owners (section 3)
- [ ] Rollback steps written and rehearsed (section 4); old device stays powered and configured
- [ ] Console / out-of-band access to both devices confirmed
- [ ] Backups taken: running config, licences, certificates, VPN pre-shared keys (stored in a vault)
- [ ] Stakeholders and on-call contacts know the window and the go / no-go time

## 2. During the window

| Time | Step | Owner | Done |
|---|---|---|---|
| T-0:15 | Go / no-go call | | |
| T+0:00 | Freeze changes; capture baseline (routes, ARP, sessions, VPN SAs) | | |
| T+0:10 | Move cables / VLANs / routes to the new firewall | | |
| T+0:20 | Bring up VPNs and dynamic routing; check neighbours | | |
| T+0:30 | Run the test list | | |
| T+1:00 | **Decision point:** all critical tests pass → continue, else roll back | | |

## 3. Validation tests

| # | From | To | Service | Expected | Result |
|---|---|---|---|---|---|
| 1 | Internet | Public web | HTTPS | Allowed | |
| 2 | Internet | Admin interfaces | SSH / HTTPS | **Blocked** | |
| 3 | Branch office | Data centre | App traffic over VPN | Allowed | |
| 4 | User LAN | Database zone | SQL | **Blocked** | |
| 5 | Monitoring | Firewall | Syslog / SNMP received | Allowed | |

Test what must be blocked as carefully as what must work.

## 4. Rollback

Trigger rollback if any critical test fails and can't be fixed within ___ minutes, or by ___ at the latest.

1. Move cables / VLANs / routes back to the old firewall
2. Clear ARP / sessions where needed; confirm VPNs and routing are back
3. Re-run critical tests 1–5 on the old path
4. Record what failed for the next attempt

## 5. After

- [ ] Monitor logs and denied traffic for 24–48 hours
- [ ] Update diagrams, HLD / LLD and the runbook with anything learned
- [ ] Hand over: admin access, backups, support contacts
- [ ] Decommission the old device only after the agreed hold period
