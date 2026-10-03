---
description: Wrap up the session — record lessons learned, trim stale memory/CLAUDE.md content, and flag unfinished business.
---

Wrap up this session. Work through the following, then report concisely.

## 1. Sweep for unfinished business

Check and report (fix only what is clearly safe, e.g. removing a worktree you created):

- Uncommitted or unstaged changes (`git status`), and whether the current branch has unpushed commits.
- Background tasks/agents still running.
- Git worktrees or stashes created this session that should be removed.
- Local-only artifacts the user should know about (e.g. gitignored root `*.md` working docs that exist only on this machine).

Do NOT push, commit, or delete the user's work without being asked — list these items for the user instead. (Exception: the `CLAUDE.md` commit in step 3.)

## 2. Record lessons learned

Identify durable, non-obvious knowledge from this session and persist it in the right place:

- **User/feedback/project/reference memories** (per the memory-system format, with frontmatter, `[[links]]`, and a `MEMORY.md` index line): corrections the user gave, confirmed working approaches, decisions made or still pending, project state a future session can't derive from git/code.
- **Project `CLAUDE.md`**: repo-specific gotchas any future session would otherwise rediscover the hard way (tooling quirks, test-harness traps, commands that don't work as expected). Match the file's existing structure and tone.
- Do NOT record: anything derivable from the repo, git history, or existing docs; session-only details; speculation. If something feels borderline, ask what was non-obvious about it and record that instead.
- If the session produced a committed doc (design doc, plan, CLAUDE.md section) that already holds the state, the memory is a short pointer to it plus only what the doc lacks (e.g. where to resume). Don't restate the doc's decisions.
- **Write current state, not history.** When updating a memory, rewrite the affected text to describe how things are now. Don't append a dated "(fixed 2026-…)" / "later …" note after the old claim; git and the docs hold the history. Keep a date only where it matters to a reader (when something was last verified, when a decision was made).

## 3. Trim stale information

- Re-read `MEMORY.md` and every memory file whose topic this session touched. Verify claims that are cheap to check (branches, files, flags, pending decisions still pending). Update entries that changed, delete entries that are now wrong or fully resolved, and convert relative dates to absolute.
- Skim the project `CLAUDE.md` for statements this session proved wrong or obsolete; fix them.
- Merge near-duplicate memories rather than adding a parallel one.
- **Size budget.** Each `MEMORY.md` index line stays at or under ~150 characters: a title and a hook, never a summary. Rewrite any over-long line you touch (and at least 2 others while you're there). Any memory file over ~5 KB gets pruned this run: drop what's resolved or derivable from the repo, and split unrelated topics into separate files. Report the `MEMORY.md` size before and after.
- **Commit `CLAUDE.md`.** If you edited a project `CLAUDE.md` and it is tracked by git (resolve symlinks first, e.g. a workspace `CLAUDE.md` pointing into a repo), always commit it: stage and commit only that file (`git commit -- <path>`, never `git add -A`), leaving other staged or unstaged changes alone. Push only if the repo's conventions say commits go straight to the default branch and get pushed.

## 4. Report

End with a short summary for the user:

- What was recorded (and where) and what was trimmed/updated, including the `MEMORY.md` size change.
- Unfinished business and local-only artifacts, each with a one-line pointer.
- The 1-3 most valuable next actions for a future session, if any.
