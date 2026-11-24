# Design tokens

Values from `docs/design/Color`, `Type`, `Space`, `Icons`, `Motion` and
`Piko`. These are the values the theme in `lib/src/core/theme/` (#23) must
expose. If this file and the design page ever differ, the design page wins
and this file gets fixed.

## Contents

- Color
- Typography
- Spacing and sizes
- Radius
- Elevation
- Liquid Glass
- Motion
- Icons
- Piko

## Color

### Brand and surfaces

| Token | Hex | Use |
| --- | --- | --- |
| `bg.base` (Paper) | `#F7F5EE` | App background |
| `bg.reader` | `#FBFAF6` | Reading screens |
| `surface` | `#FFFFFF` | Cards, fields, answers |
| `text.primary` (Ink) | `#163B34` | Main text, dark cards, 11.26:1 on paper |
| `text.secondary` | `#4F655B` | Body text, 5.75:1 |
| `text.tertiary` (Muted) | `#55695F` | Labels, captions, 5.39:1 |
| `border.hairline` | `#DCE3DD` | Card and field borders |
| `accent` (Green 600) | `#16846C` | Primary buttons, active states, icons, big numbers |
| `accent.text` (Green 700) | `#106350` | Links and small green text |
| `card.dark` (Green 800) | `#24564C` | Panels on dark cards |
| `reading.highlight` | `#C9E9D7` | Phrase Wave highlight, found words |
| `error` | `#B4533F` | Wrong answers, destructive actions, 4.53:1 |
| `chart.notCounted` | `#E8B4A6` | Bars and items below 2/3 |
| `brand.gem` | `#EDBD60` | Piko's gem, unlock icon |
| `streak.flame` | `#B36B12` | Flame icon only |
| `streak.text` on `streak.bg` | `#8B6121` on `#F8EAC7` | Streak chip, "New" badge |
| `disabled.bg` / `disabled.text` | `#E6ECE4` / `#8A9A92` | Disabled buttons |

### Green scale

50 `#EEF8F3` · 100 `#DCF0E5` · 150 `#C9E9D7` · 300 `#8ACFB2` · 400 `#4FB893` ·
500 `#2FA585` · 600 `#16846C` · 700 `#106350` · 800 `#24564C` · 900 `#163B34`

### Categories

| Category | Tint | Ink | Accent | Exercises |
| --- | --- | --- | --- | --- |
| Reading, scanning | `#DCF0E5` | `#106350` | `#16846C` | Read & Check, Phrase Wave, Fading Text |
| Comprehension | `#FCECE6` | `#974E3D` | `#E68A73` | Meaning Bridges, Info Hunter, Shorten the Paragraph |
| Memory | `#EDE8FA` | `#5B4691` | `#8872CA` | Memory Map, Associations, recall test |

### Dark appearance

bg `#0F2420` · surface `#163B34` · raised `#24564C` · accent `#4FB893` ·
text `#E8F1EC` · secondary `#9DB5AB` · reader page `#1B2A26` with text `#E3E8E2`

## Typography

Manrope for all UI. Literata only for texts the user reads. Both are bundled
as assets (OFL). Sentence case everywhere. Stats use tabular figures.

| Style | Size / line | Weight | Letter spacing |
| --- | --- | --- | --- |
| Display | 40 / 44 | 800 | −3.5% |
| Title 1 | 30 / 34 | 800 | −3.5% |
| Title 2 | 26 / 31 | 800 | −3% |
| Title 3 | 20 / 26 | 800 | −2% |
| Headline | 17 / 22 | 800 | 0 |
| Body | 15 / 22 | 500 | 0 |
| Callout | 14 / 20 | 700 | 0 |
| Footnote | 13 / 18 | 600 | 0 |
| Overline | 11 / 14 | 800 | +14%, uppercase |

Reader (Literata 400): small 17 / 29, medium 19 / 33, large 21 / 37
(default). 32 to 38 characters per line on a phone, paragraph spacing 0.8 em,
no justified text, no hyphenation. These sizes match `ReaderTextSize` in
`lib/src/features/settings/app_settings.dart`.

## Spacing and sizes

4 pt grid: 4 · 8 (chip gap) · 12 (card gap) · 16 (card padding) · 22 (screen
gutter) · 32 (section gap) · 48 (hero spacing).

Touch targets at least 44 × 44. Primary buttons 54 high (56 on round and
exercise screens), list rows 56, top bar buttons 44 round. Reference device
390 × 844, content starts below the safe area.

## Radius

xs 8 · sm 12 (badges) · md 16 (buttons, answers) · lg 20 (cards) · xl 26
(hero cards) · sheet 32 · pill 999 (chips, tab bar).

Nested shapes are concentric: inner radius = outer radius − padding.

## Elevation

Shadows are tinted with ink `rgba(22,59,52,…)`, never black.

| Level | Shadow | Use |
| --- | --- | --- |
| e0 | 1 px border `#DCE3DD`, no shadow | Most cards |
| e1 | `0 1 2 /.06` + `0 6 16 /.08` | Raised cards |
| e2 | `0 2 6 /.08` + `0 14 32 /.16` | Floating elements |
| e3 | `0 4 10 /.10` + `0 30 60 /.22` | Sheets, dialogs |

## Liquid Glass

Only for chrome: floating tab bar, header buttons and chips, the Progress
segmented control, sheets. Never on exercise screens or content cards.

| Material | Fill | Blur | Rim and light |
| --- | --- | --- | --- |
| `glass.regular` | white 55 to 58% | 24, saturate 180% | 1 px white 75%, inset top white 95%, shadow e2 |
| `glass.tinted` | gradient green 500 → 600 at 90 to 97% | 20 | 1 px white 35%, inset top white 50%, green shadow |
| `glass.dark` | ink 62% | 24 | 1 px white 16%, inset top white 20% |

Tab bar: floating pill, 16 from the sides, 26 above the bottom edge, 66 high,
4 items. The active item is a `glass.tinted` lens with a white icon and
label.

## Motion

| Token | Duration | Use |
| --- | --- | --- |
| micro | 120 ms | Toggles, checkmarks |
| quick | 180 ms | Button press (scale to 0.95) |
| standard | 240 ms | Push, fade |
| emphasis | 360 ms | Lens slide, sheets, shared element |
| celebrate | 600 ms | Result count-up, Piko, level unlock |

Curves: spring `cubic-bezier(.34, 1.56, .64, 1)` (Flutter:
`SpringDescription(mass: 1, stiffness: 380, damping: 26)`), standard
`cubic-bezier(.2, .8, .2, 1)`, exit `cubic-bezier(.4, 0, 1, 1)`. Lists rise
in a 40 ms stagger. Phrase Wave highlight: about 320 ms ease between phrases.

Reduced motion: every move becomes a 150 ms crossfade. Only one celebration
per round. Correct answer: pop plus a light success haptic. Wrong answer:
shake plus a warning haptic.

## Icons

24 px grid, 2 px stroke, round caps and joins, outline by default. Sizes and
strokes: 16 / 2.4, 24 / 2, 32 / 1.75. The active tab uses the same glyph in
white on the green lens. Exercise glyphs sit on their category tint in the
category ink. On iOS the matching SF Symbol may replace a glyph.

## Piko

Moods: calm (default), happy, think, oops (encouraging after a miss), sleep
(empty states), celebrate (passed round, level up). Body `#16846C`, happy and
celebrate `#2FA585`, gem `#EDBD60`, white eyes with ink pupils. One Piko per
screen, one line of copy next to it, never on a reading surface, never
recoloured or outlined. The component lives in `docs/design/PikoMark.dc.html`
with the SVG paths for every mood.
