# Design system

Interactive design of Fast Reading: foundations, navigation map, every screen and all 8 exercises.

## Pages

- **Foundations:** `Main`, `Color`, `Type`, `Space`, `Icons`, `Controls`, `Motion`, `Piko`
- **Topology:** `Topology`
- **Screens:** `Onboarding`, `Today`, `Exercises`, `MyText`, `Progress`, `Settings`, `RoundIntro`, `Test`, `ResultPass`, `ResultFail`
- **Exercises:** `ReadCheck`, `PhraseWave`, `MeaningBridges`, `InfoHunter`, `MemoryMap`, `Recall`, `Fading`, `Shorten`, `Associations`, intros `Intro01Read` to `Intro05Map`
- **Exercise gallery:** `GalleryProgress`, `GalleryA`, `GalleryB`

Shared components: `PikoMark`, `TabBar`, `ExPreview`, `ExIntro`. `canvas.json` keeps the page layout.

## How to open

```bash
cd docs/design
python -m http.server 8000
```

Then open http://localhost:8000/Main.dc.html. Opening the files straight from disk doesn't work, browsers block the scripts.

Links and buttons work, so you can click through the app starting from `Today.dc.html` or `Exercises.dc.html`.

## Notes

- Exercises 06 to 08 are locked in the app, their screens are previews for later.
- Colors, type, spacing and radius here are the source for the theme in #23.
