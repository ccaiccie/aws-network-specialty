# AWS read-only checks

Replace uppercase placeholders with your lab values. These inspect state; they do not deploy infrastructure.

```bash
aws sts get-caller-identity
aws ec2 describe-route-tables
aws ec2 describe-transit-gateway-route-tables
aws network-firewall describe-firewall --firewall-name LAB_NAME
aws ec2 describe-vpc-endpoints
aws elbv2 describe-target-health --target-group-arn TARGET_GROUP_ARN
```

Use the matching design guide for rule-hit, tuple, NAT and reverse-path evidence. A healthy resource is not by itself proof of inline inspection.
