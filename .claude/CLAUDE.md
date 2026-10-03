## Writing — No "Not X, But Y" Antithesis

Never use the contrastive negation-for-emphasis construction, in any prose I'll
read or send (docs, comments, replies, commit messages, explanations). It's
irritating filler. Forbidden shapes include:

- "That's not the patch size, it's the decode buffer."
- "X isn't the constraint — Y is." / "The point isn't A; it's B."
- "It's not just A, it's B." / "Not because A, but because B."
- Any "not ___, ___" / "___ isn't ___; ___ is" rhythm used to build to a point.

State the point directly in a plain declarative sentence. For a genuine
contrast, name both sides without the setup ("A and B both cost memory; B
dominates on an MCU"). A normal factual negation ("this codec doesn't support
windows") is fine.

## Python Type Hints — Don't Stringify Unnecessarily

Do NOT wrap a type annotation in quotes unless it's actually required. A name
needs quoting only when it isn't available at runtime — e.g. a `TYPE_CHECKING`-
only import, or a genuine forward reference to something defined later. Runtime
builtins (`dict`, `list`, `tuple`, ...) and anything really imported at module
scope (`Optional`, `Union`, etc.) must stay bare.

- Quote only the unavailable *name*, not the whole annotation:
  `Optional["Console"]`, not `"Optional[Console]"`; `dict[str, "Foo"]`, not
  `"dict[str, Foo]"`.
- `dict[str, str]`, `list[int]`, `int | None` — never quote these.

## Markdown Destined for GitHub (release notes, PR bodies, issues, comments)

When writing any Markdown that will be copy/pasted into GitHub (release notes,
PR descriptions, issue/PR comments, etc.), do NOT hard-wrap prose. Put each
paragraph and each list item on a single line, however long. GitHub renders a
single newline inside a paragraph as a literal line break, so hard-wrapped text
shows up with ragged mid-sentence breaks. Only use real newlines for actual
paragraph/list-item/section boundaries (blank line between blocks).

## Brian's Voice (Drafting Replies/Comments as Him)

When drafting text I'll send as myself — GitHub issue/PR replies, comments,
messages to other people — match my natural voice, not polished "AI" prose:

- Conversational, first-person. Open by engaging the person and framing intent
  ("let me see if I can address your points"), not with a summary.
- Lead with the verdict, then explain ("...is intentional. There's 2 concepts
  going on here:").
- Invite dialogue instead of declaring: "but you tell me!", "I'd argue", "I
  think". Comfortable admitting arbitrariness/uncertainty ("I think it's a
  fairly arbitrary choice, but that was the reasoning behind it").
- Numerals over spelled-out numbers ("2 concepts", not "two").
- Hyphenated compound descriptors: "place-holder-value", "positional-name",
  "usage-strings", "old-default".
- Parenthetical asides for caveats/clarifications ("(based on their python
  variable name)", "(but you tell me!)").
- Flowing paragraphs — NOT section headers or bullet lists — for a reply or
  comment. (Bullets/headers are fine in my own planning docs, just not in prose
  sent to a person.) A short reply doesn't need a "thanks + recap" preamble.
- *Italics* on the key contrasting nouns (the *value* vs the *identifier*).
- Casual register is on-brand: lowercase "python", "kind of", "falls out of",
  mild run-ons. Don't stiffen it into formality.
- Still fix outright typos (its/it's, subject-verb) unless told to leave it
  verbatim, and keep the GitHub no-hard-wrap rule above.

## Stacked PRs on GitHub

A PR whose base is another open PR's branch can be part of a GitHub native stack
(verified 2026-09-28). While stacked:

- `gh pr merge` and `gh pr edit --base` both FAIL ("part of a stack"). So
  "retarget the child to main before merging the base" is impossible.
- Merge through the async REST API, pinned to the tested head:
  `gh api -X PUT repos/O/R/pulls/N/merge-async -f sha=<full head sha> -f merge_method=merge -f merge_action=direct_merge`
  (HTTP 202 returns a `uuid`), then poll
  `gh api repos/O/R/pulls/N/merge-async/<uuid> --jq .status` until
  `merged`/`failed`. Merging N also merges any open PRs *below* it.
- After the bottom PR merges, GitHub retargets the child to main and rebases it
  itself (new SHAs, same patches). Verify with
  `git range-diff <old-base>..<old-head> origin/main..origin/<child-branch>`
  (all `=` means identical); don't rebase/force-push it yourself. CI reruns.
- Never `--delete-branch` a base that still has a child on it (GitHub
  auto-closes the child, and it may not reopen after a force-push).

Before merging 2 PRs that touch the same code in either order, merge both into
a scratch worktree and run BOTH PRs' tests: a clean textual merge can still
break semantically. When rebasing a PR, also read its unresolved review threads.

When someone else has rebased a remote branch, the local copy is stale and
`gh pr checkout` can't fast-forward. Don't `git reset --hard` (the auto-mode
classifier blocks it); work on `git checkout --detach origin/<branch>` and push
with `git push --force-with-lease=<branch>:<expected-old-sha> origin HEAD:<branch>`.

## Prefer Multiple-Choice Questions

When I need to make a decision or answer open questions, ask them as multiple-choice (the AskUserQuestion tool) instead of listing them in prose. Put the recommended option first and mark it "(Recommended)", keep each option's description to the trade-off, and batch related questions together. Free-form prose questions are for things that genuinely can't be reduced to options.
