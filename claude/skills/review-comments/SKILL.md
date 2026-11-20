---
name: review-comments
description: Address unresolved code review comments on the PR tied to the current branch. Use when the user asks to handle PR feedback, review comments, or reviewer threads (including bot reviews like Greptile or CodeRabbit).
---

# Address PR review comments

Work through the unresolved review threads on the pull request for the current branch. Anything the user passed as arguments when invoking this skill is extra context — a specific thread to focus on, pre-approval to apply fixes, or instructions to skip certain feedback.

## Steps

1. Identify the branch with `git branch --show-current`. If it is `main` or `demo`, stop and ask which branch or PR to target.
2. Find the PR: `gh pr view --json number,title,url`. If there is no PR, stop and tell the user. If `gh` fails with `Could not resolve to a Repository`, an inherited `GITHUB_TOKEN` is shadowing the authenticated account — re-run the command prefixed with `env -u GITHUB_TOKEN` and keep that prefix for the rest of the session.
3. Fetch review threads and filter to `isResolved: false`:

   ```bash
   gh api graphql -f query='
     query($owner: String!, $repo: String!, $pr: Int!) {
       repository(owner: $owner, name: $repo) {
         pullRequest(number: $pr) {
           reviewThreads(first: 100) {
             nodes {
               id
               isResolved
               isOutdated
               path
               line
               comments(first: 20) {
                 nodes { author { login } body createdAt }
               }
             }
           }
         }
       }
     }' -f owner=OWNER -f repo=REPO -F pr=NUMBER \
     --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)'
   ```

   Get `OWNER`/`REPO` from `gh repo view --json owner,name`. If a GitHub MCP server is connected, `pull_request_read` with method `get_review_comments` works too, but it does not always expose thread IDs — you need those to resolve threads later.
4. For each unresolved thread, read the comment, the code it points at, and enough surrounding context to judge the concern. Outdated threads (`isOutdated: true`) often mean the code already moved — check before assuming the comment still applies.
5. Triage each thread as:
   - **Fix** — the comment is valid; implement the change.
   - **Skip** — already handled by a later commit, out of scope, or a question the user will answer themselves. Record why.
6. Present the triage list to the user before touching any code. Apply fixes only after confirmation, unless the invocation arguments already pre-approved them.
7. For each fix, follow the repo's AGENTS.md / CLAUDE.md conventions and run the relevant checks — the full check suite (e.g. `mix check.all`) or just the affected test file when that is faster.
8. Never post replies or comments to GitHub — the user writes their own. Resolve only fully-addressed threads, and only after the user confirms:

   ```bash
   gh api graphql -f query='
     mutation($id: ID!) {
       resolveReviewThread(input: { threadId: $id }) { thread { isResolved } }
     }' -f id=THREAD_ID
   ```
9. Report back: threads fixed, threads resolved, threads skipped and why, plus local verification results. Never commit or push without explicit approval.
