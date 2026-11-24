---
name: fast-reading-design
description: The Fast Reading design system in docs/design is the single source of truth for how the app looks and behaves. Use this skill for ANY work in this repository that touches what a user sees or feels, even if the request does not say "design": building or changing a screen, widget, exercise, theme, color, font, spacing, icon, animation, empty state, error state, copy on a button, navigation, the Piko mascot, or reviewing a pull request with UI changes. Also use it when an issue mentions a screen name (Today, Exercises, My Text, Progress, Settings, Test, Result, Phrase Wave, Meaning Bridges, Info Hunter, Memory Map, Read & Check) or when you are unsure how something should look.
---

# Fast Reading design system

Every screen, widget and animation in this app follows the interactive design
in `docs/design/`. It was agreed by the team and the lecturers will compare
the app against it. Treat it like a spec, not like inspiration: if the design
shows it, build it that way. If you change the look, change the design first.

## Why this matters

- Four people build different screens in parallel. The design is what keeps
  them looking like one app.
- The design already answers most "how should this look" questions,
  including states people forget: empty, loading, wrong answer, locked,
  paused, finished.
- Reviews check the app against the design. Guessing costs a review round.

## Where to find what

All design files are in `docs/design/`. Each `.dc.html` file is one screen or
board, written as plain HTML with inline styles. Exact values (colors, sizes,
radius, spacing, shadows) are in the `style` attributes. Behavior (states,
timings, rules) is in the `<script>` block, in `renderVals()` and the
handlers.

| You are working on | Open these files |
| --- | --- |
| Theme, colors, fonts, spacing, radius, shadows, glass | `Color`, `Type`, `Space`, then `references/tokens.md` |
| Buttons, chips, switches, fields, answers, progress | `Controls` |
| Icons | `Icons` |
| Animations and transitions | `Motion` |
| Piko the mascot, app icon | `Piko`, `PikoMark` |
| Navigation, what opens what | `Topology`, `TabBar` |
| A screen or an exercise | `references/screens.md` maps every screen to its file and issue |
| Exercise card states and level progression | `GalleryProgress` |
| Every state of an exercise | `GalleryA` (01 to 04), `GalleryB` (05 to 08) |

To see them working, run a local server (scripts are blocked from disk):

```bash
cd docs/design
python -m http.server 8000
```

Then open `http://localhost:8000/Main.dc.html` or any other page. Links and
buttons work, so you can click through a whole round. If you cannot run a
browser, read the file: the HTML is the spec.

## How to work

1. **Find the design first.** Before writing UI code, open the matching file
   from `references/screens.md` and the gallery row for that exercise. Note
   every state it shows.
2. **Use tokens, not raw values.** Colors, text styles, spacing, radius and
   durations come from the theme (`lib/src/core/theme/`, issue #23). If a
   token is missing there, add it to the theme with the value from
   `references/tokens.md`, then use it. Never hardcode a hex color or font
   size in a widget.
3. **Build every state the design shows.** Default, selected, correct, wrong,
   locked, paused, finished, empty. A screen without its empty or error state
   is not done.
4. **Copy text from the design.** Button labels, titles and hints are in
   English in the design and go into the ARB files (#24), not into widgets.
5. **Match motion.** Use the durations and curves from `Motion`. Respect
   reduced motion: every animation must have a calm fallback.
6. **Compare before you open a PR.** Put the running app next to the design
   page and check spacing, sizes, colors and states. Add a screenshot of both
   to the PR.

## Rules that are easy to break

- **Text comes first.** Nothing moves or sits on top of a text while the user
  is reading it. Phrase Wave moves only the highlight behind the text. Piko
  is never shown on a reading screen.
- **Glass only for chrome.** The Liquid Glass look (blur, light rim) is only
  for the floating tab bar, the round buttons and chips in screen headers,
  the segmented control on Progress, and sheets. Exercise screens and cards use solid
  surfaces.
- **Speed counts only when the test is passed** (at least 2 of 3, rounded up
  for 4 to 5 questions). Below that, WPM is shown, marked "not counted" and
  left out of averages. Every result, chart and history row follows this.
- **Two taps to start.** Exercise card, then Start on the intro. The intro
  preselects the current level. Today's plan starts in one tap.
- **Levels:** 3 per exercise, 3 passed sessions unlock the next one. A failed
  session never removes progress. No points, no currency, no leaderboard.
- **Category colors mean something:** reading/scanning green, comprehension
  coral, memory violet. Do not reuse them for other meanings.
- **Small green text uses green 700 (`#106350`).** Green 600 (`#16846C`) is
  for buttons, icons and big numbers only, it fails contrast on paper.
- **Touch targets are at least 44 × 44.** Primary buttons are 54 to 56 high.
- **Exercises 06 to 08 are locked** in the app. Their screens exist only as
  previews in the design.

## When the design and an issue disagree

The issue decides **what** the feature does. The design decides **how it looks
and moves**. If they really conflict, or the design has no answer (a new
state, a new screen), do not invent a new style: reuse the closest existing
pattern from `Controls` and the screens, and ask Nikodem in the PR. If the
answer changes the look, the design in `docs/design/` gets updated in the
same PR or right after it.

## Reviewing a PR

Check UI changes against the design the same way: open the design page,
compare states and values, and flag hardcoded colors or sizes, missing states,
glass on content, motion over text, and WPM counted for failed tests.
