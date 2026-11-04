# AWS Terraform lab: tgw-domains

Formatted and schema-validated with Terraform 1.17.1 and AWS 6.71.0. No authenticated cloud plan or apply was run. Provider validation checks HCL and resource schema; it does not prove API acceptance, regional eligibility, vendor readiness or packet behavior.

## What this creates and what must exist

### Atlas page 03

Creates pre/post TGW route tables, associations and inspection/delivery routes around existing dedicated attachments. Inspection VPC must already contain a ready Network Firewall endpoint or GWLB tier; use endpoint-routes for its subnet steering. All source attachments must be unattached to another route table or managed/imported deliberately.

Acceptance test: Enable appliance mode on the inspection VPC attachment through its owning Terraform configuration before testing. Disable bypassing default associations/propagations. Test A→B and B→A, then a deny and AZ/appliance failure. This root does not silently modify external attachments.

### Atlas page 08

Reuse TGW pre/post integration with existing DX gateway or VPN attachment included in source_attachments and its on-premises prefix in destinations. Actual Direct Connect circuits/VIFs, customer gateway, VPN tunnels and BGP are external prerequisites.

Acceptance test: Test on-premises→spoke and spoke→on-premises through the inspection logs. Fail the primary hybrid path and prove backup routes still enter the pre table. A direct propagated route in that table is a likely bypass.

## Inputs and execution

Input declarations: [2026-11-04-0203-variables.tf](2026-11-04-0203-variables.tf). Example values: [2026-11-04-0203-example.tfvars](2026-11-04-0203-example.tfvars). Replace every placeholder, documentation address and project/account ID. Inspect all resource targets before apply. Use dedicated lab fixtures; the integration roots can replace route or policy associations.

Authenticate with your selected AWS profile/role and run `aws sts get-caller-identity` before planning. Required permissions follow the resources in the root: EC2/VPC, Network Firewall, IAM/SSM for native-egress, and the specific TGW/Cloud WAN/ELB/WAF APIs for integration roots.

```bash
cp 2026-11-04-0203-example.tfvars lab.tfvars
# Edit lab.tfvars; never commit credentials or private keys.
terraform init
terraform fmt -check
terraform validate
terraform plan -var-file=lab.tfvars -out=lab.plan
# Review target account/project, all changes and estimated cost.
terraform apply lab.plan
terraform output
```

Run the page-specific acceptance tests above. Record DNS answer, source/destination tuple, route selection, rule hit, translation owner, reverse route and returned result. Use both an allowed and a denied fresh session. Test HA only in your isolated lab.

## Expected charges

Native egress incurs Network Firewall endpoint-hours/GB, NAT Gateway hours/GB, EC2/EBS, public IPv4 and logs. TGW adds attachment-hours and data processing. GWLB adds LB/capacity/endpoint usage and appliance compute/license. Route Server, Cloud WAN core edges/attachments and WAF requests/rules have their own charges. ACM Private CA can be a substantial standing cost; use an approved existing lab CA where practical.

Estimate `provisioned hours × regional hourly rates + processed GB + log ingestion + requests + licenses` in the [official calculator](https://calculator.aws/) before apply. No fixed dollar amount is reliable without your region, traffic volume, existing fixtures and license choices. Integration roots retain external infrastructure costs even after their own resources are destroyed.

## Destroy and rollback

```bash
terraform plan -destroy -var-file=lab.tfvars -out=destroy.plan
terraform apply destroy.plan
terraform state list
```

Destroy deletes the resources in this state only. External VPCs, appliances, circuits, CA pools, certificates, partner subscriptions, DNS and client CA trust remain your responsibility. Native GCP API enablement intentionally remains enabled on destroy. Export existing associations/policies before integration: deleting a lab association is not automatic restoration of an earlier one. Restore the old policy/route configuration with its owner and expect established sessions to reset. Cloud WAN policy attachment removal in particular is not a promise to revert the LIVE policy; restore the saved full policy explicitly.

## Official provider reference

[Pinned provider resources](https://github.com/hashicorp/terraform-provider-aws/tree/v6.71.0/website/docs/r)

## Scenario input files

- [2026-11-04-0203-hybrid.tfvars.example](2026-11-04-0203-hybrid.tfvars.example)
