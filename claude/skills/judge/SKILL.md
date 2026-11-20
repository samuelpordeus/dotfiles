---
name: judge
description: Judge any output -- a code diff, a doc, a prompt or skill, an analysis, a tuning result, a design -- with isolated reviewers that each look through one lens, then adversarial verifiers that try to refute every finding with evidence. Also compares two versions (--compare) and measures its own recall on planted defects (--calibrate). Use when the user invokes /judge or asks for a rigorous review or verdict on something.
---

# Judge

Give a verdict on an artifact that survives scrutiny: few findings, each one
real, each one backed by evidence from outside the judge's own opinion.

The arguments say what to judge:

- nothing -> the working tree's diff (`git diff HEAD`, plus untracked files),
  or, outside a repo, the last substantial output in this conversation
- a path, a URL, a commit range, or "the last answer" -> that
- `--compare A B` -> which of two versions is better, and why
- `--calibrate` -> measure how well this judge catches defects (see below)
- anything else -> the goal or the lens to stress

## 1. Pin the target, the goal and the rules

Before any reviewer starts, write down three things. Every reviewer gets
these and nothing else from this conversation.

- **The artifact**, as a file. If it only exists in the conversation, save it
  to the scratchpad. Reviewers read the file, never a paraphrase of it.
- **The goal**: what the artifact is for and who it is for, in one or two
  sentences, taken from what the user asked for. If the goal cannot be
  told from the conversation, ask. Judging without a goal judges taste.
  If the work involves a Linear ticket (mentioned, or `REG-XXXX` in the
  branch name), fetch the issue, its sub-issues, and its project if it has
  one, plus the comments on each, and take the goal and acceptance criteria
  from them. When a comment conflicts with a description, the newer one
  wins.
- **The house rules**: `CLAUDE.md`, `AGENTS.md`, style guides, and the
  `docs/` file that covers the touched area. Then the past verdicts in
  `~/.claude/judge/verdicts.md`, if it exists. These say which kinds of
  finding the user has dismissed before.

Never pass the reasoning that produced the artifact. A reviewer who has read
why something was done tends to agree with it.

## 2. Choose four or five lenses

Each lens is one narrow question. Choose for this artifact and this goal.
Always include these three:

- **Goal**: does it do what it was for, for the person it was for? Is
  anything asked for missing? With a Linear ticket, check it against the
  issue, its sub-issues, and the project goal, one acceptance criterion at a
  time, and flag anything missing, partial, or out of scope.
- **House rules**: does it break a rule from step 1? Treat each recurring
  bug that the rules list as its own check.
- **Simplicity**: is any part heavier than the problem needs? Look for
  machinery built for cases that can't happen or barely matter, new
  abstractions where an existing pattern in the codebase would do, and
  steps that could be dropped without the goal suffering. For code, also
  read two or three neighboring modules that do similar work and flag where
  the artifact departs from their structure, naming, helpers, or idioms
  without a reason. Each finding names the simpler alternative, or the
  existing file it should follow.

Then add one or two that fit what the artifact is:

| Artifact | Candidate lenses |
|---|---|
| code | correctness on edge inputs; state and concurrency; what changes for existing callers |
| docs or prose | does every claim hold against the source; what a newcomer cannot follow; what is stated twice or never |
| prompt or skill | where a literal reading does the wrong thing; ambiguous instructions; missing stop conditions; cost |
| analysis or numbers | sample size and noise; confounds; would a different measurement disagree; arithmetic |
| design or UI | the user's first ten seconds; states that are not drawn (empty, error, overflow); consistency with the rest |

Write each lens as a question with a clear "no findings" answer.

## 3. Find: isolated reviewers, in parallel

Start one fresh agent per lens, all in one message with the Agent tool. Use
`general-purpose` or `Explore`. **Never `fork`**: a fork inherits this
conversation, which is exactly what a reviewer must not see.

Each reviewer's prompt holds: the artifact path, the goal, the house rules
(paths, plus the relevant excerpts), its one lens, and this contract:

