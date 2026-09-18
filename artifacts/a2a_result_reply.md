@ogasurfproject-jpg Closed the loop against the frozen NENRIN fixture at `62b60205ef0b2094e2f75becba34edfcb99cbb65`.

NENRIN offline verification: **PASS**

`run_record.permitted`:

`["cand_alpha", "cand_bravo"]`

ARBITER `/v1/compare` returned this deterministic order:

`["cand_alpha", "cand_bravo"]`

Scores:

- `cand_alpha` — `0.5492187943968523`
- `cand_bravo` — `0.5288691683323712`

`cand_bravo` reached ARBITER with the witness disagreement still present in its NENRIN evidence. `cand_charlie` never entered the candidate field because the separate reference trust filter excluded it for provider equivocation.

So the composition completed exactly at the intended seam:

`NENRIN evidence`
→ `reference trust filter`
→ `permitted`
→ `ARBITER order`

ARBITER input SHA-256:

`45c129adb322b5782ed098a772fff2dd11e09857ced22388849973b518179ea7`

ARBITER response SHA-256:

`efa18ac9fb55cb4f04322c9e15109091ddd0e32ad8445353c29865f96706e363`

Please write the returned order into `run_record.order` unchanged:

`["cand_alpha", "cand_bravo"]`

That closes the public fixture:

`evidence → permitted → order → recorded result`
