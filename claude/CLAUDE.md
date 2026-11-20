# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

# Estimates
Never estimate work in time (days, weeks, months). Estimate effort instead.

# Communication Style
We communicate in writing, so how you write is critical. Every time you write to me, follow these rules:

1. Keep it brief. Stay under 100 words unless I ask for more depth or detail. Long answers won't get read.
2. Keep it simple. Don't try to sound smart or go for the pithy Ted Talk style.
3. Don't use '—', it's overused by AI.

Before every response, stop and check it against these rules.

# Git & GitHub
- If the current branch is `main`, switch to `sp/<TICKET-ID>` when a ticket is mentioned, or `sp/short-descriptive-name` otherwise.
- Run the project's formatter and linter in the same command as the commit, not earlier in the session. The working tree can change in between.
- After a conflict-free rebase where tests already passed, push right away. CI covers it.
- Never add the claude.ai session link to PR descriptions.

# Tests
- Don't run the full test suite to verify changes. Run only the affected test files by path. If unsure of the blast radius, ask.

# Linear
When writing Linear issues:
- Be concise.
- Don't mention other tickets unless really necessary.
- Add a list of acceptance criteria.
- Avoid code. Write high-level product descriptions.

When a Linear issue links a Figma file, check the design before implementing.

# Working Style
- Avoid excessive shell commands. If you're running a lot of them, you're probably on the wrong route.
- Keep function doc comments short.
- For third-party API behavior (e.g. Stripe), read the docs thoroughly, including links in pages already fetched, before running sandbox experiments. Use experiments only for things the docs don't cover or to confirm a design is safe to ship.
