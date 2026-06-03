# AGENTS.md

## Project

**Name:** Discography Database  
**Client:** TBD  
**Description:** A generic discography database with REST API, web UI, and MCP server for querying and managing an artist's recorded works.  
**Tech stack:** PostgreSQL · TypeScript · Node.js · Express · React · Tailwind CSS · MCP (TBD)  
**Created:** 2026-05-25

---

## Operating Model

This project uses the 120x Architect / Builder methodology.  
The handoff is a folder, not a conversation.  
The Builder reads project files before making changes and builds to the approved sprint blueprint.

---

## First Files to Read

Read these in order at the start of every session:

1. `AGENTS.md`
2. `planning/STATE.md`
3. `planning/DECISIONS.md`
4. `planning/DOMAIN.md`
5. Active sprint files under `planning/sprints/`
6. Relevant docs under `docs/`

---

## Project Structure

```text
.
├── docs/                  # Durable technical documentation
├── planning/              # Planning, domain context, decisions, risks, sprints
├── src/                   # Production application code
├── tests/                 # Automated tests
├── scripts/               # Utility scripts
├── samples/               # Local sample data; gitignored if sensitive
└── references/            # Reference material
```

---

## Builder Rules

- Do not redefine project scope.
- Do not invent business rules.
- Do not overwrite existing files without explicit approval.
- Do not store secrets in the repo.
- Prefer small, testable changes.
- Update `planning/STATE.md` at the end of each meaningful session.
- Record durable decisions in `planning/DECISIONS.md`.
- Update `docs/ARCHITECTURE.md` when architecture changes.
- Add or update tests when behavior changes.

---

## Sprint Workflow

Each sprint lives in `planning/sprints/###-{sprint-name}/` and includes:

- `requirements.md` — what and why
- `blueprint.md` — how to build it
- `acceptance.md` — what done means
- `handoff-prompt.md` — exact Builder prompt

---

## Completion Standard

A task is complete only when:

- The requested behavior is implemented.
- Relevant tests pass or a clear reason is documented.
- Acceptance criteria are satisfied.
- State and documentation are updated.
- Unresolved risks or questions are recorded.
