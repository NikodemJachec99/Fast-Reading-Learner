# ADR-0001: State management and storage

- **Status:** Accepted
- **Date:** 2026-11-24
- **Deciders:** Nikodem Jacheć
- **Issue:** #2

## Context

Every feature needs shared state (settings, the current round, history) and
data that survives a restart. What we store:

- finished sessions (exercise, text, date, WPM, score, passed)
- own texts pasted by the user
- settings (language, text size, accent, reduced motion, name)

Constraints:

- The app runs on Android, iOS **and web**, and CI builds all three.
- The whole app runs on **Supabase** as its backend.
- No sign-up screen. Users should start training right away.
- 4 people with different Flutter experience: little boilerplate, no code
  generation, easy to test without a device.

## Options considered

### State management

**Riverpod** (`flutter_riverpod`)

- Pros: providers are easy to override in tests, no `BuildContext` needed
  to read state, handles sync and async state, no codegen required.
- Cons: new concepts to learn (providers, `ref`, notifiers).

**Bloc / Cubit**

- Pros: explicit, popular, good tooling.
- Cons: more boilerplate per feature, and repositories still need their own
  injection.

**Provider**

- Pros: simplest to start.
- Cons: tied to the widget tree, harder to test logic alone. Riverpod is its
  successor from the same author.

### Storage

**Supabase** (Postgres) for user data, **shared_preferences** for device settings

- Pros: real database with RLS, data survives reinstall and can move
  between devices, works on all three platforms through `supabase_flutter`.
  Anonymous sign-in gives every install a user without a sign-up screen.
- Cons: needs network for history and own texts. Two places to store data.

**Only local storage** (shared_preferences, drift, sqflite, Hive)

- Pros: works offline.
- Cons: data is lost with the app, nothing to build a backend on later.
  sqflite has no web support, drift on web needs extra setup and codegen.

## Decision

- **Riverpod 3 without code generation** for state. Each feature exposes
  its state with a `Notifier` + `NotifierProvider`.
- **Supabase** for user data: tables `sessions` and `user_texts`, one row
  owner per user, protected by RLS (`auth.uid() = user_id`). Schema lives
  in `supabase/migrations/`.
- **Anonymous sign-in** on first launch. Later we can link an email to the
  same user without losing data.
- **shared_preferences** only for device settings (text size, reduced
  motion, language, accent). They are read before the first frame and do
  not need an account.
- **Built-in texts** stay as JSON assets in the app (#25), so a round can
  start without network.
- Storage is only touched inside repository classes (`SettingsRepository`,
  `SessionRepository`, ...), each behind a provider. Widgets and notifiers
  never call Supabase or `SharedPreferences` directly. The pattern to copy
  is `lib/src/features/settings/`.

## Consequences

- `main()` loads `SharedPreferences`, initialises Supabase and wraps the app
  in a `ProviderScope`.
- Supabase URL and publishable key come from
  `--dart-define-from-file=config/supabase.json` (copy
  `config/supabase.example.json`). Builds without it, like CI, still start
  without a backend.
- Anonymous sign-ins must be turned on in the Supabase dashboard
  (Authentication › Sign In / Providers).
- Tests override `sharedPreferencesProvider` and `supabaseClientProvider`,
  so they never hit the network.
- Sessions finished offline need a small local queue that is sent later.
  That belongs to the round flow (#26).
- #40 (Progress) keeps its `SessionRepository` interface. Its
  shared_preferences implementation gets replaced by a Supabase one.
