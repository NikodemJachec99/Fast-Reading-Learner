# Screen map

Where each part of the app is designed, which issue builds it and what to
look out for. Design files are in `docs/design/` (drop the `.dc.html` when
searching). Code locations follow the existing layout: shared logic in
`lib/src/core/`, one folder per feature in `lib/src/features/`.

## Contents

- Navigation
- Main screens
- The round
- Exercises 01 to 05
- Exercises 06 to 08 (locked)
- Foundations and components

## Navigation

`Topology` is the map. Four tabs (Today, Exercises, My Text, Progress) in a
floating glass tab bar (`TabBar`, issue #3). Tabs keep their scroll position
and switch with a lens slide, never a push. Settings is a push with a round
back button. A round (intro, exercise, test, result) opens full screen
without the tab bar. Quit asks once, then returns to where the round started
and saves it as not completed.

## Main screens

| Screen | Design file | Issue | Must have |
| --- | --- | --- | --- |
| Onboarding | `Onboarding` | #12 | 3 steps, step dots, Skip, optional name, Piko happy |
| Today | `Today` | #32 | Greeting with name (or "Hi!"), streak chip, settings button, dark "Today's plan" card with Start session, last speed, last score, weekly ring, 3 exercise shortcuts, first launch state |
| Exercises | `Exercises` | #33 | Filters with counts, card with animated preview (`ExPreview`), category, level badge, 3 level segments, "2 of 3 sessions passed", states new, started, mastered, locked |
| My Text | `MyText` | #31 | Text field, word count, minimum 50 words, estimated time, saved texts, Read this text |
| Progress | `Progress` | #9 | 7 / 30 days segmented control, 3 stat tiles, WPM bars (green passed, coral not counted, grey none), streak card, history with "not counted" rows |
| Settings | `Settings` | #10 | Reader size with live preview, accent, reduce motion, language, name, show intro again, reset with confirm sheet |

## The round

| Step | Design file | Issue | Must have |
| --- | --- | --- | --- |
| Exercise intro | `ExIntro`, `Intro01Read` to `Intro05Map` | #26 | Big animated preview (shared element from the card), purpose, one-line how-to with Piko, 3 level tiles, current level preselected, Start Level N |
| Round intro from Today | `RoundIntro` | #26 | Sheet over Today with the 3 steps and start tempo |
| Comprehension test | `Test` | #8 | One question per screen, type chip, A to D, Check answer, correct green / wrong coral with explanation, Next, Quit |
| Result, passed | `ResultPass` | #27 | Dark screen, Piko celebrate, WPM count-up with change, score, level progress with unlock, last 5 sessions, Next text, Back to Today |
| Result, not passed | `ResultFail` | #27 | Piko oops, struck-through WPM "not counted", which question types were missed, suggested tempo, Try again, Review answers |
| Level rules | `GalleryProgress` | #26 | 3 passes unlock the next level, failures change nothing, mastered state |

## Exercises 01 to 05

Every exercise has the same frame: close button to its intro, overline
"TRAINING · STEP 1 OF 3", title, then its mechanic, then a bottom action that
leads to the shared test. Gallery rows in `GalleryA` and `GalleryB` show all
states.

| Exercise | Design file | Issue | Mechanic and states |
| --- | --- | --- | --- |
| 01 Read & Check | `ReadCheck` | #7 | Whole text scrolls, scroll drives the top progress bar, quiet timer, Aa cycles 3 sizes, Start, Finish reading. No highlight, no tempo |
| 02 Phrase Wave | `PhraseWave` | #5 | Still text, highlight glides and morphs between phrases, phrase time = words × 60000 / wpm, read phrases ink and upcoming muted, tempo 120 to 600 step 20 with a pulse, Start / Pause / Resume / Finish, L1 short phrases, L2 long, L3 every second phrase without highlight |
| 03 Meaning Bridges | `MeaningBridges` | #28 | Two columns of cards, drag a curve from left to right or tap both, correct snaps green, wrong turns coral and dissolves, passage behind a button, L1 relation labels, L2 none, L3 extra card |
| 04 Info Hunter | `InfoHunter` | #29 | Dark goal card with task dots and timer, tap exact words in the text, correct grows a green highlight, wrong flashes coral, 3 tasks, L3 has decoys like a similar year |
| 05 Memory Map | `MemoryMap` | #30 | Central topic, 4 branches, word bank, drag with magnetic snap (80 px) or tap word then branch, correct draws the branch, wrong shakes coral, L1 hints, L2 none, L3 distractors |
| Recall test (My Text) | `Recall` | #31 | 3 free-text prompts, Compare with the original, self-rating yes / partly / no per answer, saved as self-rated |

## Exercises 06 to 08 (locked)

Locked in the app: cards show a grey preview with a lock and open nothing.
Full previews exist only in the design.

| Exercise | Design file | Issue | Mechanic |
| --- | --- | --- | --- |
| 06 Fading Text | `Fading` | #34 | Letters behind the reading line fade in a soft gradient, layout never moves, speed follows tempo, reduced motion fades whole words |
| 07 Shorten the Paragraph | `Shorten` | #35 | Tap key sentences, they move into a summary box, remove reverses it, compare shows missed ideas and how much shorter it is |
| 08 Associations | `Associations` | #36 | Learn picture and word, pictures fade, recall the word per picture, review all pairs |

## Foundations and components

| Topic | Design file | Issue |
| --- | --- | --- |
| Overview and principles | `Main` | all |
| Color, type, space, radius, elevation, glass | `Color`, `Type`, `Space` | #23 |
| Controls (buttons, chips, segmented, switch, stepper, slider, answers, fields, progress, toast) | `Controls` | #23 |
| Icons | `Icons` | #23 |
| Motion | `Motion` | #23 |
| Piko and app icon | `Piko`, `PikoMark` | #12, #14 |
| Tab bar | `TabBar` | #3 |
| Exercise preview animations | `ExPreview` | #33 |
| Exercise intro | `ExIntro` | #26 |
