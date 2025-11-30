# AI Private Cloud – Overview

## Architecture Overview
High-level layout of the private AI cloud: control pHigh-level layout of the private AI cloud: control pHigh-level layout of the private AI cloudms/ai-private-cloud-topologHigh-level layout of the private AI cloud: control pHigh with a minimal node count (1–3 nodes) and grow linearly. Infra is provisioned with Terraform, nodes are configured and joined with Ansible, and Kubernetes scheduHigh-level layout of the private AI cloud: control pilHigh-level layout of the private AI cloud: control pHigh-levdaHigh-level layout of the private AI cloud: control alHigh-level layout of the private AI cloud: control pH(..High-level layoutoudHigh-level layout of the private AI cloud: control pHigh-level layout of the private AI canHigh-level layout of the private AI cloud: cont
p = Path("README.md")
text = p.read_text()
replacements = {
    "#architecture-overview": "#architecture-overview",
    "#linear-scaling-model": "#linear-scaling-model",
    "#multi-cloud--failover-pattern": "#multi-cloud--failover-pattern",
    "#gpu--npu-enablement": "#gpu--npu-enablement",
    "#deployment-flow-reference": "#deployment-flow-reference",
    "#repository-links": "#repository-links",
}
for old, new in replacements.items():
    text = text.replace(old, new)
p.write_text(text)
PY

git add docs/overview.md README.md
git commit -m "docs: normalize headings so section links work"
git push origin main
