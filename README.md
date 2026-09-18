# ARBITER x NENRIN A2A Fixture

A frozen, reproducible interoperability fixture demonstrating **trust-order separation** for a real multi-candidate A2A state.

> **Evidence remains evidence. Permission remains permission. Ordering remains ordering.**

## Boundary

```text
discovery / registry
        |
        v
NENRIN candidate evidence
        |
        v
reference trust filter
        |
        v
finite permitted field
        |
        v
ARBITER ordering
        |
        v
authorization / payment / A2A invocation
```

NENRIN preserves evidence and surfaced conflicts. The reference trust filter determines the finite permitted field. ARBITER orders only that permitted field. Authorization and execution remain outside both layers.

## Frozen upstream state

Repository:

`https://github.com/ogasurfproject-jpg/horizon-shield`

Commit:

`62b60205ef0b2094e2f75becba34edfcb99cbb65`

The complete frozen `workers/hs-ledger` subtree is vendored under:

`upstream/workers/hs-ledger/`

Original candidate fixture:

`upstream/workers/hs-ledger/nenrin/provenance-v0/candidate_fixture.json`

Original verifier:

`upstream/workers/hs-ledger/nenrin/provenance-v0/verify_candidate_fixture.mjs`

The original fixture remains unchanged and its `run_record.order` remains `null`.

## Result

Permitted field:

```json
["cand_alpha", "cand_bravo"]
```

ARBITER order:

```json
["cand_alpha", "cand_bravo"]
```

| Candidate | ARBITER measurement |
| --- | ---: |
| `cand_alpha` | `0.5492187943968523` |
| `cand_bravo` | `0.5288691683323712` |

`cand_bravo` reached ARBITER with its witness disagreement still present in the NENRIN evidence.

`cand_charlie` did not enter the candidate field because the separate reference trust filter excluded the provider-equivocation candidate fail-closed.

The completed **derived** fixture is:

`derived/candidate_fixture_completed.json`

Only `run_record.order` is filled from the recorded ARBITER result. The frozen upstream fixture is not modified.

## Integrity

Exact ARBITER request:

`artifacts/arbiter_compare_input.json`

SHA-256:

`45c129adb322b5782ed098a772fff2dd11e09857ced22388849973b518179ea7`

Exact ARBITER response:

`artifacts/arbiter_compare_response.json`

SHA-256:

`efa18ac9fb55cb4f04322c9e15109091ddd0e32ad8445353c29865f96706e363`

All artifact paths and hashes are recorded in `manifest.json`.

## Verify

```bash
chmod +x VERIFY.command
./VERIFY.command
```

Verification runs the frozen NENRIN verifier from its preserved repository-relative path, checks every artifact hash, confirms the upstream fixture still has `order: null`, confirms `permitted`, and confirms the derived fixture contains the exact ARBITER order.

## Established composition

```text
evidence -> permitted -> order -> recorded result
```

This fixture demonstrates that unresolved evidence can remain intact through filtering and into deterministic ordering without conflating evidence, permission, and ordering.

## Claim boundary

The fixture does **not** establish that witness disagreement caused the measurement difference. A causal claim would require a controlled counterfactual changing only that disagreement.

ARBITER does not determine identity, trust, permission, authorization, or execution here. NENRIN candidate evidence does not determine the ARBITER order.

## Links

ARBITER integration:

https://github.com/ziolndr/arbiter-agent-routing

A2A discussion:

https://github.com/a2aproject/A2A/discussions/1631
