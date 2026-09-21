#!/usr/bin/env bash
# List security-group rules that expose admin / database ports to the whole internet,
# across every enabled region. Read-only: needs ec2:DescribeRegions and ec2:DescribeSecurityGroups.
#
#   ./open-admin-ports.sh                # uses your default AWS profile
#   AWS_PROFILE=prod ./open-admin-ports.sh
#
# Output (TSV): region  group-id  group-name  protocol  ports  source
set -euo pipefail

PORTS='[22,23,3389,445,1433,1521,3306,5432,5900,6379,9200,27017]'

audit_region() {
  jq -r --arg region "$1" --argjson ports "$PORTS" '
    .SecurityGroups[] as $g
    | $g.IpPermissions[] as $p
    | ( [$p.IpRanges[]?.CidrIp, $p.Ipv6Ranges[]?.CidrIpv6] | map(select(. == "0.0.0.0/0" or . == "::/0")) ) as $open
    | select($open | length > 0)
    | select($p.IpProtocol == "-1" or any($ports[]; . >= $p.FromPort and . <= $p.ToPort))
    | [$region, $g.GroupId, $g.GroupName,
       (if $p.IpProtocol == "-1" then "all" else $p.IpProtocol end),
       (if $p.IpProtocol == "-1" then "all" elif $p.FromPort == $p.ToPort then "\($p.FromPort)" else "\($p.FromPort)-\($p.ToPort)" end),
       ($open | join(","))]
    | @tsv'
}

if [[ "${1:-}" == "--from-json" ]]; then  # offline mode: audit a saved describe-security-groups output
  audit_region "${3:-offline}" < "$2"
  exit
fi

for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text); do
  aws ec2 describe-security-groups --region "$region" --output json | audit_region "$region"
done
