# Known Public Cases — Real, Verified Incidents of AI-Hallucinated Citations in Indian Courts

*Location in repo: `data/ground_truth/known_cases.md`*
*Status: frozen reference cases — anchor points for `labeled_test_set.json` (Sprint 5)*

**Ground Truth Version:** v1.0
**Frozen on:** 2026-07-08

A new landmark incident discovered later does not get inserted into this file. It becomes v1.1, appended below a new version marker, so the v1.0 evaluation benchmark this file defines never silently changes underneath work already done against it.

Every case below is a real, dated, sourced incident — not an illustrative placeholder. Each is mapped to Pramāṇa's rubric verdict and annotated with what it specifically teaches the verification pipeline.

---

## Case 1 — Existence-Fabrication, with AI-Signature Tells

**Case:** *Deepak v. Heart & Soul Entertainment Ltd.*
**Court:** Bombay High Court
**Date:** January 2026

**What happened:** In an eviction dispute, a litigant's submissions cited a judgment — "Jyoti w/o Dinesh Tulsiani vs Elegant Associates" — that the court could not trace anywhere. The court flagged tell-tale signs of AI-generated output, including green tick-marks and repetitive phrasing, and imposed Rs 50,000 in costs.

**Why this case matters for our ground truth, specifically:** this isn't just an existence-fabrication case — it's our one real example of a citation carrying stylistic fingerprints of AI generation that go beyond the citation string itself (formatting artifacts, repetition patterns). Pramāṇa v1's verifier does **not** check formatting artifacts — that's explicitly out of scope — but it's logged here as a documented future-work item so it doesn't quietly vanish from consideration.

**Verdict under our rubric:** `FABRICATED` (existence). The case name does not resolve to any real judgment in any traceable database — a pure existence failure, since no real underlying judgment exists to check a paragraph or quote against.

**Boundary note:** if our corpus doesn't happen to contain the correct universe of cases to check against, a naive system might return `UNVERIFIABLE` instead of `FABRICATED` here — which would be wrong in the real world (the case genuinely doesn't exist) but technically correct behavior for a corpus-limited v1 system that can only say "not found in my corpus," not "does not exist anywhere."

**Scoping statement (also belongs in `docs/rubric.md`):** Pramāṇa's `FABRICATED` verdict means *"not found in our corpus,"* not *"proven never to have existed anywhere."* Stated up front as an honest limitation, not discovered by a reviewer later.

---

## Case 2 — Locality-Fabrication (Our "27-Paragraph" Anchor Case)

**Case:** *Greenopolis Welfare Association v. Narender Singh*
**Court:** Delhi High Court
**Date:** September 2025

**What happened:** A petition in a flat-possession dispute was withdrawn after opposing counsel exposed its citations as fabricated. It quoted paragraphs 73 and 74 of the landmark *Raj Narain v. Indira Nehru Gandhi* judgment, which runs to only 27 paragraphs.

**Why this is the cleanest possible locality-fabrication example:** *Raj Narain v. Indira Nehru Gandhi* is a real, extremely well-known landmark judgment — this isn't "cite a case that doesn't exist," it's "cite a real, famous case, but reference paragraph numbers that mathematically cannot exist in it." This is exactly the shape of the locality check: `para_num <= total_paragraphs`. 73 > 27. Trivial arithmetic, catastrophic real-world consequence — a petition withdrawn under professional exposure.

**Verdict under our rubric:** `FABRICATED` (locality). The case exists (existence check passes) but the paragraph reference exceeds the judgment's actual length (locality check fails). Textbook two-stage verdict: existence ✅, locality ❌ → overall `FABRICATED`.

**Critical detail for the corpus record of this exact judgment (relevant when structuring the corpus later):** its `total_paragraphs` field must reflect the *original* judgment's paragraph count — not a headnote-inclusive count, not a count from a reformatted online reproduction that merges or splits paragraphs differently. Paragraph-count drift between sources is a real, silent-error risk. This judgment is flagged as a "verify paragraph count against at least two independent sources" case, given it's our anchor test.

