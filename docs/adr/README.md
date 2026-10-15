# Architecture Decision Records

An Architecture Decision Record (ADR) is a short document that captures one
important technical decision: the context, the options we considered, what we
chose and what follows from it. ADRs let anyone on the team (and our
lecturers) understand *why* the project looks the way it does.

## When to write an ADR

Write one when a decision is hard to reverse or affects the whole team, for
example:

- choosing a state management approach or a database
- adding a major dependency or service
- changing the project structure or a team-wide convention

Small, local choices do not need an ADR.

## How to add one

1. Copy [`0000-template.md`](0000-template.md) to
   `NNNN-short-title.md`, using the next free number
   (e.g. `0002-routing-with-go-router.md`).
2. Fill it in with status **Proposed** and open a pull request.
3. Discuss it in the PR. Once the team agrees, change the status to
   **Accepted** and merge.
4. Add it to the index below.

ADRs are never deleted. If a decision changes, write a new ADR and mark the
old one as **Superseded by ADR-NNNN**.

## Index

| ADR  | Title                                         | Status  |
| ---- | --------------------------------------------- | ------- |
| 0001 | State management and local storage (see #2)   | Pending |
