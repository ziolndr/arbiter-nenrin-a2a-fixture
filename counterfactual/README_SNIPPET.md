## Controlled counterfactual: `disagreement_hops`

A single-variable ablation was run against the same task and candidate field.

Only one semantic leaf changed:

```text
cand_bravo ... disagreement_hops: 1 -> 0
```

Everything else in the comparison input was held constant.

Baseline:

```text
cand_alpha: 0.5492187943968523
cand_bravo: 0.5288691683323712
order: ["cand_alpha", "cand_bravo"]
```

Counterfactual:

```text
cand_alpha: 0.5492187943968523
cand_bravo: 0.5300447801971727
order: ["cand_alpha", "cand_bravo"]
```

Delta:

```text
cand_alpha: +0.0000000000000000
cand_bravo: +0.0011756118648015
```

The non-zero `cand_bravo` delta demonstrates ARBITER sensitivity to this exact `disagreement_hops` field change.

This does **not** establish the broader claim that witness disagreement, as a general concept, caused the original ranking difference. It establishes only the effect of this controlled representation-level ablation.