> Return at most 5 findings for your lens only, worst first. For each:
> location (file:line, section, or quote), the defect in one sentence, a
> concrete failure scenario (this input or reader or situation -> this wrong
> result), severity (blocker / major / minor), and the cheapest evidence that
> would prove it -- a command, a test, a source to check against.
> "No findings" is a good answer when it is true. Do not suggest stylistic
> preferences as defects. Do not edit anything.

## 4. Verify: try to refute every finding

Merge duplicates across lenses. Then hand each finding to a new fresh agent
whose job is to **disprove** it. Batch small findings that touch the same
place into one agent.

The verifier gets the artifact, the goal, the rules and the one finding. It
must gather the strongest evidence it can, in this order of preference:

1. **Executed**: it ran something. A build, a test, a script, a fixed-seed
   replay, a reproduction of the failure scenario, or the numbers
   recomputed. Run only read-only checks, against copies in the scratchpad.
2. **Sourced**: it quoted the line, the doc, or the spec that settles it.
3. **Argued**: reasoning only. This alone cannot make a finding CONFIRMED.

It returns **CONFIRMED** (the evidence reproduces the failure), **PLAUSIBLE**
(the evidence supports it but did not reproduce it) or **REFUTED** (with
what disproved it). Drop REFUTED findings and keep a count of them.

## 5. Report

- If the artifact is code and a `ReportFindings` tool is available, use it,
  with `verdict` set. Otherwise give a list ranked by severity: the
  defect, the failure scenario, the evidence, the verdict.
- At most 10 findings. If there are none, say so plainly. That is a result,
  not a failure.
- After the findings, give **suggested fixes in order, if any**, as a table
  with columns `#`, `Fix`, `Findings`, `Effort`, `Required`. Highest impact
  first; on equal impact, lower effort first. `Fix` is one line. `Effort` is
  S (a few lines, one file), M (several files or a new test), or L (a design
  change). `Required` is yes for blockers and majors, optional otherwise.
  Merge findings when one fix covers several. With no findings, there is
  nothing to fix; never invent fixes to fill the table. Follow the
  fix-sizing rule below.
- For code, state the verdict on its own line: **Approved** (ready to become
  a Pull Request) when no confirmed or plausible blocker or major finding
  remains, otherwise **Not yet approved**, followed by the fix numbers that
  must land first.
- End with what was **not** checked: lenses not run, evidence that could not
  be gathered, and how many findings were refuted.
- Do not fix anything unless the user asks. Never post comments, replies or
  reviews anywhere outside this session.
- When the user does ask for fixes, pick the smallest one that matches a
  pattern already in the codebase, and size it to how likely the failure is.
  A rare race doesn't call for a new locking scheme when a guarded update
  the code already uses would do.

## --compare A B

The same lenses, but each reviewer answers "which is better through this
lens, and what is the decisive difference?", or "no difference". Run every
lens twice, with A and B swapped and relabelled, because the first one shown
gets favoured. A lens where the two orders disagree counts as a tie. Report a
verdict per lens, the decisive differences, and an overall call that says
which lenses carried it.

## --calibrate

This measures the judge, not the artifact.

1. Copy the artifact to the scratchpad. Never touch the original.
2. Plant 2-3 realistic defects in the copy, of the kinds the house rules and
   lenses should catch: one subtle, one ordinary, and at most one obvious.
   Write the answer key to a separate file that no reviewer is given.
3. Run steps 2-4 on the copy, unchanged. The reviewers must not know
   that anything was planted.
4. Score it: planted defects found (recall), and findings on lines that were
   not planted. Check each of those: a real pre-existing defect is a bonus,
   noise counts against.
5. Report the score, and which lens missed what. If a lens misses a defect
   it should own, rewrite its question.

## Learn from the user's response

When the user acts on findings or dismisses them, append one line per
finding to `~/.claude/judge/verdicts.md` (create the folder if needed):
date, repo, lens, the kind of finding, accepted or dismissed, and why. Step 1
reads this file, so findings like ones dismissed before need stronger
evidence before they are reported.
