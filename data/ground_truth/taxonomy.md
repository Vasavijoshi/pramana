# Synthetic Fabrication Taxonomy

*Location in repo: `data/ground_truth/taxonomy.md`*
*Status: frozen — built after `known_cases.md`, drives synthetic example construction in Sprint 5*

Six categories, eleven sub-variants total. Every sub-variant is justified by a pattern actually observed in the three real incidents documented in `known_cases.md` — nothing here is speculative.

---

### 1. Existence-Fabrication — target 35%
- **1a. Pure invention** — case name resolves to nothing, no real case remotely resembles it. (Case 2's category, cleanest form.)
- **1b. Identity-swap fabrication** — a fabricated case name that superficially resembles a real, unrelated case in the corpus (Case 3's sixth citation). Exists specifically to stress-test the existence check's similarity threshold. Weight at roughly a quarter of the existence-fabrication examples — rare in the wild, disproportionately dangerous if the matcher is too loose.
- **1c. Plausible-but-generic invented names** — "XYZ Welfare Society v. State" style names that sound exactly like real Indian case naming conventions. These are the ones a human reviewer skims past; a meaningful share of the existence-fabrication set should use realistic naming, not obviously fake ones.

### 2. Locality-Fabrication — target 20%
- **2a. Wildly out-of-range** — paragraph 900 cited in a 12-paragraph order (easy).
- **2b. Just-barely-out-of-range** — paragraph 28 cited in a 27-paragraph judgment (Case 2's actual pattern — the realistic, dangerous version, since it reads as entirely plausible to a human).
- **2c. Off-by-a-small-margin due to source disagreement** — deliberately hard, not-clearly-wrong: a paragraph number valid against one reproduction of a judgment but not another, due to headnote-inclusion differences between sources. Build 1–2 of these specifically to pressure-test whether the `total_paragraphs` field is robust to source variance.

### 3. Exact Quote-Mismatch (Fidelity, easy) — target 15%
- Quote is present, attributed to a real paragraph in a real case, but the wording is substantially different — not a subtle edit, a clearly different sentence. Should be caught by string-similarity scoring alone, no LLM needed.

### 4. Subtle Misrepresentation (Fidelity, hard) — target 15%
- **4a. Word-level alteration** — 2–3 words changed, meaning shifts, grammar stays fluent.
- **4b. Holding-reversal misrepresentation** — quote is nearly verbatim, but a negation or qualifier is dropped or added ("the court held X" vs. "the court declined to hold X"). More dangerous and subtler than word-substitution, closer to real-world misuse.
- **4c. Case-identity misattribution** — Case 3's exact pattern: correct-sounding quote, wrong case entirely. Structurally different from 4a/4b (an existence + fidelity hybrid) — tracked as its own labeled sub-type so evaluation can separately measure how well the pipeline catches this specific compound failure.

### 5. Legitimate Paraphrase, No Quote Claimed (false-positive guard rail) — target 10%
- A citation with no direct quote — should never be flagged. This is the trust-determining category.
- One sub-case: a legitimately-written paraphrase using slightly formal, repetitive phrasing (the kind a nervous law student might write) — must confirm the system does **not** flag it just because it superficially resembles the AI-generation stylistic tells from Case 1. Otherwise the tool penalizes stiff writing, not fabrication.

### 6. Temporal / Overruled-Status Case — target 5%
- A genuinely real, genuinely correctly-quoted citation — but to a judgment that has since been overruled or set aside. Explicitly **out of scope for v1** — the rubric does not currently define a verdict for "technically verified but no longer good law," and should not try to in Sprint 1. Include 1–2 of these labeled `UNVERIFIABLE — out of scope`, so the Sprint 12 evaluation doesn't quietly penalize the system for not solving a problem it was deliberately not built to solve.

---

**Locked target ratio:** 35% existence / 20% locality / 15% fidelity-easy / 15% fidelity-hard / 10% legitimate-paraphrase / 5% out-of-scope-temporal. Sums to 100%.

---

## Taxonomy Evolution Policy

This taxonomy is frozen for the duration of v1 evaluation. New categories may be proposed only if a real-world incident surfaces that cannot be represented by any existing category or sub-variant. Existing categories and their target ratios must not be reweighted once synthetic dataset generation (Sprint 5) has begun — doing so changes the benchmark itself, not just the data, and quietly invalidates any evaluation numbers already produced against the earlier version. Any genuine change goes through the same versioning discipline as `known_cases.md`: a new version marker, not a silent edit.
