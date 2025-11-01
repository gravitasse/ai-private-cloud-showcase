# Presales BOM — AI Private Cloud

## Starter (3 nodes)
1. Control/Infra node (1U, EPYC 9354P, 128GB, 2x960GB, 2x25G)
2. NVIDIA GPU worker (2U, 512GB, 2x1.92TB NVMe, 2x NVIDIA H100/L40S, 2x100G)
3. Intel/Gaudi worker (2U, 512GB, 2x1.92TB NVMe, 2x Gaudi 3 or Intel DC GPU Max, 2x100G)
4. 48x25G + 6x100G ToR
5. Ubuntu LTS + K8s + Cilium + Rook-Ceph
6. NVIDIA GPU Operator + Intel Device Plugins Operator

## Growth (6–8 nodes)
- 1–2 control nodes
- 3x NVIDIA GPU workers
- 2x Intel/Gaudi workers
- 1x storage/Ceph node
- 2nd ToR/VPC

## Composition-ready (Liqid)
- 2x control nodes
- 4–6x GPU workers (diskless or low-GPU)
- 1x Liqid Matrix director
- 2–3x GPU expansion chassis
- 2x 100/200G spines
