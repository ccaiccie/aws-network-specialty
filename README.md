# AWS network specialty

## Packet inspection designs

[Multipage draw.io atlas](2026-11-04-0203-aws-packet-inspection-atlas.drawio) · [Combined report](2026-11-04-0203-aws-packet-inspection-atlas.md) · [Terraform labs](2026-11-04-0203-terraform/)

Each design has a standalone Markdown guide, an exported SVG, and an explicit Terraform lab or shared integration lab. All addresses are examples. Terraform validation is local; cloud behavior remains to be tested in your environment.

- **01. [Network Firewall — zonal egress before NAT](2026-11-04-0203-aws-01-network-firewall-zonal-egress-before-nat.md)** — [SVG](previews/2026-11-04-0203-aws-01.svg) · [Terraform](2026-11-04-0203-terraform/native-egress/README.md)
- **02. [Network Firewall — public ingress and edge routes](2026-11-04-0203-aws-02-network-firewall-public-ingress-and-edge-routes.md)** — [SVG](previews/2026-11-04-0203-aws-02.svg) · [Terraform](2026-11-04-0203-terraform/endpoint-routes/README.md)
- **03. [TGW — inspection VPC with separate route domains](2026-11-04-0203-aws-03-tgw-inspection-vpc-with-separate-route-domains.md)** — [SVG](previews/2026-11-04-0203-aws-03.svg) · [Terraform](2026-11-04-0203-terraform/tgw-domains/README.md)
- **04. [TGW-attached Network Firewall — managed attachment](2026-11-04-0203-aws-04-tgw-attached-network-firewall-managed-attachment.md)** — [SVG](previews/2026-11-04-0203-aws-04.svg) · [Terraform](2026-11-04-0203-terraform/tgw-native-firewall/README.md)
- **05. [Distributed GWLBE — centralized appliance service](2026-11-04-0203-aws-05-distributed-gwlbe-centralized-appliance-service.md)** — [SVG](previews/2026-11-04-0203-aws-05.svg) · [Terraform](2026-11-04-0203-terraform/gwlb-service/README.md)
- **06. [Direct NVA and VPC Route Server](2026-11-04-0203-aws-06-direct-nva-and-vpc-route-server.md)** — [SVG](previews/2026-11-04-0203-aws-06.svg) · [Terraform](2026-11-04-0203-terraform/route-server/README.md)
- **07. [Cloud WAN — send-via and send-to](2026-11-04-0203-aws-07-cloud-wan-send-via-and-send-to.md)** — [SVG](previews/2026-11-04-0203-aws-07.svg) · [Terraform](2026-11-04-0203-terraform/cloud-wan-policy/README.md)
- **08. [Hybrid — Direct Connect or Site-to-Site VPN to TGW](2026-11-04-0203-aws-08-hybrid-direct-connect-or-site-to-site-vpn-to-tgw.md)** — [SVG](previews/2026-11-04-0203-aws-08.svg) · [Terraform](2026-11-04-0203-terraform/tgw-domains/README.md)
- **09. [Web ingress — ALB/WAF versus NLB passthrough](2026-11-04-0203-aws-09-web-ingress-alb-waf-versus-nlb-passthrough.md)** — [SVG](previews/2026-11-04-0203-aws-09.svg) · [Terraform](2026-11-04-0203-terraform/alb-waf/README.md)
- **10. [Network Firewall rules and TLS inspection](2026-11-04-0203-aws-10-network-firewall-rules-and-tls-inspection.md)** — [SVG](previews/2026-11-04-0203-aws-10.svg) · [Terraform](2026-11-04-0203-terraform/tls-inspection/README.md)
- **11. [GWLB overlay routing — vendor DMZ variant](2026-11-04-0203-aws-11-gwlb-overlay-routing-vendor-dmz-variant.md)** — [SVG](previews/2026-11-04-0203-aws-11.svg) · [Terraform](2026-11-04-0203-terraform/gwlb-service/README.md)

- **12. [Native Terraform lab topology](2026-11-04-0203-aws-12-native-terraform-lab-topology.md)** — [SVG](previews/2026-11-04-0203-aws-12.svg) · [Terraform](2026-11-04-0203-terraform/native-egress/README.md)

## Existing study materials

The existing `docs/` and `Docs/` directories are preserved. [Daily study index](docs/index.html).

