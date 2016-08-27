# IPTables Dynamic IP

This script will allow you to dynamically add/remove a dynamic IP without having
to modify your rules directly. This script works by defining a new chain,
directing all rules to it and then having an accept all rule based on source IP.
If your input chain does not have a drop action by default, you will need to add
one after any or all jump rules to the DYNAMIC chain.

## Setup

You will want to be sure to define the DYNAMIC chain as well as any rules that you
want applied to the dynamic IP.

```
:DYNAMIC - [0:0]
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j DYNAMIC
```

And a Cron entry

```
*/5 * * * * /usr/local/sbin/iptables_dynamic_ip.sh 2>&1 | /usr/bin/logger -t iptables-dynamic-ip
```
