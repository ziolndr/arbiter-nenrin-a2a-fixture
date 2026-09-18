#!/bin/zsh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

command -v node >/dev/null 2>&1 || { echo "FAILED · node is required" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "FAILED · python3 is required" >&2; exit 1; }

echo
echo "ARBITER × NENRIN · VERIFY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo
echo "1) Frozen NENRIN verifier"
echo "────────────────────────────────────────────────────────"
(
  cd upstream/workers/hs-ledger/nenrin/provenance-v0
  node verify_candidate_fixture.mjs
)

echo
echo "2) Artifact integrity + seam invariants"
echo "────────────────────────────────────────────────────────"

python3 - <<'PY'
import hashlib,json
from pathlib import Path

root=Path(".")
m=json.loads((root/"manifest.json").read_text())

for name,spec in m["artifacts"].items():
    p=root/spec["path"]
    if not p.exists():
        raise SystemExit(f"FAIL · missing {p}")
    got=hashlib.sha256(p.read_bytes()).hexdigest()
    if got != spec["sha256"]:
        raise SystemExit(
            f"FAIL · SHA mismatch {p}\nexpected {spec['sha256']}\ngot      {got}"
        )
    print(f"PASS · {name:<28} {got}")

source=json.loads((root/"upstream/workers/hs-ledger/nenrin/provenance-v0/candidate_fixture.json").read_text())
completed=json.loads((root/"derived/candidate_fixture_completed.json").read_text())
result=json.loads((root/"artifacts/arbiter_order_result.json").read_text())

def find_run_record(obj):
    if isinstance(obj,dict):
        rr=obj.get("run_record")
        if isinstance(rr,dict):
            return rr
        for v in obj.values():
            found=find_run_record(v)
            if found is not None:
                return found
    elif isinstance(obj,list):
        for v in obj:
            found=find_run_record(v)
            if found is not None:
                return found
    return None

src_rr=find_run_record(source)
done_rr=find_run_record(completed)

if src_rr is None or done_rr is None:
    raise SystemExit("FAIL · run_record missing")
if src_rr.get("order") is not None:
    raise SystemExit("FAIL · frozen upstream fixture order is not null")
if src_rr.get("permitted") != result.get("permitted"):
    raise SystemExit("FAIL · permitted mismatch")
if done_rr.get("order") != result.get("order"):
    raise SystemExit("FAIL · completed order mismatch")

print("PASS · frozen fixture order remains null")
print("PASS · permitted matches recorded ARBITER run")
print("PASS · derived fixture contains exact ARBITER order")
print()
print("ORDER ·",json.dumps(result["order"]))
PY

echo
echo "ALL PASS"

echo
echo "3) Controlled counterfactual"
echo "────────────────────────────────────────────────────────"

python3 - <<'PY'
import json,hashlib
from pathlib import Path

root=Path(".")
m=json.loads((root/"manifest.json").read_text())
cf=m.get("counterfactual")
if not cf:
    raise SystemExit("FAIL · counterfactual missing from manifest")

for name,spec in cf["artifacts"].items():
    p=root/spec["path"]
    if not p.exists():
        raise SystemExit(f"FAIL · missing {p}")
    got=hashlib.sha256(p.read_bytes()).hexdigest()
    if got != spec["sha256"]:
        raise SystemExit(f"FAIL · counterfactual SHA mismatch {p}")
    print(f"PASS · counterfactual {name:<16} {got}")

proof=json.loads((root/"counterfactual/change_proof.json").read_text())
result=json.loads((root/"counterfactual/result.json").read_text())

if proof["semantic_diff_count"] != 1:
    raise SystemExit("FAIL · ablation changed more than one semantic leaf")
if proof["before"] != 1 or proof["after"] != 0:
    raise SystemExit("FAIL · disagreement_hops transition mismatch")
if result["delta"]["cand_alpha"] != 0.0:
    raise SystemExit("FAIL · cand_alpha changed")
if result["delta"]["cand_bravo"] == 0.0:
    raise SystemExit("FAIL · cand_bravo showed no sensitivity")

print("PASS · exactly one semantic leaf changed")
print("PASS · cand_alpha remained unchanged")
print("PASS · cand_bravo changed under disagreement_hops ablation")
print("PASS · claim limited to this exact field change")
PY
