/// The training skill an exercise focuses on.
enum ExerciseCategory {
  reading('Reading'),
  comprehension('Comprehension'),
  memory('Memory');

  const ExerciseCategory(this.label);

  final String label;
}

/// The current difficulty of an exercise the user has started.
enum ExerciseLevel {
  one,
  two,
  three;

  /// The level number displayed on a card.
  int get number => index + 1;
}

/// The exercise catalog in the order shown on the Exercises screen.
enum Exercise {
  readAndCheck(
    1,
    ExerciseCategory.reading,
    'Read & Check',
    'Read at your own pace and check what you understood.',
  ),
  phraseWave(
    2,
    ExerciseCategory.reading,
    'Phrase Wave',
    'Follow the highlighted phrases to practise your reading rhythm.',
  ),
  meaningBridges(
    3,
    ExerciseCategory.comprehension,
    'Meaning Bridges',
    'Connect ideas from the text and explain how they relate.',
  ),
  infoHunter(
    4,
    ExerciseCategory.comprehension,
    'Info Hunter',
    'Scan a text to find specific details quickly.',
  ),
  memoryMap(
    5,
    ExerciseCategory.memory,
    'Memory Map',
    'Rebuild a map of the main ideas from memory.',
  ),
  fadingText(
    6,
    ExerciseCategory.reading,
    'Fading Text',
    'Keep your reading pace as the letters fade.',
    isLocked: true,
  ),
  shortenTheParagraph(
    7,
    ExerciseCategory.comprehension,
    'Shorten the Paragraph',
    'Pick the most important sentences to build a summary.',
    isLocked: true,
  ),
  associations(
    8,
    ExerciseCategory.memory,
    'Associations',
    'Link words with images, then recall them without the images.',
    isLocked: true,
  );

  const Exercise(
    this.number,
    this.category,
    this.title,
    this.description, {
    this.isLocked = false,
  });

  final int number;
  final ExerciseCategory category;
  final String title;
  final String description;
  final bool isLocked;
}
