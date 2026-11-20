---
name: fix-ci
description: Diagnose and fix failing CI checks for the PR tied to the current branch. Use when the user asks why CI is red, to fix a failing build, or to investigate a failed GitHub Actions run.
---

# Fix failing CI

Diagnose and fix the failing checks on the pull request for the current branch. Anything the user passed as arguments when invoking this skill is extra context — a specific check to focus on, a suspected cause, or a run ID.

## Steps

1. Identify the branch with `git branch --show-current`. If it is `main` or `demo`, stop and ask which branch or PR to target.
2. Find the PR: `gh pr view --json number,title,url,headRefName`. If there is no PR, stop and tell the user. If `gh` fails with `Could not resolve to a Repository`, an inherited `GITHUB_TOKEN` is shadowing the authenticated account — re-run the command prefixed with `env -u GITHUB_TOKEN` and keep that prefix for the rest of the session.
3. List check status with `gh pr checks` and identify what is failing. Distinguish failed from still-running — do not diagnose a check that has not finished.
4. Pull the actual failure output for each failing check. Do not guess from the check name:

   ```bash
   gh run list --branch "$(git branch --show-current)" --limit 10 --json databaseId,name,conclusion,workflowName
   gh run view --log-failed <run-id>
   ```

   `gh pr checks --json name,link,state` gives the run URLs when the mapping is unclear. Read enough of the log to find the root cause, not just the first red line — a formatter or compile failure early in a job often cascades.
5. Reproduce locally when feasible, using the commands the repo's AGENTS.md / CLAUDE.md documents (e.g. `mix check.all`, `bin/test/all`, or the single failing test file). A failure you cannot reproduce locally may be flaky or environment-specific — say so rather than papering over it.
6. Implement the minimal fix. Do not refactor unrelated code or expand scope.
7. Verify by re-running the local equivalent of the check that failed, then the project's full checks (e.g. `mix format` and `mix check.all`).
8. Report: which checks failed, the root cause of each, the fix applied, and the local verification output. If a failure turned out to be flaky, infrastructure-related, or pre-existing on the base branch, say that instead of inventing a fix. Ask before committing or pushing — never push without explicit approval.