---

## Case 3 — Composite Case: Existence-Fabrication + Misrepresentation, Supreme Court Level

**Case:** *Pooja Ramesh Singh v. Jammu and Kashmir Bank Ltd. and Anr.*, 2026 INSC 668
**Court:** Supreme Court of India
**Date:** Judgment dated 2 July 2026

**What happened:** An NCLT order admitting a company into insolvency, later affirmed by NCLAT, relied on six cited precedents. An affidavit placed before the Court confirmed these authorities could not be traced in any recognised legal database, exposing them as fabricated or "hallucinated" AI-generated citations. The impugned orders referenced purported precedents including *State Bank of India v. Shree Ram Urban Infrastructure*, 2020 SCC OnLine SC 341, *Everest Kento Cylinders v. Union of India*, (2015) 2 SCC 1, and *ICICI Bank v. Urban Infrastructure Real Estate*, (2019) 16 SCC 528 — three of six that simply do not exist.

The remaining citations are where it gets genuinely interesting: the sixth judgment cited was actually a different case altogether — the tribunal called it *State Bank of India v Shree Ram Urban Infrastructure Ltd*, but it was really *M Subramaniam v S Janaki*, and the quoted passage wasn't in either judgment.

The Supreme Court held that a decision built on fabricated material is "no decision in the eyes of law," and that even an "iota" of fake or hallucinated material entering the decision-making process is enough to void it. It also held that an advocate commits professional misconduct by citing AI-generated judgments without first verifying their authenticity.

**Why this single case is worth more to our ground truth than three separate ones:** it contains two distinct failure modes in one incident — realistic, since real fabricated filings rarely fail in only one clean way.

1. **Three citations → pure existence-fabrication** (case names that resolve to nothing).
2. **One citation → a case-identity swap:** the cited name belongs to no such holding, while a real, different, correctly-decided case (*M Subramaniam v S Janaki*) actually exists under a different identity. This is not simple misquoting — it's citation-identity substitution, where the name is fabricated but a real citation-shaped string exists elsewhere in the corpus. This is a genuinely nasty edge case for the existence check: a naive fuzzy string match on "State Bank of India v. Shree Ram Urban Infrastructure" against the corpus should correctly find nothing close and flag it as fabricated — but a *too-generous* fuzzy matcher could accidentally match it to some unrelated SBI case in the corpus and misclassify it. **Pipeline note:** the existence check's similarity threshold must be tight enough not to "helpfully" match a fabricated case name to an unrelated real one just because both involve the same bank.

**Verdict under our rubric:** this single incident produces two different verdicts across its six citations — a genuinely valuable multi-verdict ground-truth entry:
- **Three entries:** `FABRICATED` (existence)
- **One entry** (the case-identity swap): `FABRICATED` (existence) for the cited name specifically, annotated that a different, unrelated real case happens to be discoverable in the corpus under a similar party name — our best real-world instance of the "don't over-match on partial name similarity" boundary case.
- **Two entries** not detailed in public reporting: logged as `UNVERIFIABLE` until their exact status can be confirmed from the primary order — not silently assumed fabricated just because the pattern fits. This is the same discipline the tool itself is meant to enforce.

---

## Ground-Truth Record — Field Shape (design reference for Sprint 5)

Every entry in `labeled_test_set.json` should carry, at minimum:

- **case_citation_as_written** — exactly as it appears in the source document, unnormalized
- **claimed_paragraph** — if any
- **claimed_quote** — if any, verbatim
- **category** — taxonomy label including sub-variant (e.g. `existence.identity_swap`, not just `existence`) — see `taxonomy.md`
- **expected_verdict** — one of the four rubric verdicts
- **reasoning** — one sentence on why this verdict is correct
- **source** — `real_incident` or `synthetic`; if real, cite back to this file
- **difficulty** — easy / medium / hard
