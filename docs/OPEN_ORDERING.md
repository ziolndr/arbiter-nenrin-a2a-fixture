# Open Ordering: Why Agent Selection Must Be Portable

A2A gives agents a common way to describe themselves, discover one another, and exchange work.

Discovery creates a second problem:

> Once several agents are trusted, permitted, and capable of receiving a task, which candidate should be considered first?

That is an ordering problem.

The central proposal here is not that ordering must happen on an external service. It is that **ordering should be separable, portable, and reproducible**.

A marketplace should be free to execute its ordering primitive entirely inside its own network. The architectural requirement is that trust, permission, ordering, authorization, and execution remain distinguishable.

## The boundary

```text
discovery
-> evidence
-> trust / policy
-> permitted candidate field
-> ordering
-> authorization
-> execution
```

Each layer answers a different question.

**Discovery:** Who exists?

**Evidence:** What is known about them?

**Trust / policy:** Who may participate?

**Ordering:** Of the permitted candidates, which best fits this task and context?

**Authorization:** May the resulting action occur?

**Execution:** Perform it.

Collapsing these functions into a single opaque ranking mechanism makes the implementation simpler internally, but makes the resulting network harder to inspect and reproduce.

## Trust can remain local while ordering remains portable

A marketplace has legitimate reasons to keep its trust model private and local.

It may possess private transaction histories, operator policies, fraud signals, contractual constraints, jurisdictional restrictions, reliability records, or customer-specific rules.

Those inputs can determine the permitted field without also defining the ordering primitive.

For example:

```text
Marketplace A
trust policy -> [Agent 1, Agent 2]
             -> ordering(task, candidates)

Marketplace B
trust policy -> [Agent 2, Agent 3]
             -> ordering(task, candidates)
```

The marketplaces retain control over admission.

The ordering boundary can still be consistent and reproducible.

## Open does not mean remote

Portable ordering does not require a marketplace to send its task or candidate field to an outside provider.

The same ordering contract can be:

- executed locally beside the router;
- embedded into the marketplace runtime;
- exposed as a service;
- installed into an agent runtime;
- or carried through an A2A extension.

The requirement is **separation of concerns**, not network topology.

A system should be able to state:

```text
Here was the task.
Here was the permitted candidate field.
Here was the ordering primitive.
Here was the returned order.
```

and make that decision reproducible without exposing or recreating the marketplace's entire trust system.

## Why this boundary matters

If evidence, trust, commercial policy, task fit, historical performance, and routing are all collapsed into one private score, it becomes difficult to determine why two marketplaces route the same task differently.

Separation makes the source of variation explicit:

```text
different permitted field
-> expected marketplace-specific difference

same permitted field + same task + same ordering primitive
-> reproducible order
```

This is useful even when every component runs inside the same marketplace.

## Reference interoperability fixture

NENRIN and ARBITER now provide a frozen executable example of this boundary.

NENRIN supplies re-verifiable candidate evidence and preserves surfaced conflicts.

A separate reference trust filter produces the finite permitted field:

```json
["cand_alpha", "cand_bravo"]
```

ARBITER receives that permitted field plus the current task/context and returns:

```json
["cand_alpha", "cand_bravo"]
```

The composition is:

```text
NENRIN evidence
-> reference trust filter
-> permitted
-> ARBITER order
-> recorded result
```

The upstream NENRIN fixture deliberately leaves `run_record.order` empty. ARBITER fills only that slot.

Full reproducible fixture:

https://github.com/ziolndr/arbiter-nenrin-a2a-fixture

## Controlled counterfactual

The same fixture supports a one-variable ablation.

The baseline `cand_bravo` evidence contains:

```text
disagreement_hops = 1
```

The counterfactual changes exactly that semantic leaf:

```text
disagreement_hops = 0
```

The task, candidate IDs, `cand_alpha`, and every other `cand_bravo` field remain constant.

Observed measurements:

```text
baseline
cand_alpha  0.5492187943968523
cand_bravo  0.5288691683323712

counterfactual
cand_alpha  0.5492187943968523
cand_bravo  0.5300447801971727

delta
cand_alpha +0.0000000000000000
cand_bravo +0.0011756118648015
```

The order remained unchanged.

The supported claim is deliberately narrow:

> **ARBITER is sensitive to this exact surfaced `disagreement_hops` field change under a one-variable ablation.**

This does not establish that witness disagreement as a general concept caused the original ranking difference. That broader claim would require additional controlled experiments.

## Protocol principle

> **Evidence remains evidence. Permission remains permission. Ordering remains ordering.**

An open ordering boundary does not require one universal marketplace, one trust system, one hosted service, or one ranking algorithm.

It means an implementation can expose a clean contract:

```text
input:
  current task/context
  finite permitted candidate field

output:
  deterministic candidate order
```

Trust systems remain responsible for membership in the permitted field.

Marketplaces remain responsible for authorization and execution.

Ordering remains independently inspectable and reproducible.

That is the distinction between **open ordering** and a proprietary all-in-one ranking score.
