# Contributing

This document describes how our team works on the repository.

## Workflow

1. **Pick or create an issue.** Every piece of work should have an issue on the
   GitHub board. Assign yourself so others know you are working on it.
2. **Create a branch from an up-to-date `main`:**
   ```bash
   git switch main
   git pull
   git switch -c feature/12-rsvp-reader
   ```
3. **Commit small, focused changes** (see commit messages below).
4. **Push and open a pull request** into `main`. Fill in the PR template and
   link the issue (`Closes #12`).
5. **Get a review.** At least **one approval** from another team member is
   required. CI must be green.
6. **Merge** with *Squash and merge* and delete the branch.

Nobody can push directly to `main`. It is protected by a ruleset
([`.github/rulesets/main.json`](.github/rulesets/main.json)).

## Branch names

`<type>/<issue-number>-<short-description>`, for example:

- `feature/12-rsvp-reader`
- `fix/27-timer-not-stopping`
- `test/31-text-chunker-edge-cases`
- `docs/5-update-readme`
- `chore/8-update-dependencies`

## Commit messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add words-per-minute slider to reader screen
fix: stop timer when the reading session is paused
test: cover empty text in TextChunker
refactor: extract ReadingSession model
docs: describe project structure in README
chore: bump flutter_lints
```

Write the subject in the imperative mood, lower case, without a full stop.

## Tests

- Every new piece of logic in `lib/src/core/` needs **unit tests**.
- Every new screen or non-trivial widget needs at least one **widget test**.
- Tests live in `test/` and mirror the structure of `lib/`:
  `lib/src/core/reading/text_chunker.dart` → `test/src/core/reading/text_chunker_test.dart`.
- CI fails if line coverage drops below **70%**.
- Bug fixes should come with a test that fails without the fix.

Run everything CI runs before pushing:

```bash
dart format lib test
flutter analyze
flutter test --coverage
./scripts/check_coverage.sh
```

## Code style

- Formatting is enforced by `dart format`; enable *format on save* in your editor.
- Lint rules are configured in [`analysis_options.yaml`](analysis_options.yaml).
  If you think a rule should change, propose it in a separate PR.
- Keep business logic out of widgets: put it in `lib/src/core/` (or in a
  feature's own non-widget classes) so it can be unit-tested.
- Public classes and methods should have a short `///` doc comment.

## Code review

As an **author**:

- Keep PRs small (ideally under ~400 changed lines).
- Review your own diff first and make sure CI passes.
- Respond to every comment, either with a fix or an explanation.

As a **reviewer**:

- Try to review within 24 hours.
- Check that the change does what the issue asks, is tested, and is readable.
- Be kind and specific. Prefix optional suggestions with `nit:`.
- Use *Approve* only when you would be happy to maintain the code yourself.

Pushing new commits to a PR dismisses earlier approvals, so the final version
is always reviewed. All review conversations must be resolved before merging.
